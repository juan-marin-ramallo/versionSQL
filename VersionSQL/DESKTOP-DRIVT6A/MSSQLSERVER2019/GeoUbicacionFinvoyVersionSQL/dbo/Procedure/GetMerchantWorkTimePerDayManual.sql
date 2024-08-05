/****** Object:  Procedure [dbo].[GetMerchantWorkTimePerDayManual]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 06/04/2017
-- Description:	SP para obtener el tiempo de reposición de los merchants en los POI agrupado por dia teniendo en cuenta las marcas manuales.
-- =============================================
CREATE PROCEDURE [dbo].[GetMerchantWorkTimePerDayManual]
(
	 @DateFrom [sys].[datetime]
	,@DateTo [sys].[DATETIME]
	,@IdPersonsOfInterest [sys].[varchar](max) = null
    ,@IdUser [sys].[INT] = NULL
)
AS
BEGIN
	--DECLARE @NewDateFrom [sys].[DATE]
 --   DECLARE @NewDateTo [sys].[DATE]
    
	--SET @NewDateFrom = CAST(Tzdb.FromUtc(@DateFrom) AS [sys].[date])
	--SET @NewDateTo = CAST(Tzdb.FromUtc(@DateTo) AS [sys].[date])

	SELECT	Tzdb.ToUtc(CAST(Tzdb.FromUtc(POIV.[CheckInDate]) AS [sys].[date])) AS VisitedDate,
			ISNULL(SUM(CAST(DATEDIFF(SECOND, '0:00:00', [POIV].[ElapsedTime]) AS BIGINT)), 0) AS ElapsedTimeInSeconds
	
	FROM	[dbo].[PointOfInterestManualVisited] POIV
			LEFT OUTER JOIN [dbo].[PersonOfInterest] S ON S.[Id] = POIV.[IdPersonOfInterest]
			LEFT OUTER JOIN [dbo].[PointOfInterest] P ON P.[Id] = POIV.[IdPointOfInterest]
	
	WHERE	POIV.DeletedByNotVisited = 0 AND ((POIV.[CheckOutDate] IS NULL
			AND POIV.[CheckInDate] BETWEEN @DateFrom AND @DateTo)
			--AND CAST(Tzdb.FromUtc(POIV.[CheckInDate]) AS [sys].[date]) >= @NewDateFrom
			--AND CAST(Tzdb.FromUtc(POIV.[CheckInDate]) AS [sys].[date]) <= @NewDateTo)
			OR (POIV.[CheckInDate] BETWEEN @DateFrom AND @DateTo)
			OR (POIV.[CheckOutDate] BETWEEN @DateFrom AND @DateTo)) AND
			--OR (CAST(Tzdb.FromUtc(POIV.[CheckInDate]) AS [sys].[date]) BETWEEN @NewDateFrom AND @NewDateTo) 
			--OR (CAST(Tzdb.FromUtc(POIV.[CheckOutDate]) AS [sys].[date]) BETWEEN @NewDateFrom AND @NewDateTo)) AND
			((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1)) AND
			((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1)) AND
			((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1)) AND
			((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1))
			--AND S.Deleted = 0 AND P.Deleted = 0
			AND (@IdPersonsOfInterest IS NULL OR dbo.CheckValueInList(S.[Id], @IdPersonsOfInterest) > 0)
	
	GROUP BY	Tzdb.ToUtc(CAST(Tzdb.FromUtc(POIV.[CheckInDate]) AS [sys].[date]))
	ORDER BY	Tzdb.ToUtc(CAST(Tzdb.FromUtc(POIV.[CheckInDate]) AS [sys].[date]))
END
