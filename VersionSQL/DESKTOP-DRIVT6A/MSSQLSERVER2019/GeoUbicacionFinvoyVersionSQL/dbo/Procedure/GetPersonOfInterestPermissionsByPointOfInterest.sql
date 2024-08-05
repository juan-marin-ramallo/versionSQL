/****** Object:  Procedure [dbo].[GetPersonOfInterestPermissionsByPointOfInterest]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 26/10/2018
-- Description:	SP para buscar permisos por punto y por persona
-- =============================================
CREATE PROCEDURE [dbo].[GetPersonOfInterestPermissionsByPointOfInterest]
(
	 @IdPersonOfInterest [int]
	,@IdPointOfInterest [int]
)
AS
BEGIN
	DECLARE @SystemToday [sys].[datetime]
	SET @SystemToday = DATEADD(DAY, DATEDIFF(DAY, 0, Tzdb.FromUtc(GETUTCDATE())), 0)

    DECLARE @PersonOfInterestType [sys].[char](1) = 
	(SELECT S.[Type] FROM [dbo].[PersonOfInterest] S WITH (NOLOCK) WHERE S.[Id] = @IdPersonOfInterest)

    ;WITH vProductMissingPointOfInterest([Id], [DateSystemTruncated]) AS
    (
        SELECT  [Id], DATEADD(DAY, DATEDIFF(DAY, 0, Tzdb.FromUtc([Date])), 0) AS DateSystemTruncated
        FROM    [dbo].[ProductMissingPointOfInterest] WITH (NOLOCK)
        WHERE   [Deleted] = 0
                AND [IdPointOfInterest] = @IdPointOfInterest
    ),
    vProductReport([Id], [DateSystemTruncated]) AS
    (
        SELECT  '1-' + CAST([Id] AS [sys].[varchar](10)) AS [Id], DATEADD(DAY, DATEDIFF(DAY, 0, Tzdb.FromUtc([ReportDateTime])), 0) AS DateSystemTruncated
        FROM    [dbo].[ProductReport]
        WHERE   [Deleted] = 0
                AND [IdPointOfInterest] = @IdPointOfInterest

        UNION

        SELECT  '2-' + CAST([Id] AS [sys].[varchar](10)) AS [Id], DATEADD(DAY, DATEDIFF(DAY, 0, Tzdb.FromUtc([ReportDateTime])), 0) AS DateSystemTruncated
        FROM    [dbo].[ProductReportDynamic]
        WHERE   [Deleted] = 0
                AND [IdPointOfInterest] = @IdPointOfInterest
    ),
    vScheduleProfile([Id], [AllPersonOfInterest], [AllPointOfInterest], [FromDateSystemTruncated], [ToDateSystemTruncated], [CronExpression]) AS
    (
        SELECT  SP.[Id], [AllPersonOfInterest], [AllPointOfInterest],
                DATEADD(DAY, DATEDIFF(DAY, 0, Tzdb.FromUtc([FromDate])), 0) AS FromDateSystemTruncated,
                DATEADD(DAY, DATEDIFF(DAY, 0, Tzdb.FromUtc([ToDate])), 0) AS ToDateSystemTruncated,
				SPC.CronExpression
        FROM    [dbo].[ScheduleProfile] SP WITH (NOLOCK)
		INNER JOIN [dbo].[ScheduleProfileCron] SPC WITH (NOLOCK) ON SP.IdScheduleProfileCron = SPC.Id
        WHERE   [Deleted] = 0
    )

	--Busco los que son para todas las personas o todos los puntos
	SELECT	P.[Id], P.[Description]
			, SPS.IdProductReportSection, PRP.[Name] as ProductReportSectionName, PRP.[Order] as ProductReportSectionOrder
			, SP.CronExpression
	FROM	[dbo].[ScheduleProfilePermission] SPP WITH(NOLOCK)
			INNER JOIN vScheduleProfile SP WITH(NOLOCK) ON SP.[Id] = SPP.[IdScheduleProfile]
			INNER JOIN [dbo].[PersonOfInterestPermissionTranslated] P WITH(NOLOCK) ON SPP.[IdPersonOfInterestPermission] = P.[Id]
			LEFT JOIN  [dbo].[ScheduleProfileAssignation] SPA WITH(NOLOCK) ON SPA.[IdScheduleProfile] = SP.[Id]
			LEFT JOIN [dbo].[ScheduleProfileProductSection] SPS with(nolock)ON SPS.[IdScheduleProfile] = SP.[Id]
			LEFT JOIN [dbo].[ProductReportSection] PRP WITH (NOLOCK) ON SPS.[IdProductReportSection] = PRP.[Id]

	WHERE	(SP.[AllPersonOfInterest] = 1 OR (SPA.[IdPersonOfInterest] = @IdPersonOfInterest)) AND
			(SP.[AllPointOfInterest] = 1 OR (SPA.[IdPointOfInterest] = @IdPointOfInterest)) AND
			P.[Enabled] = 1
            AND SP.[FromDateSystemTruncated] <= @SystemToday AND SP.[ToDateSystemTruncated] >= @SystemToday
			AND (SPP.[LimitOnlyOnce] = 0 OR (P.[Id] = 15 AND NOT EXISTS(SELECT  TOP (1) 1 FROM vProductMissingPointOfInterest PMR WITH (NOLOCK)
                                                                        WHERE   DATEDIFF(DAY, PMR.[DateSystemTruncated], @SystemToday) <> 0
                                                                                AND SP.[FromDateSystemTruncated] <= PMR.[DateSystemTruncated]AND SP.[ToDateSystemTruncated] >= PMR.[DateSystemTruncated]))
                                         OR (P.[Id] IN (7, 23) AND NOT EXISTS(SELECT    TOP (1) 1 FROM vProductReport PR WITH (NOLOCK)
                                                                              WHERE     DATEDIFF(DAY, PR.[DateSystemTruncated], @SystemToday) <> 0
                                                                                        AND SP.[FromDateSystemTruncated] <= PR.[DateSystemTruncated]AND SP.[ToDateSystemTruncated] >= PR.[DateSystemTruncated])))
			AND (PRP.[Id] IS NULL OR (PRP.[Deleted] = 0 AND PRP.[FullDeleted] = 0))

	GROUP BY P.[Id], P.[Description], SPS.IdProductReportSection, PRP.[Name], PRP.[Order], SP.CronExpression

	UNION

	SELECT	P.[Id], P.[Description]
			, SPS.IdProductReportSection, PRP.[Name] as ProductReportSectionName, PRP.[Order] as ProductReportSectionOrder
			, SP.CronExpression
	FROM	[dbo].[ScheduleProfilePermission] SPP WITH(NOLOCK)
			INNER JOIN vScheduleProfile SP WITH(NOLOCK) ON SP.[Id] = SPP.[IdScheduleProfile]
			INNER JOIN [dbo].[PersonOfInterestPermissionTranslated] P WITH(NOLOCK) ON SPP.[IdPersonOfInterestPermission] = P.[Id]
			LEFT JOIN  [dbo].[ScheduleProfileGeneralAssignation] SPGA WITH(NOLOCK) ON SPGA.[IdScheduleProfile] = SP.[Id]
			LEFT JOIN  [dbo].[ScheduleProfileAssignation] SPA WITH(NOLOCK) ON SPA.[IdScheduleProfile] = SP.[Id]
			LEFT JOIN [dbo].[ScheduleProfileProductSection] SPS with(nolock)ON SPS.[IdScheduleProfile] = SP.[Id]
			LEFT JOIN [dbo].[ProductReportSection] PRP WITH (NOLOCK) ON SPS.[IdProductReportSection] = PRP.[Id]

	WHERE	(SPGA.[IdPersonOfInterestType] = @PersonOfInterestType) AND
			(SP.[AllPointOfInterest] = 1 OR (SPA.[IdPointOfInterest] = @IdPointOfInterest)) AND
			P.[Enabled] = 1
			AND SP.[FromDateSystemTruncated] <= @SystemToday AND SP.[ToDateSystemTruncated] >= @SystemToday
			AND (SPP.[LimitOnlyOnce] = 0 OR (P.[Id] = 15 AND NOT EXISTS(SELECT  TOP (1) 1 FROM vProductMissingPointOfInterest PMR WITH (NOLOCK)
                                                                        WHERE   DATEDIFF(DAY, PMR.[DateSystemTruncated], @SystemToday) <> 0
                                                                                AND SP.[FromDateSystemTruncated] <= PMR.[DateSystemTruncated] AND SP.[ToDateSystemTruncated] >= PMR.[DateSystemTruncated]))
                                         OR (P.[Id] IN (7, 23) AND NOT EXISTS(SELECT    TOP (1) 1 FROM vProductReport PR WITH (NOLOCK)
                                                                              WHERE     DATEDIFF(DAY, PR.[DateSystemTruncated], @SystemToday) <> 0
                                                                                        AND SP.[FromDateSystemTruncated] <= PR.[DateSystemTruncated]AND SP.[ToDateSystemTruncated] >= PR.[DateSystemTruncated])))
			AND (PRP.[Id] IS NULL OR (PRP.[Deleted] = 0 AND PRP.[FullDeleted] = 0))
																						
	GROUP BY P.[Id], P.[Description], SPS.IdProductReportSection, PRP.[Name], PRP.[Order], SP.CronExpression
	ORDER BY [Id], PRP.[Order] ;
END

-- OLD)
-- BEGIN
-- 	DECLARE @Now [sys].[datetime]
--     SET @Now = GETUTCDATE()

-- 	--DECLARE @FormatActualDate [sys].[date] = CAST(GETUTCDATE() AS DATE)
	
-- 	DECLARE @PersonOfInterestType [sys].[char](1) = 
-- 	(SELECT S.[Type] FROM [dbo].[PersonOfInterest] S WHERE S.[Id] = @IdPersonOfInterest)

-- 	--Busco los que son para todas las personas o todos los puntos
-- 	SELECT	P.[Id], P.[Description]
-- 	FROM	[dbo].[ScheduleProfilePermission] SPP WITH(NOLOCK)
-- 			INNER JOIN [dbo].[ScheduleProfile] SP WITH(NOLOCK) ON SP.[Id] = SPP.[IdScheduleProfile]
-- 			INNER JOIN [dbo].[ScheduleProfilePermission] SPPE WITH(NOLOCK) ON SP.[Id] = SPPE.[IdScheduleProfile]
-- 			INNER JOIN [dbo].[PersonOfInterestPermissionTranslated] P WITH(NOLOCK) ON SPPE.[IdPersonOfInterestPermission] = P.[Id]
-- 			LEFT JOIN  [dbo].[ScheduleProfileAssignation] SPA WITH(NOLOCK) ON SPA.[IdScheduleProfile] = SP.[Id]

-- 	WHERE	(SP.[AllPersonOfInterest] = 1 OR (SPA.[IdPersonOfInterest] = @IdPersonOfInterest)) AND
-- 			(SP.[AllPointOfInterest] = 1 OR (SPA.[IdPointOfInterest] = @IdPointOfInterest)) AND
-- 			P.[Enabled] = 1 AND SP.[Deleted] = 0
-- 			--AND CAST(SP.[FromDate] AS DATE) <= @FormatActualDate AND CAST(SP.[ToDate] AS DATE) >= @FormatActualDate
-- 			AND Tzdb.IsLowerOrSameSystemDate(SP.[FromDate], @Now) = 1 AND Tzdb.IsGreaterOrSameSystemDate(SP.[ToDate], @Now) = 1
-- 						AND (P.[Id] <> 15 OR (SP.[LimitOneMissingReport] = 0 --15 ES EL ID DE FALTANTES
-- 				OR NOT EXISTS (SELECT 1 FROM [dbo].[ProductMissingPointOfInterest] PMR WITH(NOLOCK) 
-- 										WHERE --PMR.[IdPersonOfInterest] = @IdPersonOfInterest AND
-- 												PMR.[IdPointOfInterest] = @IdPointOfInterest
-- 												--AND CAST(PMR.[Date] AS DATE) <> @FormatActualDate
-- 												AND Tzdb.AreSameSystemDates(PMR.[Date], @Now) = 0
-- 												--AND CAST(SP.[FromDate] AS DATE) <= CAST(PMR.[Date] AS DATE) AND CAST(SP.[ToDate] AS DATE) >= CAST(PMR.[Date] AS DATE))))
-- 												AND Tzdb.IsLowerOrSameSystemDate(SP.[FromDate], PMR.[Date]) = 1 AND Tzdb.IsGreaterOrSameSystemDate(SP.[ToDate], PMR.[Date]) = 1)))


-- 	UNION

-- 	SELECT	P.[Id], P.[Description]
-- 	FROM	[dbo].[ScheduleProfilePermission] SPP WITH(NOLOCK)
-- 			INNER JOIN [dbo].[ScheduleProfile] SP WITH(NOLOCK) ON SP.[Id] = SPP.[IdScheduleProfile]
-- 			INNER JOIN [dbo].[ScheduleProfilePermission] SPPE WITH(NOLOCK) ON SP.[Id] = SPPE.[IdScheduleProfile]
-- 			INNER JOIN [dbo].[PersonOfInterestPermissionTranslated] P WITH(NOLOCK) ON SPPE.[IdPersonOfInterestPermission] = P.[Id]
-- 			LEFT JOIN  [dbo].[ScheduleProfileGeneralAssignation] SPGA WITH(NOLOCK) ON SPGA.[IdScheduleProfile] = SP.[Id]
-- 			LEFT JOIN  [dbo].[ScheduleProfileAssignation] SPA WITH(NOLOCK) ON SPA.[IdScheduleProfile] = SP.[Id]

-- 	WHERE	(SPGA.[IdPersonOfInterestType] = @PersonOfInterestType) AND
-- 			(SP.[AllPointOfInterest] = 1 OR (SPA.[IdPointOfInterest] = @IdPointOfInterest)) AND
-- 			P.[Enabled] = 1 AND SP.[Deleted] = 0
-- 			--AND CAST(SP.[FromDate] AS DATE) <= @FormatActualDate AND CAST(SP.[ToDate] AS DATE) >= @FormatActualDate
-- 			AND Tzdb.IsLowerOrSameSystemDate(SP.[FromDate], @Now) = 1 AND Tzdb.IsGreaterOrSameSystemDate(SP.[ToDate], @Now) = 1
-- 			AND (P.[Id] <> 15 OR (SP.[LimitOneMissingReport] = 0 --15 ES EL ID DE FALTANTES
-- 				OR NOT EXISTS (SELECT 1 FROM [dbo].[ProductMissingPointOfInterest] PMR WITH(NOLOCK) 
-- 										WHERE --PMR.[IdPersonOfInterest] = @IdPersonOfInterest AND
-- 												PMR.[IdPointOfInterest] = @IdPointOfInterest
-- 												--AND CAST(PMR.[Date] AS DATE) <> @FormatActualDate
-- 												AND Tzdb.AreSameSystemDates(PMR.[Date], @Now) = 0
-- 												--AND CAST(SP.[FromDate] AS DATE) <= CAST(PMR.[Date] AS DATE) AND CAST(SP.[ToDate] AS DATE) >= CAST(PMR.[Date] AS DATE))))
-- 												AND Tzdb.IsLowerOrSameSystemDate(SP.[FromDate], PMR.[Date]) = 1 AND Tzdb.IsGreaterOrSameSystemDate(SP.[ToDate], PMR.[Date]) = 1)))


-- 	ORDER BY [Id];
-- END
