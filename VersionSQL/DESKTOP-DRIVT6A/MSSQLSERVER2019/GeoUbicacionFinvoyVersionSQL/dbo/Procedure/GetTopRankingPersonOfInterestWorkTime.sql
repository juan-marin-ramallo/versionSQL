/****** Object:  Procedure [dbo].[GetTopRankingPersonOfInterestWorkTime]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 19/10/2015
-- Description:	SP para obtener el tiempo de reposición de las personas de interés en los POI
-- =============================================
CREATE PROCEDURE [dbo].[GetTopRankingPersonOfInterestWorkTime]
(
	 @DateFrom [sys].[datetime]
	,@DateTo [sys].[DATETIME]
	,@IdPersonsOfInterest [sys].[varchar](max) = null
    ,@IdUser [sys].[INT] = NULL
	,@UseAutomaticMarks [sys].[INT] = 1
)
AS
BEGIN
	;WITH DailyActivity(PersonOfInterestId, PersonOfInterestName, PersonOfInterestLastName
				, [ElapsedTime], [WorkHours], [GroupedDate]) AS
		(
			SELECT	A.[IdPersonOfInterest] AS PersonOfInterestId, A.PersonOfInterestName AS PersonOfInterestName 
				, A.PersonOfInterestLastName AS PersonOfInterestLastName
				, A.[ElapsedTime], A.[WorkHours], A.[GroupedDate]
			FROM [dbo].[DailyActivityReportForPersonOfInterest](@DateFrom, @DateTo, @IdPersonsOfInterest, NULL, @IdUser, @UseAutomaticMarks, 0) A
			GROUP BY  A.[IdPersonOfInterest], A.PersonOfInterestName, A.PersonOfInterestLastName, A.WorkHours, A.[ElapsedTime], [GroupedDate]
		)
	SELECT TOP 10 REP.PersonOfInterestId, REP.PersonOfInterestName, REP.PersonOfInterestLastName
			, SUM(REP.ElapsedTimeInSeconds) AS ElapsedTimeInSeconds, SUM(REP.TheoricalTimeInSeconds) AS TheoricalTimeInSeconds
	FROM (
		SELECT	REP.PersonOfInterestId, REP.PersonOfInterestName, REP.PersonOfInterestLastName
				, SUM(DATEDIFF(SECOND, '0:00:00', REP.[ElapsedTime])) AS ElapsedTimeInSeconds, DATEDIFF(SECOND, '0:00:00', REP.[WorkHours]) AS TheoricalTimeInSeconds, REP.[GroupedDate]
		FROM (
			SELECT	A.PersonOfInterestId, A.PersonOfInterestName, A.PersonOfInterestLastName
					, A.[ElapsedTime], A.[WorkHours], A.[GroupedDate]
			FROM DailyActivity A
		) REP
		GROUP BY  REP.PersonOfInterestId, REP.PersonOfInterestName, REP.PersonOfInterestLastName, REP.[WorkHours], REP.[GroupedDate]
	) REP
	GROUP BY  REP.PersonOfInterestId, REP.PersonOfInterestName, REP.PersonOfInterestLastName
	ORDER BY ElapsedTimeInSeconds DESC

	--SELECT	REP.PersonOfInterestId, REP.PersonOfInterestName, REP.PersonOfInterestLastName
	--		, SUM(DATEDIFF(SECOND, '0:00:00', REP.[ElapsedTime])) AS ElapsedTimeInSeconds, DATEDIFF(SECOND, '0:00:00', REP.[WorkHours]) AS TheoricalTimeInSeconds
	--FROM (
	--	SELECT	A.[IdPersonOfInterest] AS PersonOfInterestId, A.PersonOfInterestName AS PersonOfInterestName 
	--			, A.PersonOfInterestLastName AS PersonOfInterestLastName
	--			, A.[ElapsedTime], A.[WorkHours], A.LocationInDate
	--	FROM [dbo].[DailyActivityReportForPersonOfInterest](@DateFrom, @DateTo, @IdPersonsOfInterest, NULL, @IdUser, @UseAutomaticMarks, 0) A
	--	GROUP BY  A.[IdPersonOfInterest], A.PersonOfInterestName, A.PersonOfInterestLastName, A.WorkHours, A.LocationInDate, A.[ElapsedTime] 
	--) REP
	--GROUP BY  REP.PersonOfInterestId, REP.PersonOfInterestName, REP.PersonOfInterestLastName, REP.[WorkHours] 
	--ORDER BY ElapsedTimeInSeconds DESC
END
