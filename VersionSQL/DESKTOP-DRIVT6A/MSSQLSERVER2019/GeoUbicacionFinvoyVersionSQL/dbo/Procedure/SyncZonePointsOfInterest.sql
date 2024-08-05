/****** Object:  Procedure [dbo].[SyncZonePointsOfInterest]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Matias Corso
-- Create date: 06/19/2016
-- Description:	Sincroniza Puntos de venta para una agrupación
-- =============================================
CREATE PROCEDURE [dbo].[SyncZonePointsOfInterest]
(
	 @SyncType [int]
	,@ZoneId [int]
	,@Data [ZonePointOfInterestTableType] READONLY
)
AS
BEGIN
	DECLARE @Add [int] = 0
	DECLARE @AddUpdate [int] = 1
	DECLARE @AddUpdateDelete [int] = 2

	-- Delete faltantes
	IF @AddUpdateDelete <= @SyncType
	BEGIN	

		DELETE	POIZ
		FROM	[dbo].[PointOfInterestZone] POIZ
				INNER JOIN [dbo].[PointOfInterest] POI ON POI.[Id] = POIZ.[IdPointOfInterest]
				LEFT OUTER JOIN @Data as D ON POI.[Identifier] = D.[PointOfInterestIdentifier]
		WHERE	POIZ.[IdZone] = @ZoneId
				AND D.[PointOfInterestIdentifier] IS NULL
	END

	-- Obtengo los que no tienen referencia
	SELECT  D.[PointOfInterestIdentifier], IIF(POI.[Id] IS NULL, 1, 0)
	FROM	@Data as D
			LEFT OUTER JOIN [PointOfInterest] POI ON D.[PointOfInterestIdentifier] = POI.[Identifier] AND POI.[Deleted] = 0
			LEFT OUTER JOIN [dbo].[PointOfInterestZone] POIZ ON POIZ.[IdPointOfInterest] = POI.[Id] AND POIZ.[IdZone] = @ZoneId
    WHERE   (@Add = @SyncType AND POIZ.IdPointOfInterest IS NOT NULL)
			OR POI.[Id] IS NULL

	-- Insert nuevos
	IF @Add <= @SyncType
	BEGIN	
		INSERT INTO [dbo].[PointOfInterestZone]([IdPointOfInterest],[IdZone])
		SELECT  POI.[Id], @ZoneId 
		FROM    @Data D
				INNER JOIN [dbo].[PointOfInterest] POI ON POI.[Identifier] = D.[PointOfInterestIdentifier] AND POI.[Deleted] = 0
				LEFT OUTER JOIN [dbo].[PointOfInterestZone] POIZ ON POIZ.[IdPointOfInterest] = POI.[Id] AND POIZ.[IdZone] = @ZoneId
		WHERE   POIZ.[IdPointOfInterest] IS NULL 
	END
END
