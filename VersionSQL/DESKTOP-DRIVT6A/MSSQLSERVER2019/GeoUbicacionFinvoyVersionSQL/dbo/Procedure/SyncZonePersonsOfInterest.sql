/****** Object:  Procedure [dbo].[SyncZonePersonsOfInterest]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Matias Corso
-- Create date: 06/19/2016
-- Description:	Sincroniza Personas de interés para una agrupación
-- =============================================
CREATE PROCEDURE [dbo].[SyncZonePersonsOfInterest]
(
	 @SyncType [int]
	,@ZoneId [int]
	,@Data [ZonePersonOfInterestTableType] READONLY
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
		FROM	[dbo].[PersonOfInterestZone] POIZ
				INNER JOIN [dbo].[PersonOfInterest] POI ON POI.[Id] = POIZ.[IdPersonOfInterest]
				LEFT OUTER JOIN @Data as D ON POI.[Identifier] = D.[PersonOfInterestIdentifier]
		WHERE	POIZ.[IdZone] = @ZoneId
				AND D.[PersonOfInterestIdentifier] IS NULL
	END

	-- Obtengo los que no tienen referencia
	SELECT  D.[PersonOfInterestIdentifier], IIF(POI.[Id] IS NULL, 1, 0)
	FROM	@Data as D
			LEFT OUTER JOIN [AvailablePersonOfInterest] POI ON D.[PersonOfInterestIdentifier] = POI.[Identifier] 
			LEFT OUTER JOIN [dbo].[PersonOfInterestZone] POIZ ON POIZ.[IdPersonOfInterest] = POI.[Id] AND POIZ.[IdZone] = @ZoneId
    WHERE   (@Add = @SyncType AND POIZ.IdPersonOfInterest IS NOT NULL)
			OR POI.[Id] IS NULL

	-- Insert nuevos
	IF @Add <= @SyncType
	BEGIN	
		INSERT INTO [dbo].[PersonOfInterestZone]([IdPersonOfInterest],[IdZone])
		SELECT  POI.[Id], @ZoneId 
		FROM    @Data as D
				INNER JOIN [dbo].[AvailablePersonOfInterest] POI ON POI.[Identifier] = D.[PersonOfInterestIdentifier]
				LEFT OUTER JOIN [dbo].[PersonOfInterestZone] POIZ ON POIZ.[IdPersonOfInterest] = POI.[Id] AND POIZ.[IdZone] = @ZoneId
		WHERE   POIZ.[IdPersonOfInterest] IS NULL 
	END
END
