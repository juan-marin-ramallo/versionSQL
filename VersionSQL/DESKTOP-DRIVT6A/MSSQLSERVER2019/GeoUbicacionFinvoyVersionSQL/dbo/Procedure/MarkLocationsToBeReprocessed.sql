/****** Object:  Procedure [dbo].[MarkLocationsToBeReprocessed]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 24/07/2015
-- Description:	SP para eliminar puntos visitados y reprocesarlos a partir de una fecha
-- =============================================
CREATE PROCEDURE [dbo].[MarkLocationsToBeReprocessed] 
	 @DateFrom [sys].[datetime]
	,@DateTo  [sys].[datetime] = NULL
	,@IdPersonsOfInterest [sys].[VARCHAR](MAX) = NULL
AS
BEGIN
	SET NOCOUNT ON

	CREATE TABLE #LocationsToDelete
	(
		[Id] [sys].[INT] NOT NULL
	)
	DECLARE @IdsPOIV [dbo].IdTableType

	INSERT INTO #LocationsToDelete([Id])
	SELECT [Id] FROM [dbo].[Location] WITH (NOLOCK) 
	WHERE ((@IdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList([IdPersonOfInterest], @IdPersonsOfInterest) = 1)) 
	--(@IdPersonOfInterest IS NULL OR [IdPersonOfInterest] = @IdPersonOfInterest) 
	AND [Date] >= @DateFrom AND (@DateTo IS NULL OR [Date] <= @DateTo)

	INSERT INTO @IdsPOIV(Id)
	SELECT Id FROM [dbo].[PointOfInterestVisited] WHERE [IdLocationIn] IN (SELECT [Id] FROM #LocationsToDelete)

	DECLARE @CursorId [sys].[int]
	DECLARE CUR_IDS CURSOR FAST_FORWARD FOR
		SELECT Id
		FROM   @IdsPOIV
		ORDER BY Id
 
	OPEN CUR_IDS
	FETCH NEXT FROM CUR_IDS INTO @CursorId
 
	WHILE @@FETCH_STATUS = 0
	BEGIN
	EXEC [dbo].[DeletePointsOfInterestActivity]
			 @AutomaticValue = 1
			,@IdPointOfInterestVisited = @CursorId
			,@IdPointOfInterestManualVisited = NULL

	   FETCH NEXT FROM CUR_IDS INTO @CursorId
	END
	CLOSE CUR_IDS
	DEALLOCATE CUR_IDS

	DELETE FROM [dbo].[PointOfInterestVisited] WHERE [Id] IN (SELECT [Id] FROM @IdsPOIV)

	UPDATE [dbo].[Location] SET [Processed] = 0 WHERE [Id] IN (SELECT [Id] FROM #LocationsToDelete)

	DROP TABLE #LocationsToDelete

	SET NOCOUNT OFF
END
