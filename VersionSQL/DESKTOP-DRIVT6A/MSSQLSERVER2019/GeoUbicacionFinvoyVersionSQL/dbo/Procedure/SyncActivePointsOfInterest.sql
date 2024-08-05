/****** Object:  Procedure [dbo].[SyncActivePointsOfInterest]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SyncActivePointsOfInterest]
(
	 @Data [PointOfInterestTableType] READONLY
	,@DataHour [HourWindowTableType] READONLY
)
AS
BEGIN
	SET ANSI_WARNINGS  OFF;
	DECLARE @SyncType [int] = 2

	DECLARE @Add [int] = 0
	DECLARE @AddUpdate [int] = 1
	DECLARE @AddUpdateDelete [int] = 2

	DECLARE @Now [sys].[datetime]
    SET @Now = GETUTCDATE()

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
				PR.[FatherId] = H2.[Id]--,
				--PR.[Deleted] = 0
		FROM	[dbo].[PointOfInterest] PR
				INNER JOIN @Data as P ON PR.[Identifier] = P.[Id]
				LEFT OUTER JOIN [dbo].[Department] D ON d.[Id] = P.[ProvinceId]
				LEFT OUTER JOIN [dbo].[POIHierarchyLevel1] H1 ON H1.[Name] = P.[HierarchyLevel1Id]
				LEFT OUTER JOIN [dbo].[POIHierarchyLevel2] H2 ON H2.[Name] = P.[HierarchyLevel2Id]
		WHERE	PR.[Deleted] = 0
			AND (P.[ProvinceId] IS NULL OR D.[Id] IS NOT NULL)
			AND (H1.[Id] IS NULL OR H1.[Deleted] = 0)
			AND (H2.[Id] IS NULL OR H2.[Deleted] = 0)
	END
	
	-- Delete faltantes
	IF @AddUpdateDelete <= @SyncType
	BEGIN
		UPDATE	PR
		SET		PR.[Deleted] = 1
		FROM	[dbo].[PointOfInterest] PR
				LEFT OUTER JOIN @Data as P ON PR.[Identifier] = P.[Id]
		WHERE	PR.[Deleted] = 0 AND P.[Id] IS NULL

		--Cuando se borra el punto tengo que eliminar las rutas para ese punt de ahora en mas.
		Update	[dbo].[RoutePointOfInterest]
		SET		[Deleted] = 1, [EditedDate] = @Now
		WHERE	[IdPointOfInterest] IN (SELECT PR.[Id] 
										FROM [dbo].[PointOfInterest] PR
										LEFT OUTER JOIN @Data as P ON PR.[Identifier] = P.[Id]
										WHERE	PR.[Deleted] = 1 AND P.[Id] IS NULL)

		--Elimino todas las rutas que haya en RouteDetail posteriores a la fecha actual inclusive
		DELETE 
		FROM	dbo.[RouteDetail]
		WHERE	Tzdb.IsGreaterOrSameSystemDate([RouteDate], @Now) = 1 AND
				[IdRoutePointOfInterest] 
				IN (SELECT [Id] 
					FROM [dbo].[RoutePointOfInterest]
					WHERE	[IdPointOfInterest] IN (SELECT PR.[Id] 
													FROM [dbo].[PointOfInterest] PR
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
			LEFT OUTER JOIN [PointOfInterest] as PR ON PR.[Identifier] = P.[Id] AND PR.[Deleted] = 0
			LEFT OUTER JOIN [dbo].[Department] D ON d.[Id] = P.[ProvinceId]
			LEFT OUTER JOIN [dbo].[POIHierarchyLevel1] H1 ON H1.[Name] = P.[HierarchyLevel1Id]
			LEFT OUTER JOIN [dbo].[POIHierarchyLevel2] H2 ON H2.[Name] = P.[HierarchyLevel2Id]	
	WHERE	(@Add = @SyncType AND PR.[Id] IS NOT NULL)
			OR (P.[ProvinceId] IS NOT NULL AND D.[Id] IS NULL)
			OR (P.[HierarchyLevel1Id] IS NOT NULL AND (H1.[Id] IS NULL OR H1.[Deleted] = 1))
			OR (P.[HierarchyLevel2Id] IS NOT NULL AND (H2.[Id] IS NULL OR H2.[Deleted] = 1))

	-- Insert nuevos
	IF @Add <= @SyncType
	BEGIN	
		INSERT INTO [dbo].[PointOfInterest]([Identifier], [Name], [Address], [Latitude], [Longitude], LatLong, 
						[Radius], [MinElapsedTimeForVisit], [IdDepartment], [ContactName], [ContactPhoneNumber], [Deleted], [NFCTagId], 
						[GrandfatherId], [FatherId], [Emails])
		SELECT  P.[Id], P.[Name], P.[Address], P.[Latitude], P.[Longitude], 
				GEOGRAPHY::STPointFromText('POINT(' + CAST(P.[Longitude] AS VARCHAR(25)) + ' ' + CAST(P.[Latitude]AS VARCHAR(25)) + ')', 4326), 
				P.[Radius], P.[MinElapsedTimeForVisit], P.[ProvinceId], P.[ContactName], P.[ContactPhoneNumber], 0, P.[NFCTagId], H1.[Id], H2.[Id], P.[Emails]
		FROM    @Data P
				LEFT OUTER JOIN [PointOfInterest] as PR ON PR.[Identifier] = P.[Id] AND PR.[Deleted] = 0
				LEFT OUTER JOIN [dbo].[Department] D ON d.[Id] = P.[ProvinceId]
				LEFT OUTER JOIN [dbo].[POIHierarchyLevel1] H1 ON H1.[Name] = P.[HierarchyLevel1Id]
				LEFT OUTER JOIN [dbo].[POIHierarchyLevel2] H2 ON H2.[Name] = P.[HierarchyLevel2Id]
		WHERE   PR.[Id] IS NULL AND
				(P.[ProvinceId] IS NULL OR D.[Id] IS NOT NULL)
				AND (H1.[Id] IS NULL OR H1.[Deleted] = 0)
				AND (H2.[Id] IS NULL OR H2.[Deleted] = 0)

		DECLARE @IdZoneAllPoint [INT]
		SET @IdZoneAllPoint = (SELECT Z.[Id] FROM [dbo].[ZoneTranslated] Z WITH (NOLOCK) WHERE Z.[ApplyToAllPointOfInterest] = 1)

		IF @IdZoneAllPoint IS NOT NULL
		BEGIN
			INSERT INTO dbo.PointOfInterestZone
			SELECT P.[Id], @IdZoneAllPoint
			FROM [dbo].[PointOfInterest] P 
			WHERE P.[Deleted] = 0 AND P.[Id] NOT IN (SELECT PZ.[IdPointOfInterest] FROM [dbo].[PointOfInterestZone] PZ 
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
				INNER JOIN [PointOfInterest] PR ON P.[Id] = PR.[Identifier] AND PR.[Deleted] = 0
				LEFT OUTER JOIN [PointOfInterestHourWindow] PH ON PR.[Id] =  PH.[IdPointOfInterest] AND P.[Day] = PH.[IdDayOfWeek]
		WHERE	PH.[IdPointOfInterest] IS NULL
	END

	SET ANSI_WARNINGS  ON;

END
