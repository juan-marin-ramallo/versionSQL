/****** Object:  Procedure [dbo].[DeletePointOfInterestVisited]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 02/06/2015
-- Description:	SP para eliminar una ruta de interés visitada
-- =============================================
CREATE PROCEDURE [dbo].[DeletePointOfInterestVisited]
(
	@Id [sys].[int]
)
AS
BEGIN
	EXEC [dbo].[DeletePointsOfInterestActivity]
			 @AutomaticValue = 1
			,@IdPointOfInterestVisited = @Id
			,@IdPointOfInterestManualVisited = NULL

	DELETE FROM [dbo].[PointOfInterestVisited]
	WHERE [Id] = @Id
END
