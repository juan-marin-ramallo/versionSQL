/****** Object:  Procedure [dbo].[SaveRouteNoVisit]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 28/07/2016
-- Description:	SP para guardar una ruta no visitada
-- =============================================
CREATE PROCEDURE [dbo].[SaveRouteNoVisit]
	@IdRoute [sys].[INT],
	@IdNoVisitOption [sys].[INT],
	@Date [sys].[DATETIME],
	@ResultCode [sys].[int] OUT
AS
BEGIN
	DECLARE @Ids [dbo].[IdTableType]
	DECLARE @IdsManual [dbo].[IdTableType]
	DECLARE @IdsNFC [dbo].[IdTableType]
	DECLARE @IdPoint [sys].[int]
	DECLARE @IdPerson [sys].[int]
	DECLARE @DateIn [sys].[DATETIME]
	SET @ResultCode = 0

	IF EXISTS (SELECT 1 FROM [dbo].[RouteDetail] WITH (NOLOCK) WHERE [Id] = @IdRoute) 
		AND EXISTS (SELECT 1 FROM [dbo].[RouteNoVisitOption] WITH (NOLOCK) WHERE [id] = @IdNoVisitOption)
	BEGIN
		
		UPDATE	[dbo].[RouteDetail]
		SET		[NoVisited] = 1, [IdRouteNoVisitOption] = @IdNoVisitOption, [DateNoVisited] = @Date
		WHERE	[Id] = @IdRoute

		SET @ResultCode = 1
		
		--Cambio Dado 16-08-2016 Hay que cambiar la bandera si existe un Punto de Interes Visitado para este dia	
		INSERT INTO @Ids(Id)
		SELECT PV.[Id]
		FROM dbo.[PointOfInterestVisited] PV WITH (NOLOCK)
			INNER JOIN [dbo].[RouteGroup] RG WITH (NOLOCK) ON PV.[IdPersonOfInterest] = RG.[IdPersonOfInterest] 
			INNER JOIN [dbo].[RoutePointOfInterest] RP ON RP.[IdRouteGroup] = RG.[Id] AND RP.[IdPointOfInterest] = PV.[IdPointOfInterest]
			INNER JOIN [dbo].[RouteDetail] RD WITH (NOLOCK) ON RD.[IdRoutePointOfInterest] = RP.[Id]
		WHERE RD.[Id] = @IdRoute AND Tzdb.AreSameSystemDates(RD.[RouteDate], @Date) = 1
			AND (Tzdb.AreSameSystemDates(PV.[LocationInDate], @Date) = 1 OR Tzdb.AreSameSystemDates(PV.[LocationOutDate], @Date) = 1)
		GROUP BY PV.Id

		UPDATE [dbo].[PointOfInterestVisited] SET [DeletedByNotVisited] = 1 WHERE [Id] IN (SELECT Id FROM @Ids)
		
		--Cambio GL 11-01-2017 Hay que cambiar la bandera si existe un Punto de Interes Visitado Manual para este dia	
		INSERT INTO @IdsManual(Id)
		SELECT PMV.[Id]
		FROM dbo.[PointOfInterestManualVisited] PMV WITH (NOLOCK)
			INNER JOIN [dbo].[RouteGroup] RG WITH (NOLOCK) ON PMV.[IdPersonOfInterest] = RG.[IdPersonOfInterest] 
			INNER JOIN [dbo].[RoutePointOfInterest] RP ON RP.[IdRouteGroup] = RG.[Id] AND RP.[IdPointOfInterest] = PMV.[IdPointOfInterest]
			INNER JOIN [dbo].[RouteDetail] RD WITH (NOLOCK) ON RD.[IdRoutePointOfInterest] = RP.[Id]
		WHERE RD.[Id] = @IdRoute AND Tzdb.AreSameSystemDates(RD.[RouteDate], @Date) = 1
			AND (Tzdb.AreSameSystemDates(PMV.[CheckInDate], @Date) = 1 OR Tzdb.AreSameSystemDates(PMV.[CheckOutDate], @Date) = 1)
		GROUP BY PMV.Id
		
		UPDATE [dbo].[PointOfInterestManualVisited] SET [DeletedByNotVisited] = 1 WHERE [Id] IN (SELECT Id FROM @IdsManual)
		
		--Cambio GL 06-02-2017 Hay que cambiar la bandera si existe un Punto de Interes Visitado para este diapara marcas NFC
		INSERT INTO @IdsNFC(Id)
		SELECT PMV.[Id]
		FROM dbo.[PointOfInterestMark] PMV WITH (NOLOCK)
			INNER JOIN [dbo].[RouteGroup] RG WITH (NOLOCK) ON PMV.[IdPersonOfInterest] = RG.[IdPersonOfInterest] 
			INNER JOIN [dbo].[RoutePointOfInterest] RP ON RP.[IdRouteGroup] = RG.[Id] AND RP.[IdPointOfInterest] = PMV.[IdPointOfInterest]
			INNER JOIN [dbo].[RouteDetail] RD WITH (NOLOCK) ON RD.[IdRoutePointOfInterest] = RP.[Id]
		WHERE RD.[Id] = @IdRoute AND Tzdb.AreSameSystemDates(RD.[RouteDate], @Date) = 1
			AND (Tzdb.AreSameSystemDates(PMV.[CheckInDate], @Date) = 1 OR Tzdb.AreSameSystemDates(PMV.[CheckOutDate], @Date) = 1)
		GROUP BY PMV.Id

		UPDATE [dbo].[PointOfInterestMark] SET [DeletedByNotVisited] = 1 WHERE [Id] IN (SELECT Id FROM @IdsNFC)

		-- Delete activity 
		DECLARE @CursorId [sys].[int]
		DECLARE CUR_IDS CURSOR FAST_FORWARD FOR
			SELECT Id
			FROM   @Ids
			ORDER BY Id
 
		OPEN CUR_IDS
		FETCH NEXT FROM CUR_IDS INTO @CursorId
 
		WHILE @@FETCH_STATUS = 0
		BEGIN
		EXEC [dbo].[DeletePointsOfInterestActivity]
					@AutomaticValue = 1
				,@IdPointOfInterestVisited = @CursorId

			FETCH NEXT FROM CUR_IDS INTO @CursorId
		END
		CLOSE CUR_IDS
		DEALLOCATE CUR_IDS
		-- Delete manual activity
		DECLARE CUR_IDSM CURSOR FAST_FORWARD FOR
			SELECT Id
			FROM   @Ids
			ORDER BY Id
 
		OPEN CUR_IDSM
		FETCH NEXT FROM CUR_IDSM INTO @CursorId
 
		WHILE @@FETCH_STATUS = 0
		BEGIN
		EXEC [dbo].[DeletePointsOfInterestActivity]
					@AutomaticValue = 2
				,@IdPointOfInterestManualVisited = @CursorId

			FETCH NEXT FROM CUR_IDSM INTO @CursorId
		END
		CLOSE CUR_IDSM
		DEALLOCATE CUR_IDSM
		
		-- Delete manual nfc mark
		DECLARE CUR_IDSNFC CURSOR FAST_FORWARD FOR
			SELECT PMV.IdPointOfInterest, PMV.IdPersonOfInterest, PMV.CheckInDate
			FROM dbo.[PointOfInterestMark] PMV WITH (NOLOCK)
			WHERE PMV.Id IN (SELECT Id FROM @IdsNFC)
 
		OPEN CUR_IDSNFC
		FETCH NEXT FROM CUR_IDSNFC INTO @IdPoint, @IdPerson, @DateIn
 
		WHILE @@FETCH_STATUS = 0
		BEGIN
		EXEC [dbo].[DeletePointsOfInterestActivity]
					@AutomaticValue = 2
				,@IdPointOfInterest = @IdPoint
				,@IdPersonOfInterest = @IdPerson
				,@DateIn = @DateIn

			FETCH NEXT FROM CUR_IDSNFC INTO @IdPoint, @IdPerson, @DateIn
		END
		CLOSE CUR_IDSNFC
		DEALLOCATE CUR_IDSNFC
	END
END
