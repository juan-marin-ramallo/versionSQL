/****** Object:  Procedure [dbo].[GetMerchantWorkTimePerDay]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 19/10/2015
-- Description:	SP para obtener el tiempo de reposición de los merchants en los POI agrupado por dia
-- =============================================
CREATE PROCEDURE [dbo].[GetMerchantWorkTimePerDay]
(
	 @DateFrom [sys].[datetime]
	,@DateTo [sys].[DATETIME]
	,@IdPersonsOfInterest [sys].[varchar](max) = null
    ,@IdUser [sys].[INT] = NULL
)
AS
BEGIN
	--DECLARE @NewDateFrom [sys].[date]
	--DECLARE @NewDateTo [sys].[date]
    
	--SET @NewDateFrom = CAST(Tzdb.FromUtc(@DateFrom) AS [sys].[date])
	--SET @NewDateTo = CAST(Tzdb.FromUtc(@DateTo) AS [sys].[date])

	SELECT	Tzdb.ToUtc(CAST(Tzdb.FromUtc(POIV.[LocationInDate]) AS [sys].[date])) AS VisitedDate,
			ISNULL(SUM(CAST(DATEDIFF(SECOND, '0:00:00', [POIV].[ElapsedTime]) AS BIGINT)), 0) AS ElapsedTimeInSeconds
	FROM	[dbo].[PointOfInterestVisited] POIV
			LEFT OUTER JOIN [dbo].[PersonOfInterest] S ON S.[Id] = POIV.[IdPersonOfInterest]
			LEFT OUTER JOIN [dbo].[PointOfInterest] P ON P.[Id] = POIV.[IdPointOfInterest]
	WHERE	POIV.DeletedByNotVisited = 0 AND ((POIV.[LocationOutDate] IS NULL AND Tzdb.IsGreaterOrSameSystemDate(POIV.[LocationInDate], @DateFrom) = 1 AND Tzdb.IsLowerOrSameSystemDate(POIV.[LocationInDate], @DateTo) = 1) 
				--OR (CAST(Tzdb.FromUtc(POIV.[LocationInDate]) AS [sys].[date]) BETWEEN @NewDateFrom AND @NewDateTo) 
				--OR (CAST(Tzdb.FromUtc(POIV.[LocationOutDate]) AS [sys].[date]) BETWEEN @NewDateFrom AND @NewDateTo)) AND
				OR (POIV.[LocationInDate] BETWEEN @DateFrom AND @DateTo)
				OR (POIV.[LocationOutDate] BETWEEN @DateFrom AND @DateTo)) AND
			((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1)) AND
			((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1)) AND
			((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1)) AND
			((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1))
			--AND S.Deleted = 0 AND P.Deleted = 0
			AND (@IdPersonsOfInterest IS NULL OR dbo.CheckValueInList(S.[Id], @IdPersonsOfInterest) > 0) AND
			[dbo].IsVisitedLocationInPointHourWindow(POIV.[IdPointOfInterest], POIV.[LocationInDate], POIV.[LocationOutDate]) = 1

	GROUP BY	Tzdb.ToUtc(CAST(Tzdb.FromUtc(POIV.[LocationInDate]) AS [sys].[date]))
	ORDER BY	Tzdb.ToUtc(CAST(Tzdb.FromUtc(POIV.[LocationInDate]) AS [sys].[date]))
END
