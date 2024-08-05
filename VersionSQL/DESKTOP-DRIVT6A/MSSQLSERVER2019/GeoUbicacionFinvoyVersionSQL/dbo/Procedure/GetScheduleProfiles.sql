/****** Object:  Procedure [dbo].[GetScheduleProfiles]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================      
-- Author:  Gaston L.      
-- Create date: 23/10/2018      
-- Description: SP para obtener los CRONOGRAMAS DE ACTIVIDADES      
-- =============================================      
CREATE PROCEDURE [dbo].[GetScheduleProfiles]      
      
  @IdUser [sys].[int] = NULL      
 ,@PersonOfInterestIds [sys].[varchar](max) = NULL      
 ,@PointOfInterestIds [sys].[varchar](MAX) = NULL      
 ,@ProfileIds [sys].[varchar](MAX) = NULL      
 ,@FilterOption [sys].[int] = 2      
AS      
BEGIN      
 DECLARE @SystemToday [sys].[datetime]      
 SET @SystemToday = DATEADD(DAY, DATEDIFF(DAY, 0, Tzdb.FromUtc(GETUTCDATE())), 0)      
      
 DECLARE @IdUserLocal [sys].[int]      
 DECLARE @PersonOfInterestIdsLocal [sys].[varchar](max)      
 DECLARE @PointOfInterestIdsLocal [sys].[varchar](MAX)      
 DECLARE @FilterOptionLocal [sys].[int]      
 DECLARE @ProfileIdsLocal [sys].[varchar](max)      
      
 SET @IdUserLocal = @IdUser      
 SET @PersonOfInterestIdsLocal = @PersonOfInterestIds      
 SET @PointOfInterestIdsLocal = @PointOfInterestIds      
 SET @ProfileIdsLocal = @ProfileIds      
 SET @FilterOptionLocal = @FilterOption      
      
    ;WITH vScheduleProfiles([Id], [CreatedDate], [Deleted], [FromDate], [ToDate], [ToDateSystemTruncated],      
                           [AllPointOfInterest], [AllPersonOfInterest],      
                           [Description], [IdUser], [RecurrenceCondition], [RecurrenceNumber], [DaysId]) AS      
    (      
        SELECT  SP.[Id], SP.[CreatedDate], SP.[Deleted], SP.[FromDate], SP.[ToDate],      
                    DATEADD(DAY, DATEDIFF(DAY, 0, Tzdb.FromUtc(SP.[ToDate])), 0) AS ToDateSystemTruncated,      
                    SP.[AllPointOfInterest], SP.[AllPersonOfInterest],      
                    SP.[Description], SP.[IdUser], SP.[RecurrenceCondition], SP.[RecurrenceNumber], (SELECT STUFF((SELECT CONCAT(',', [DayOfWeek]) FROM ScheduleProfileDayOfWeek NOLOCK WHERE [IdScheduleProfile] = SP.[Id] FOR XML PATH('')), 1, 1, '')) AS DaysId      
        FROM  [dbo].[ScheduleProfile] SP WITH (NOLOCK)      
    )      
      
 SELECT  F.[Id], U.[Id] AS IdUser, U.[Name] AS UserName, U.[LastName] AS UserLastName,       
    F.[CreatedDate], F.[Deleted], F.[FromDate], F.[ToDate],       
    F.[AllPointOfInterest], F.[AllPersonOfInterest],      
    F.[Description], SPP.IdPersonOfInterestPermission AS PermissionId,      
    POP.[Description] AS PermissionName, SPP.LimitOnlyOnce      
    , SPS.IdProductReportSection, PRP.[Name] as ProductReportSectionName, PRP.[Order] as ProductReportSectionOrder      
    , F.[RecurrenceCondition], F.[RecurrenceNumber], F.[DaysId]    
       
 FROM  [dbo].[User] U WITH (NOLOCK)      
    INNER JOIN vScheduleProfiles F WITH (NOLOCK) ON F.[IdUser] = U.[Id]      
    LEFT JOIN [dbo].[ScheduleProfileAssignation] SP WITH (NOLOCK) ON SP.[IdScheduleProfile] = F.[Id]      
    LEFT JOIN [dbo].[ScheduleProfilePermission] SPP WITH (NOLOCK) ON SPP.[IdScheduleProfile] = F.[Id]      
    LEFT JOIN [dbo].[PersonOfInterestPermissionTranslated] POP WITH (NOLOCK) ON POP.[Id] = SPP.[IdPersonOfInterestPermission]      
    LEFT JOIN [dbo].[ScheduleProfileProductSection] SPS with(nolock)ON SPS.[IdScheduleProfile] = F.[Id]      
    LEFT JOIN [dbo].[ProductReportSection] PRP WITH (NOLOCK) ON SPS.[IdProductReportSection] = PRP.[Id]      
       
 WHERE  (@PersonOfInterestIdsLocal IS NULL OR (F.[AllPersonOfInterest] = 1 OR CHARINDEX(',' + CAST(SP.[IdPersonOfInterest] AS [sys].[varchar](10)) + ',', @PersonOfInterestIdsLocal) > 0)) AND      
    (@PointOfInterestIdsLocal IS NULL OR (F.[AllPointOfInterest] = 1 OR CHARINDEX(',' + CAST(SP.[IdPointOfInterest] AS [sys].[varchar](10)) + ',', @PointOfInterestIdsLocal) > 0))      
    AND      
    ((@FilterOptionLocal = 1)       
     OR (@FilterOptionLocal = 2 AND F.[Deleted] = 0 AND F.[ToDateSystemTruncated] >= @SystemToday) --ACTIVOS      
     OR (@FilterOptionLocal = 3 AND ((F.[Deleted] = 0 AND F.[ToDateSystemTruncated] < @SystemToday) OR (F.[Deleted] = 1))) -- VENCIDOS O DESACTIVADO      
    )      
       
 GROUP BY F.[Id], U.[Id], U.[Name], U.[LastName],       
    F.[CreatedDate], F.[Deleted], F.[FromDate], F.[ToDate],       
    F.[AllPointOfInterest], F.[AllPersonOfInterest],      
    F.[Description], SPP.IdPersonOfInterestPermission,      
    POP.[Description], SPP.LimitOnlyOnce, SPS.IdProductReportSection, PRP.[Name], PRP.[Order],F.[RecurrenceCondition], F.[RecurrenceNumber], F.[DaysId]      
      
 UNION      
      
 SELECT  F.[Id], U.[Id] AS IdUser, U.[Name] AS UserName, U.[LastName] AS UserLastName,       
    F.[CreatedDate], F.[Deleted], F.[FromDate], F.[ToDate],       
    F.[AllPointOfInterest], F.[AllPersonOfInterest],      
    F.[Description], SPP.IdPersonOfInterestPermission AS PermissionId,      
    POP.[Description] AS PermissionName, SPP.LimitOnlyOnce      
    , SPS.IdProductReportSection, PRP.[Name] as ProductReportSectionName, PRP.[Order] as ProductReportSectionOrder      
    , F.[RecurrenceCondition], F.[RecurrenceNumber], F.[DaysId]    
       
 FROM  [dbo].[User] U WITH (NOLOCK)      
    INNER JOIN vScheduleProfiles F WITH (NOLOCK) ON F.[IdUser] = U.[Id]      
    LEFT JOIN [dbo].[ScheduleProfileGeneralAssignation] SPG WITH (NOLOCK) ON SPG.[IdScheduleProfile] = F.[Id]      
    LEFT JOIN [dbo].[ScheduleProfileAssignation] SP WITH (NOLOCK) ON SP.[IdScheduleProfile] = F.[Id]      
    LEFT JOIN [dbo].[ScheduleProfilePermission] SPP WITH (NOLOCK) ON SPP.[IdScheduleProfile] = F.[Id]      
    LEFT JOIN [dbo].[PersonOfInterestPermissionTranslated] POP WITH (NOLOCK) ON POP.[Id] = SPP.[IdPersonOfInterestPermission]      
    LEFT JOIN [dbo].[ScheduleProfileProductSection] SPS with(nolock)ON SPS.[IdScheduleProfile] = F.[Id]      
    LEFT JOIN [dbo].[ProductReportSection] PRP WITH (NOLOCK) ON SPS.[IdProductReportSection] = PRP.[Id]      
       
 WHERE  (@ProfileIdsLocal IS NULL OR (F.[AllPersonOfInterest] = 1 OR CHARINDEX(',' + CAST(SPG.[IdPersonOfInterestType] AS [sys].[varchar](10)) + ',', @ProfileIdsLocal) > 0)) AND      
    SP.[IdPersonOfInterest] IS NULL AND      
    (@PointOfInterestIdsLocal IS NULL OR (F.[AllPointOfInterest] = 1 OR CHARINDEX(',' + CAST(SP.[IdPointOfInterest] AS [sys].[varchar](10)) + ',', @PointOfInterestIdsLocal) > 0))      
    AND      
    ((@FilterOptionLocal = 1)       
     OR (@FilterOptionLocal = 2 AND F.[Deleted] = 0 AND F.[ToDateSystemTruncated] >= @SystemToday) --ACTIVOS      
     OR (@FilterOptionLocal = 3 AND ((F.[Deleted] = 0 AND F.[ToDateSystemTruncated] < @SystemToday) OR (F.[Deleted] = 1))) -- VENCIDOS O DESACTIVADO      
    )      
       
 GROUP BY F.[Id], U.[Id], U.[Name], U.[LastName],       
    F.[CreatedDate], F.[Deleted], F.[FromDate], F.[ToDate],       
    F.[AllPointOfInterest], F.[AllPersonOfInterest],      
    F.[Description], SPP.IdPersonOfInterestPermission,      
    POP.[Description], SPP.LimitOnlyOnce, SPS.IdProductReportSection, PRP.[Name], PRP.[Order],F.[RecurrenceCondition], F.[RecurrenceNumber], F.[DaysId]      
       
 ORDER BY F.[Id], SPP.IdPersonOfInterestPermission ASC, PRP.[Order] ASC      
      
END      
      
-- OLD)      
-- BEGIN      
--  DECLARE @Now [sys].[datetime]      
--     SET @Now = GETUTCDATE()      
      
--  DECLARE @IdUserLocal [sys].[int]      
--  DECLARE @PersonOfInterestIdsLocal [sys].[varchar](max)      
--  DECLARE @PointOfInterestIdsLocal [sys].[varchar](MAX)      
--  DECLARE @FilterOptionLocal [sys].[int]      
--  DECLARE @ProfileIdsLocal [sys].[varchar](max)      
      
--  SET @IdUserLocal = @IdUser      
--  SET @PersonOfInterestIdsLocal = @PersonOfInterestIds      
--  SET @PointOfInterestIdsLocal = @PointOfInterestIds      
--  SET @ProfileIdsLocal = @ProfileIds      
--  SET @FilterOptionLocal = @FilterOption      
      
      
--  SELECT  F.[Id], U.[Id] AS IdUser, U.[Name] AS UserName, U.[LastName] AS UserLastName,       
--     F.[CreatedDate], F.[Deleted], F.[FromDate], F.[ToDate],       
--     F.[AllPointOfInterest], F.[AllPersonOfInterest], F.[LimitOneMissingReport],      
--     F.[Description], SPP.IdPersonOfInterestPermission AS PermissionId,      
--     POP.[Description] AS PermissionName      
       
--  FROM  [dbo].[User] U WITH (NOLOCK)      
--     INNER JOIN [dbo].[ScheduleProfile] F WITH (NOLOCK) ON F.[IdUser] = U.[Id]      
--     LEFT JOIN [dbo].[ScheduleProfileAssignation] SP WITH (NOLOCK) ON SP.[IdScheduleProfile] = F.[Id]      
--     LEFT JOIN [dbo].[ScheduleProfilePermission] SPP WITH (NOLOCK) ON SPP.[IdScheduleProfile] = F.[Id]      
--     LEFT JOIN [dbo].[PersonOfInterestPermissionTranslated] POP WITH (NOLOCK) ON POP.[Id] = SPP.[IdPersonOfInterestPermission]      
       
--  WHERE  (@PersonOfInterestIdsLocal IS NULL OR (F.[AllPersonOfInterest] = 1 OR CHARINDEX(',' + CAST(SP.[IdPersonOfInterest] AS [sys].[varchar](10)) + ',', @PersonOfInterestIdsLocal) > 0)) AND      
--     (@PointOfInterestIdsLocal IS NULL OR (F.[AllPointOfInterest] = 1 OR CHARINDEX(',' + CAST(SP.[IdPointOfInterest] AS [sys].[varchar](10)) + ',', @PointOfInterestIdsLocal) > 0))      
--     AND      
--     ((@FilterOptionLocal = 1)       
--      OR (@FilterOptionLocal = 2 AND F.[Deleted] = 0 AND Tzdb.IsGreaterOrSameSystemDate(F.[ToDate], @Now) = 1) --ACTIVOS      
--      OR (@FilterOptionLocal = 3 AND ((F.[Deleted] = 0 AND Tzdb.IsLowerSystemDate(F.[ToDate], @Now) = 1) OR (F.[Deleted] = 1))) -- VENCIDOS O DESACTIVADO      
--     )      
       
--  GROUP BY F.[Id], U.[Id], U.[Name], U.[LastName],       
--     F.[CreatedDate], F.[Deleted], F.[FromDate], F.[ToDate],       
--     F.[AllPointOfInterest], F.[AllPersonOfInterest], F.[LimitOneMissingReport],      
--     F.[Description], SPP.IdPersonOfInterestPermission,      
--     POP.[Description]      
      
--  UNION      
      
--  SELECT  F.[Id], U.[Id] AS IdUser, U.[Name] AS UserName, U.[LastName] AS UserLastName,       
--     F.[CreatedDate], F.[Deleted], F.[FromDate], F.[ToDate],       
--     F.[AllPointOfInterest], F.[AllPersonOfInterest], F.[LimitOneMissingReport],      
--     F.[Description], SPP.IdPersonOfInterestPermission AS PermissionId,      
--     POP.[Description] AS PermissionName      
       
--  FROM  [dbo].[User] U WITH (NOLOCK)      
--     INNER JOIN [dbo].[ScheduleProfile] F WITH (NOLOCK) ON F.[IdUser] = U.[Id]      
--     LEFT JOIN [dbo].[ScheduleProfileGeneralAssignation] SPG WITH (NOLOCK) ON SPG.[IdScheduleProfile] = F.[Id]      
--     LEFT JOIN [dbo].[ScheduleProfileAssignation] SP WITH (NOLOCK) ON SP.[IdScheduleProfile] = F.[Id]      
--     LEFT JOIN [dbo].[ScheduleProfilePermission] SPP WITH (NOLOCK) ON SPP.[IdScheduleProfile] = F.[Id]      
--     LEFT JOIN [dbo].[PersonOfInterestPermissionTranslated] POP WITH (NOLOCK) ON POP.[Id] = SPP.[IdPersonOfInterestPermission]      
       
--  WHERE  (@ProfileIdsLocal IS NULL OR (F.[AllPersonOfInterest] = 1 OR CHARINDEX(',' + CAST(SPG.[IdPersonOfInterestType] AS [sys].[varchar](10)) + ',', @ProfileIdsLocal) > 0)) AND      
--     SP.[IdPersonOfInterest] IS NULL AND      
--     (@PointOfInterestIdsLocal IS NULL OR (F.[AllPointOfInterest] = 1 OR CHARINDEX(',' + CAST(SP.[IdPointOfInterest] AS [sys].[varchar](10)) + ',', @PointOfInterestIdsLocal) > 0))      
--     AND      
--     ((@FilterOptionLocal = 1)       
--      OR (@FilterOptionLocal = 2 AND F.[Deleted] = 0 AND Tzdb.IsGreaterOrSameSystemDate(F.[ToDate], @Now) = 1) --ACTIVOS      
--      OR (@FilterOptionLocal = 3 AND ((F.[Deleted] = 0 AND Tzdb.IsLowerSystemDate(F.[ToDate], @Now) = 1) OR (F.[Deleted] = 1))) -- VENCIDOS O DESACTIVADO      
--     )      
       
--  GROUP BY F.[Id], U.[Id], U.[Name], U.[LastName],       
--     F.[CreatedDate], F.[Deleted], F.[FromDate], F.[ToDate],       
--     F.[AllPointOfInterest], F.[AllPersonOfInterest], F.[LimitOneMissingReport],      
--     F.[Description], SPP.IdPersonOfInterestPermission,      
--     POP.[Description]      
       
--  ORDER BY F.[Id]      
      
-- END
