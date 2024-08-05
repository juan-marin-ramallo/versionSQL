/****** Object:  Procedure [dbo].[GetScheduleProductReportSectionsByPointOfInterest]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 26/10/2018
-- Description:	SP para buscar permisos por punto y por persona
-- =============================================
CREATE PROCEDURE [dbo].[GetScheduleProductReportSectionsByPointOfInterest]
(
	 @IdPersonOfInterest [int],
	 @IdPointOfInterest [int]
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
    vScheduleProfile([Id], [AllPersonOfInterest], [AllPointOfInterest], [FromDateSystemTruncated], [ToDateSystemTruncated]) AS
    (
        SELECT  [Id], [AllPersonOfInterest], [AllPointOfInterest],
                DATEADD(DAY, DATEDIFF(DAY, 0, Tzdb.FromUtc([FromDate])), 0) AS FromDateSystemTruncated,
                DATEADD(DAY, DATEDIFF(DAY, 0, Tzdb.FromUtc([ToDate])), 0) AS ToDateSystemTruncated
        FROM    [dbo].[ScheduleProfile] WITH (NOLOCK)
        WHERE   [Deleted] = 0
    )

	--Busco los que son para todas las personas o todos los puntos
	SELECT	P.[Id], P.[Name], P.[Description], P.[Order], P.[Deleted], P.[FullDeleted] 
	FROM	[dbo].[ScheduleProfileProductSection] S with(nolock)
			INNER JOIN vScheduleProfile SP WITH(NOLOCK) ON SP.[Id] = S.[IdScheduleProfile]
			INNER JOIN dbo.[ProductReportSection] P WITH (NOLOCK) ON S.[IdProductReportSection] = P.[Id]
			LEFT JOIN  [dbo].[ScheduleProfileAssignation] SPA WITH(NOLOCK) ON SPA.[IdScheduleProfile] = SP.[Id]
	WHERE	(SP.[AllPersonOfInterest] = 1 OR (SPA.[IdPersonOfInterest] = @IdPersonOfInterest)) AND
			(SP.[AllPointOfInterest] = 1 OR (SPA.[IdPointOfInterest] = @IdPointOfInterest)) AND
			P.[Deleted] = 0 AND
            SP.[FromDateSystemTruncated] <= @SystemToday AND SP.[ToDateSystemTruncated] >= @SystemToday
	GROUP BY P.[Id], P.[Name], P.[Description], P.[Order], P.[Deleted], P.[FullDeleted] 

	UNION
	
	SELECT	P.[Id], P.[Name], P.[Description], P.[Order], P.[Deleted], P.[FullDeleted] 
	FROM	[dbo].[ScheduleProfileProductSection] S with(nolock)
			INNER JOIN vScheduleProfile SP WITH(NOLOCK) ON SP.[Id] = S.[IdScheduleProfile]
			INNER JOIN dbo.[ProductReportSection] P WITH (NOLOCK) ON S.[IdProductReportSection] = P.[Id]
			LEFT JOIN  [dbo].[ScheduleProfileGeneralAssignation] SPGA WITH(NOLOCK) ON SPGA.[IdScheduleProfile] = SP.[Id]
			LEFT JOIN  [dbo].[ScheduleProfileAssignation] SPA WITH(NOLOCK) ON SPA.[IdScheduleProfile] = SP.[Id]
	WHERE	(SP.[AllPersonOfInterest] = 1 OR (SPA.[IdPersonOfInterest] = @IdPersonOfInterest)) AND
			(SP.[AllPointOfInterest] = 1 OR (SPA.[IdPointOfInterest] = @IdPointOfInterest)) AND
			P.[Deleted] = 0 AND
            SP.[FromDateSystemTruncated] <= @SystemToday AND SP.[ToDateSystemTruncated] >= @SystemToday

	GROUP BY P.[Id], P.[Name], P.[Description], P.[Order], P.[Deleted], P.[FullDeleted] 
	ORDER BY P.[Order] ASC

END
