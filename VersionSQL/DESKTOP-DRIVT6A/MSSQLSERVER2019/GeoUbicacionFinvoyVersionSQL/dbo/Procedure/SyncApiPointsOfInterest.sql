/****** Object:  Procedure [dbo].[SyncApiPointsOfInterest]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 20/04/2015
-- Description:	SP para sincronizar los PUNTOS DESDE LA API
-- =============================================
CREATE PROCEDURE [dbo].[SyncApiPointsOfInterest]
(
	 @SyncType [int]
	,@Data [PointOfInterestTableType] READONLY
	,@DataHour [HourWindowTableType] READONLY
)
AS
BEGIN
	SET ANSI_WARNINGS  OFF;

	DECLARE @Now [sys].[datetime]
	SET @Now = GETUTCDATE()

	DECLARE @Add [int] = 0
	DECLARE @AddUpdate [int] = 1
	DECLARE @AddUpdateDelete [int] = 2

	-- Update ingresados
	IF @AddUpdate <= @SyncType
	BEGIN
		UPDATE	PR
		SET		PR.[Identifier] = P.[Id],
				PR.[Name] = P.[Name],
				PR.[Address] = P.[Address],
				PR.[Latitude] = P.[Latitude],
				PR.[Longitude] = P.[Longitude],
				PR.[LatLong] = GEOGRAPHY::STPointFromText('POINT(' + CAST(P.[Longitude] AS VARCHAR(25)) + ' ' + CAST(P.[Latitude]AS VARCHAR(25)) + ')', 4326),
				PR.[Radius] = P.[Radius],
				PR.[MinElapsedTimeForVisit] = P.[MinElapsedTimeForVisit],
				PR.[IdDepartment] = P.[ProvinceId],
				PR.[ContactName] = P.[ContactName],
				PR.[Emails] = P.[Emails],
				PR.[ContactPhoneNumber] = P.[ContactPhoneNumber],
				PR.[NFCTagId] = P.[NFCTagId],
				PR.[GrandfatherId] = H1.[Id],
				PR.[EditedDate] = GETUTCDATE(),
				PR.[FatherId] = H2.[Id]--,
				--PR.[Deleted] = 0
		FROM	[dbo].[PointOfInterest] PR
				INNER JOIN @Data as P ON PR.[Identifier] = P.[Id]
				LEFT OUTER JOIN [dbo].[Department] D ON d.[Id] = P.[ProvinceId]
				LEFT OUTER JOIN [dbo].[POIHierarchyLevel1] H1 ON H1.[SapId] = P.[HierarchyLevel1Id]
				LEFT OUTER JOIN [dbo].[POIHierarchyLevel2] H2 ON H2.[SapId] = P.[HierarchyLevel2Id]
		WHERE	PR.[Deleted] = 0
			AND (P.[ProvinceId] IS NULL OR D.[Id] IS NOT NULL)
		    AND (H1.[Id] IS NULL OR H1.[Deleted] = 0)
			AND (H2.[Id] IS NULL OR H2.[Deleted] = 0)

		-- Actualizo laS AGRUPACIONES. Primero elimino todas las de los puntos que estoy actualizando
		DELETE FROM [dbo].[PointOfInterestZone]
		WHERE	[IdPointOfInterest] IN (SELECT PR.[Id] FROM [dbo].[PointOfInterest] PR WITH (NOLOCK)
										INNER JOIN @Data as P ON PR.[Identifier] = P.[Id])
		
		--INSERTO LAS NUEVAS
		INSERT INTO [dbo].[PointOfInterestZone]([IdPointOfInterest], [IdZone])
		SELECT	POI.[Id], Z.[Id]
		FROM	[dbo].[PointOfInterest] POI WITH (NOLOCK)
				INNER JOIN @Data P ON POI.[Identifier] = P.[Id]
				INNER JOIN [dbo].[Zone] Z WITH (NOLOCK) ON (P.[Zones] IS NOT NULL AND [dbo].[CheckVarcharInList](Z.[Description], P.[Zones]) > 0)
	

	END
	
	-- Delete faltantes
	IF @AddUpdateDelete <= @SyncType
	BEGIN	
		UPDATE	PR
		SET		PR.[Deleted] = 1
		FROM	[dbo].[PointOfInterest] PR
				LEFT OUTER JOIN @Data as P ON PR.[Identifier] = P.[Id]
		WHERE	PR.[Deleted] = 0 AND P.[Id] IS NULL

		DELETE 
		FROM	[dbo].[PointOfInterestHourWindow]
		WHERE	[IdPointOfInterest] in (SELECT Id from [dbo].[PointOfInterest] WITH (NOLOCK) WHERE [Deleted] = 1)

		DELETE 
		FROM	[dbo].[PointOfInterestZone]
		WHERE	[IdPointOfInterest] in (SELECT Id from [dbo].[PointOfInterest] WITH (NOLOCK) WHERE [Deleted] = 1)

		--Cuando se borra el punto tengo que eliminar las rutas para ese punt de ahora en mas.
		Update	[dbo].[RoutePointOfInterest]
		SET		[Deleted] = 1, [EditedDate] = @Now
		WHERE	[IdPointOfInterest] IN (SELECT PR.[Id] 
										FROM [dbo].[PointOfInterest] PR WITH (NOLOCK)
										LEFT OUTER JOIN @Data as P ON PR.[Identifier] = P.[Id]
										WHERE	PR.[Deleted] = 1 AND P.[Id] IS NULL)

		--Elimino todas las rutas que haya en RouteDetail posteriores a la fecha actual inclusive
		DELETE 
		FROM	dbo.[RouteDetail]
		WHERE	Tzdb.IsGreaterOrSameSystemDate([RouteDate], @Now) = 1 AND 
				[IdRoutePointOfInterest] 
				IN (SELECT [Id] 
					FROM [dbo].[RoutePointOfInterest] WITH (NOLOCK)
					WHERE	[IdPointOfInterest] IN (SELECT PR.[Id] 
													FROM [dbo].[PointOfInterest] PR WITH (NOLOCK)
													LEFT OUTER JOIN @Data as P ON PR.[Identifier] = P.[Id]
													WHERE	PR.[Deleted] = 1 AND P.[Id] IS NULL))

	END
	
	-- Obtengo los que no tiene referencia
	-- Si solo agrego Obtengo los repetidos antes de agregar los nuevos
	-- de lo contrario siempre van a existir	
	SELECT P.[Id], P.[Name], P.[Address], P.[Latitude], P.[Longitude], P.[Radius], P.[MinElapsedTimeForVisit], P.[ProvinceId], P.[ContactName], P.[ContactPhoneNumber], P.[NFCTagId], P.[HierarchyLevel1Id], P.[HierarchyLevel2Id]
			,IIF(P.[ProvinceId] IS NOT NULL AND D.[Id] IS NULL, 1, 0) -- 0 indicador repetido, 1 Departamento no existe
		  ,IIF(P.[HierarchyLevel1Id] IS NOT NULL AND (H1.[Id] IS NULL OR H1.[Deleted] = 1), 1, 0) -- 1 HierarchyLevel1 no existe
		  ,IIF(P.[HierarchyLevel2Id] IS NOT NULL AND (H2.[Id] IS NULL OR H2.[Deleted] = 1), 1, 0) -- 1 HierarchyLevel2 no existe
	FROM	@Data P
			LEFT OUTER JOIN [PointOfInterest] as PR WITH (NOLOCK) ON PR.[Identifier] = P.[Id] AND PR.[Deleted] = 0
			LEFT OUTER JOIN [dbo].[Department] D WITH (NOLOCK) ON d.[Id] = P.[ProvinceId]
			LEFT OUTER JOIN [dbo].[POIHierarchyLevel1] H1 WITH (NOLOCK) ON H1.[SapId] = P.[HierarchyLevel1Id] AND H1.[Deleted] = 0
			LEFT OUTER JOIN [dbo].[POIHierarchyLevel2] H2 WITH (NOLOCK) ON H2.[SapId] = P.[HierarchyLevel2Id] AND H2.[Deleted] = 0
	WHERE	(@Add = @SyncType AND PR.[Id] IS NOT NULL)
			OR (P.[ProvinceId] IS NOT NULL AND D.[Id] IS NULL)
			OR (P.[HierarchyLevel1Id] IS NOT NULL AND (H1.[Id] IS NULL OR H1.[Deleted] = 1))
			OR (P.[HierarchyLevel2Id] IS NOT NULL AND (H2.[Id] IS NULL OR H2.[Deleted] = 1))

	-- Insert nuevos 
	IF @Add <= @SyncType
	BEGIN	
    INSERT INTO [dbo].[PointOfInterest]([Identifier], [Name], [Address], [Latitude], [Longitude], LatLong, [Radius], 
		[MinElapsedTimeForVisit], [IdDepartment], [ContactName], [ContactPhoneNumber], [Deleted], [NFCTagId], [GrandfatherId], [FatherId], [Emails], [CreatedDate])
		SELECT  P.[Id], P.[Name], P.[Address], P.[Latitude], P.[Longitude], 
		GEOGRAPHY::STPointFromText('POINT(' + CAST(P.[Longitude] AS VARCHAR(25)) + ' ' + CAST(P.[Latitude]AS VARCHAR(25)) + ')', 4326), 
		P.[Radius], P.[MinElapsedTimeForVisit], P.[ProvinceId], P.[ContactName], P.[ContactPhoneNumber], 0, P.[NFCTagId], H1.[Id], H2.[Id], P.[Emails], GETUTCDATE()
		FROM    @Data P
				LEFT OUTER JOIN [PointOfInterest] as PR WITH (NOLOCK) ON PR.[Identifier] = P.[Id] AND PR.[Deleted] = 0
				LEFT OUTER JOIN [dbo].[Department] D WITH (NOLOCK) ON d.[Id] = P.[ProvinceId]
				LEFT OUTER JOIN [dbo].[POIHierarchyLevel1] H1 WITH (NOLOCK) ON H1.[SapId] = P.[HierarchyLevel1Id]
				LEFT OUTER JOIN [dbo].[POIHierarchyLevel2] H2 WITH (NOLOCK) ON H2.[SapId] = P.[HierarchyLevel2Id]
		WHERE   PR.[Id] IS NULL AND
				(P.[ProvinceId] IS NULL OR D.[Id] IS NOT NULL)
				AND (H1.[Id] IS NULL OR H1.[Deleted] = 0)
				AND (H2.[Id] IS NULL OR H2.[Deleted] = 0)

		--INSERTO LAS AGRUPACIONES
		INSERT INTO [dbo].[PointOfInterestZone]([IdPointOfInterest], [IdZone])
		SELECT	PR.[Id], Z.[Id]
		FROM	@Data P
				LEFT OUTER JOIN [PointOfInterest] as PR WITH (NOLOCK) ON PR.[Identifier] = P.[Id] AND PR.[Deleted] = 0
				LEFT JOIN [dbo].[Zone] Z WITH (NOLOCK) ON (P.[Zones] IS NOT NULL AND [dbo].[CheckVarcharInList](Z.[Description], P.[Zones]) > 0)
		where Z.[Id] IS NOT NULL AND PR.[Id] NOT IN (SELECT PZ.[IdPointOfInterest] FROM [dbo].[PointOfInterestZone] PZ WITH (NOLOCK)
													WHERE PZ.[IdPointOfInterest] = PR.[Id] AND PZ.[IdZone] = Z.[Id] )

		--INSERTO LAS AGRUPACIONES DE TODOS LOS PUNTOS DE INTERÉS
		DECLARE @IdZoneAllPoint [INT]
		SET @IdZoneAllPoint = (SELECT Z.[Id] FROM [dbo].[ZoneTranslated] Z WITH (NOLOCK) WHERE Z.[ApplyToAllPointOfInterest] = 1)

		IF @IdZoneAllPoint IS NOT NULL
		BEGIN
			INSERT INTO dbo.PointOfInterestZone
			SELECT P.[Id], @IdZoneAllPoint
			FROM [dbo].[PointOfInterest] P WITH (NOLOCK)
			WHERE P.[Deleted] = 0 AND P.[Id] NOT IN (SELECT PZ.[IdPointOfInterest] FROM [dbo].[PointOfInterestZone] PZ WITH (NOLOCK)
													WHERE PZ.[IdPointOfInterest] = P.[Id] AND PZ.[IdZone] = @IdZoneAllPoint)
		END
	END

	-- Actualizo ventan horaria
	IF @AddUpdate <= @SyncType
	BEGIN	
		UPDATE  PH
		SET		PH.[FromHour] = P.[FromHour],
				PH.[ToHour] = P.[ToHour]
		FROM	[PointOfInterestHourWindow] PH
				INNER JOIN [PointOfInterest] PR ON PR.[Id] =  PH.[IdPointOfInterest] AND PR.[Deleted] = 0
				INNER JOIN @DataHour P ON P.[Id] = PR.[Identifier] AND P.[Day] = PH.[IdDayOfWeek]
	END

	-- Elimino los que no existen
	IF @AddUpdateDelete <= @SyncType
	BEGIN	
		DELETE PH
		FROM	[PointOfInterestHourWindow] PH
				INNER JOIN [PointOfInterest] PR ON PR.[Id] =  PH.[IdPointOfInterest] AND PR.[Deleted] = 0
				LEFT OUTER JOIN @DataHour P ON P.[Id] = PR.[Identifier] AND P.[Day] = PH.[IdDayOfWeek]
		WHERE	P.[Id] IS NULL
	END

	-- Inserto nuevas ventanas horarias
	IF @Add <= @SyncType
	BEGIN	
		INSERT [dbo].[PointOfInterestHourWindow] ([IdPointOfInterest], [IdDayOfWeek], [FromHour], [ToHour])
		SELECT PR.[Id], P.[Day],  P.[FromHour], P.[ToHour]
		FROM	@DataHour P 
				INNER JOIN [PointOfInterest] PR WITH (NOLOCK) ON P.[Id] = PR.[Identifier] AND PR.[Deleted] = 0
				LEFT OUTER JOIN [PointOfInterestHourWindow] PH WITH (NOLOCK) ON PR.[Id] =  PH.[IdPointOfInterest] AND P.[Day] = PH.[IdDayOfWeek]
		WHERE	PH.[IdPointOfInterest] IS NULL
	END

	SET ANSI_WARNINGS  ON;

END
