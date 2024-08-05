/****** Object:  Procedure [dbo].[ApprovePointOfIniterestNoVisited]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 10/07/2015
-- Description:	SP para obtener el reporte de rutas
-- =============================================
CREATE PROCEDURE [dbo].[ApprovePointOfIniterestNoVisited]
(
	 @RouteDetailId [sys].[int]
	,@NoVisitedState [sys].[smallint]
	,@NoVisitedComment [sys].[varchar](1024) = NULL
	,@IdUserNoVisitedApproved [sys].[int]
)
AS
BEGIN

	-- Report
	UPDATE	RouteDetail
	SET  NoVisitedApprovedState = @NoVisitedState
		, [NoVisitedApprovedDate] = GETUTCDATE()
		, [NoVisitedApprovedComment] = @NoVisitedComment
		, [IdUserNoVisitedApproved] = @IdUserNoVisitedApproved
	WHERE Id = @RouteDetailId AND NoVisitedApprovedState = 0
    
END
