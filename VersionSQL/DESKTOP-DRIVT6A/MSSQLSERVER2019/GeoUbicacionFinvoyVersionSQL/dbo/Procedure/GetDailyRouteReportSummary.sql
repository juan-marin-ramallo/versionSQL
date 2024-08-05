/****** Object:  Procedure [dbo].[GetDailyRouteReportSummary]    Committed by VersionSQL https://www.versionsql.com ******/

-- Stored Procedure

-- =============================================
-- Author:		Federico Sobral
-- Create date: 30/01/2018
-- Description:	Sp que obtiene resumen de ruta y formularios dada una ruta y un día
-- =============================================
CREATE PROCEDURE [dbo].[GetDailyRouteReportSummary]
(
	 @Route [sys].[VARCHAR](50)
	,@Date [sys].[datetime]
)
AS
BEGIN

	DECLARE @BASE_DATE [sys].[DateTime]= '1900-01-01 00:00.000'
	DECLARE @DateFrom [sys].[DATETIME] = @Date
	DECLARE @DateTo [sys].[DATETIME] = DATEADD(SECOND, -1, DATEADD(DAY, 1, @DateFrom))
	DECLARE @RouteNameEnd [sys].[VARCHAR](50) = ('% ' + @Route)
	DECLARE @RouteNameSpaces [sys].[VARCHAR](50) = ('% ' + @Route + ' %')

	-- Get Persons assigned to route
	-- Select Ids separated by ,
	DECLARE @PersonOfInterestIds [sys].[VARCHAR](MAX) = 
		( SELECT ',' + ISNULL(STUFF((
			SELECT ','+ CONVERT(VARCHAR(MAX), IdPersonOfInterest)
			FROM dbo.[RouteGroup] 
			WHERE ([Name] like @RouteNameSpaces OR [Name] LIKE @RouteNameEnd OR [Name] = @Route) 
				AND Tzdb.IsGreaterOrSameSystemDate(@DATE, StartDate) = 1
				AND (
					(Deleted = 0 AND (EndDate IS NULL OR Tzdb.IsLowerOrSameSystemDate(@DATE, EndDate) = 1))
					OR (Deleted = 1 AND Tzdb.IsLowerOrSameSystemDate(@Date, IIF(EndDate IS NULL OR EndDate > EditedDate, EditedDate, EndDate)) = 1)
				)
			GROUP BY IdPersonOfInterest
			FOR XML PATH('')
			)
			,1,1,''), '') + ',')

	SELECT  @Route AS [Route], @Date AS [Date]
	, r.PersonOfInterestName
	, SUM(CAST(r.Planned AS INT)) as TotPlanned
	, SUM(CAST(r.Visited AS INT)) AS TotVisited
	, SUM(IIF(R.Planned > 0 AND R.Visited > 0, 1, 0)) AS VisitedPlanned
	, SUM(IIF(R.Planned = 0 AND R.Visited > 0, 1, 0)) AS VisitedNotPlanned
	, SUM(IIF(R.Planned = 1 AND R.Visited = 0, 1, 0)) AS NotVisitedPlanned
	, SUM(IIF(R.Planned = 1, R.FormsCount, 0)) AS PlannedForms
	, SUM(IIF(R.Planned = 1, R.CompletedFormsCount, 0)) AS CompletedForms
	, IIF(SUM(CAST(R.Planned AS INT)) > 0, (SUM(IIF(R.Planned > 0 AND R.Visited > 0, 1, 0)) / SUM(CAST(r.Planned AS INT))) * 100, 0) AS PlanEffectiveness
	, m.[EntryTime]
	, m.[ExitTime]
	, DATEDIFF(MILLISECOND, @BASE_DATE, m.[WorkedHours]) AS WorkedHours
	FROM [dbo].[GetDailyRouteReportDetailedFiltered](@Route, @Date) AS r 
		LEFT OUTER JOIN [dbo].[GetDetailedMarks](@DateFrom, @DateTo, NULL, NULL, @PersonOfInterestIds, null) AS m ON r.PersonOfInterestId = m.IdPersonOfInterest AND r.[Date] = m.[Date]
	GROUP BY r.PersonOfInterestId, r.PersonOfInterestName, m.[EntryTime], m.[ExitTime], DATEDIFF(MILLISECOND, @BASE_DATE, m.[WorkedHours])
	
END
