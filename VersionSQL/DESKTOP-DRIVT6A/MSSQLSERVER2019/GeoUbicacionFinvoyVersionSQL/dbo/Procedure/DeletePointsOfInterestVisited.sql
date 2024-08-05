/****** Object:  Procedure [dbo].[DeletePointsOfInterestVisited]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 19/10/2016
-- Description:	SP para eliminar varios puntos de interés visitados
-- =============================================
CREATE PROCEDURE [dbo].[DeletePointsOfInterestVisited]
(
	@Ids [dbo].IdTableType READONLY
)
AS
BEGIN
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
			,@IdPointOfInterestManualVisited = NULL

	   FETCH NEXT FROM CUR_IDS INTO @CursorId
	END
	CLOSE CUR_IDS
	DEALLOCATE CUR_IDS

	DELETE PV
	FROM [dbo].[PointOfInterestVisited] PV
		INNER JOIN @Ids I ON I.[Id] = PV.[Id]
END
