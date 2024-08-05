/****** Object:  Procedure [dbo].[GetFormsReportGroupedByPOI]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Diego Cáceres
-- Create date: 17/10/2014
-- Description:	SP para obtener los formularios completados
-- =============================================
CREATE PROCEDURE [dbo].[GetFormsReportGroupedByPOI]
	@DateFrom [sys].[datetime]
	,@DateTo [sys].[datetime]
	,@IdPersonsOfInterest [sys].[varchar](max) = NULL
	,@IdPointsOfInterest [sys].[varchar](max) = NULL
	,@IncludeAutomaticVisits [sys].[bit] = 1	
	,@IdUser [sys].[int] = NULL
AS
BEGIN
	SELECT	f.[FormId], F.[FormName],
			f.[PersonOfInterestId], f.[PersonOfInterestName], f.[PersonOfInterestLastName], 
			Count(distinct idPointOfInterestVisited) as VisitedCount, Count(f.[CompletedFormId]) as CompletedCount
	FROM	[dbo].[FormsReportFiltered](@DateFrom,@DateTo,@IdPersonsOfInterest,@IdPointsOfInterest,@IncludeAutomaticVisits,@IdUser) f
	GROUP BY f.[FormId], F.[FormName],
			f.[PersonOfInterestId], f.[PersonOfInterestName], f.[PersonOfInterestLastName]
	ORDER BY f.[PersonOfInterestName] asc, f.[FormName] asc
END
