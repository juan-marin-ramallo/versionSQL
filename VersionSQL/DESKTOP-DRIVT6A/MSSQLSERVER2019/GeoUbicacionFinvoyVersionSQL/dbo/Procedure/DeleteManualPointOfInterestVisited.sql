/****** Object:  Procedure [dbo].[DeleteManualPointOfInterestVisited]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[DeleteManualPointOfInterestVisited]
	@Id int
AS
BEGIN
	EXEC [dbo].[DeletePointsOfInterestActivity]
			 @AutomaticValue = 2
			,@IdPointOfInterestVisited = NULL
			,@IdPointOfInterestManualVisited = @Id

	DELETE FROM PointOfInterestManualVisited
	WHERE Id = @Id
END
