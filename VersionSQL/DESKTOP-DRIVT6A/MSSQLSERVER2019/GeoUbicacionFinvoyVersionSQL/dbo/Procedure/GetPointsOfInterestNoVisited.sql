/****** Object:  Procedure [dbo].[GetPointsOfInterestNoVisited]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 10/07/2015
-- Description:	SP para obtener el reporte de rutas
-- =============================================
CREATE PROCEDURE [dbo].[GetPointsOfInterestNoVisited]
(
	 @DateFrom [sys].[datetime]
	,@DateTo [sys].[datetime]
	,@IdDepartments [sys].[varchar](max) = NULL
	,@Types [sys].[varchar](max) = NULL
	,@IdPersonsOfInterest [sys].[varchar](max) = NULL
	,@IdPointsOfInterest [sys].[varchar](max) = NULL
	,@NoVisitedApprovedStates [sys].[varchar](20) = null
	,@IdUser [sys].[int] = NULL
)
AS
BEGIN

	-- Report
	SELECT	IdRouteDetail, [PersonOfInterestId], [PersonOfInterestName], [PersonOfInterestLastName] , 
			[PointOfInterestId] , PointOfInterestName ,[PointOfInterestIdentifier],
			 RouteDate ,[Description] as NoVisitOptionText , NoVisitedApprovedState, [NoVisitedApprovedDate], [NoVisitedApprovedComment], [IdUserNoVisitedApproved], [NoVisitedApprovedUserName],[NoVisitedApprovedUserLastName]
	FROM	[dbo].[RoutesMarkedNotVisitedFiltered](@DateFrom,@DateTo,@IdDepartments,@Types,@IdPersonsOfInterest,@IdPointsOfInterest,@IdUser)
	WHERE (@NoVisitedApprovedStates IS NULL OR [dbo].[CheckValueInList]([NoVisitedApprovedState], @NoVisitedApprovedStates) > 0)
	ORDER BY PointOfInterestName, RouteDate ASC
    
END
