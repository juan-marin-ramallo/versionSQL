/****** Object:  Procedure [dbo].[GetFormsReportGrouped]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Diego Cáceres
-- Create date: 17/10/2014
-- Description:	SP para obtener los formularios completados
-- =============================================
CREATE PROCEDURE [dbo].[GetFormsReportGrouped]
	@DateFrom [sys].[datetime]
	,@DateTo [sys].[datetime]
	,@IdPersonsOfInterest [sys].[varchar](max) = NULL
	,@IdPointsOfInterest [sys].[varchar](max) = NULL
	,@IncludeAutomaticVisits [sys].[bit] = 1	
	,@IdUser [sys].[int] = NULL
AS
BEGIN
	SELECT	f.[PointOfInterestId], f.[PointOfInterestName],  f.[PointOfInterestIdentifier],
			Count(distinct idPointOfInterestVisited) as VisitedCount, COUNT (FormId) as FormsCount, Count(f.[CompletedFormId]) as CompletedCount
	FROM	[dbo].[FormsReportFiltered](@DateFrom,@DateTo,@IdPersonsOfInterest,@IdPointsOfInterest,@IncludeAutomaticVisits,@IdUser) f
	GROUP BY f.[PointOfInterestId], f.[PointOfInterestName],  f.[PointOfInterestIdentifier]
	ORDER BY f.[PointOfInterestName] asc
END
