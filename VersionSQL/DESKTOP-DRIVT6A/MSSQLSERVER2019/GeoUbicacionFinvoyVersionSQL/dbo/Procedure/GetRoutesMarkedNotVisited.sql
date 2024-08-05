/****** Object:  Procedure [dbo].[GetRoutesMarkedNotVisited]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Diego Cáceres
-- Create date: 18/08/2016
-- Description:	SP para obtener los puntos marcados como No Visitados Por Mercaderista
-- =============================================
CREATE PROCEDURE [dbo].[GetRoutesMarkedNotVisited]
(
	 @DateFrom [sys].[datetime]
	,@DateTo [sys].[datetime]
	,@IdDepartments [sys].[varchar](max) = NULL
	,@Types [sys].[varchar](max) = NULL
	,@IdPersonsOfInterest [sys].[varchar](max) = NULL
	,@IdPointsOfInterest [sys].[varchar](max) = NULL	
	,@IdUser [sys].[int] = NULL
)
AS
BEGIN
	SELECT	R.IdRoute, R.RouteDate, 
			R.PersonOfInterestId, R.PersonOfInterestName, R.PersonOfInterestLastName, 
			R.PointOfInterestId, R.PointOfInterestName, 
			R.PointOfInterestIdentifier, R.[Description], R.[NoVisitedApprovedState]
	FROM	[dbo].[RoutesMarkedNotVisitedFiltered](@DateFrom,@DateTo,@IdDepartments,@Types,@IdPersonsOfInterest,@IdPointsOfInterest,@IdUser) r
	ORDER BY R.IdRoute desc
END
