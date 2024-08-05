/****** Object:  Procedure [dbo].[GetActiveScheduledReports]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<GL
-- Create date: 04-03-2019
-- Description:	Devuelve envios de reportes automaticos activos
-- =============================================
CREATE PROCEDURE [dbo].[GetActiveScheduledReports]
	 @UserIds varchar(max) = NULL
	,@ReportTypeIds varchar(max) = NULL
	,@FilterOption [sys].[int] = 2
AS
BEGIN
    DECLARE @SystemToday [sys].[datetime]
	SET @SystemToday = DATEADD(DAY, DATEDIFF(DAY, 0, Tzdb.FromUtc(GETUTCDATE())), 0)

	;WITH ScheduleReports([Id], [Name], [IdTypeReport], [DateFrom], [DateFromSystemTruncated],
                          [DateTo], [DateToSystemTruncated], [SubjectEmail], [RecurrenceCondition],
                          [RecurrenceNumber], [FileFormat], [SendingHour], [CreatedDate], [Deleted]) AS
    (
        SELECT  SR.[Id], SR.[Name], SR.[IdTypeReport],
                SR.[DateFrom], DATEADD(DAY, DATEDIFF(DAY, 0, Tzdb.FromUtc(SR.[DateFrom])), 0) AS DateFromSystemTruncated,
                SR.[DateTo], DATEADD(DAY, DATEDIFF(DAY, 0, Tzdb.FromUtc(SR.[DateTo])), 0) AS DateToSystemTruncated,
			    SR.[SubjectEmail],  SR.[RecurrenceCondition], SR.[RecurrenceNumber],
                SR.[FileFormat], SR.[SendingHour], SR.[CreatedDate], SR.[Deleted]
	    FROM	[dbo].[ScheduleReport] SR WITH (NOLOCK)
    )
	
	SELECT	SR.[Id], SR.[Name], SR.[IdTypeReport], SR.[DateFrom], SR.[DateTo],
			SR.[SubjectEmail],  SRT.[Name] AS ReportTypeName,
			SR.[RecurrenceCondition], SR.[RecurrenceNumber], SR.[FileFormat] AS IdFileFormat,
			AVT.[FileType] AS FileFormatName, SR.[SendingHour],SR.[CreatedDate], SR.[Deleted]
	
	FROM		ScheduleReports SR WITH (NOLOCK)
	JOIN		[dbo].[ScheduleReportTypeTranslated] SRT WITH (NOLOCK) ON SRT.[Id] = SR.[IdTypeReport]
	JOIN		[dbo].[AvailableFileTypeTranslated] AVT WITH (NOLOCK) ON AVT.[Id] = SR.[FileFormat]
	LEFT JOIN	[dbo].[ScheduleReportUser] SRU WITH (NOLOCK) ON SRU.[IdScheduleReport] = SR.[Id]
	
	WHERE		((@ReportTypeIds IS NULL) OR (dbo.[CheckValueInList](SRT.[Id], @ReportTypeIds) = 1))
				AND ((@UserIds IS NULL) OR (dbo.[CheckValueInList](SRU.[IdUser], @UserIds) = 1))
				AND
				((@FilterOption = 1) 
					OR (@FilterOption = 2 AND SR.[Deleted] = 0 AND (SR.[DateFromSystemTruncated] <= @SystemToday AND SR.[DateToSystemTruncated] >= @SystemToday)) --ACTIVOS
					OR (@FilterOption = 3 AND SR.[Deleted] = 0 AND (SR.[DateToSystemTruncated] < @SystemToday)) -- VENCIDOS
					OR (@FilterOption = 4 AND SR.[Deleted] = 1) -- Eliminados
					OR (@FilterOption = 5 AND SR.[Deleted] = 0 AND (SR.[DateFromSystemTruncated] > @SystemToday)) -- PLANIFICADOS
				)

	GROUP BY SR.[Id], SR.[Name], SR.[IdTypeReport], SR.[DateFrom], SR.[DateTo],
			SR.[SubjectEmail],  SRT.[Name] , SR.[RecurrenceCondition], SR.[RecurrenceNumber], 
			SR.[FileFormat] ,AVT.[FileType], SR.[SendingHour],SR.[CreatedDate], SR.[Deleted]

	ORDER BY SR.[CreatedDate] DESC

END

-- OLD)
-- BEGIN
--     DECLARE @Now [sys].[datetime]
--     SET @Now = GETUTCDATE()
	
-- 	SELECT	SR.[Id], SR.[Name], SR.[IdTypeReport], SR.[DateFrom], SR.[DateTo],
-- 			SR.[SubjectEmail],  SRT.[Name] AS ReportTypeName,
-- 			SR.[RecurrenceCondition], SR.[RecurrenceNumber], SR.[FileFormat] AS IdFileFormat,
-- 			AVT.[FileType] AS FileFormatName, SR.[SendingHour],SR.[CreatedDate], SR.[Deleted]
	
-- 	FROM		[dbo].[ScheduleReport] SR
-- 	JOIN		[dbo].[ScheduleReportTypeTranslated] SRT ON SRT.[Id] = SR.[IdTypeReport]
-- 	JOIN		[dbo].[AvailableFileTypeTranslated] AVT ON AVT.[Id] = SR.[FileFormat]
-- 	LEFT JOIN	[dbo].[ScheduleReportUser] SRU ON SRU.[IdScheduleReport] = SR.[Id]
	
-- 	WHERE		((@ReportTypeIds IS NULL) OR (dbo.[CheckValueInList](SRT.[Id], @ReportTypeIds) = 1))
-- 				AND ((@UserIds IS NULL) OR (dbo.[CheckValueInList](SRU.[IdUser], @UserIds) = 1))
-- 				AND
-- 				((@FilterOption = 1) 
-- 					OR (@FilterOption = 2 AND SR.[Deleted] = 0 AND (Tzdb.IsLowerOrSameSystemDate(SR.[DateFrom], @Now) = 1 AND Tzdb.IsGreaterOrSameSystemDate(SR.[DateTo], @Now) = 1)) --ACTIVOS
-- 					OR (@FilterOption = 3 AND SR.[Deleted] = 0 AND (Tzdb.IsLowerSystemDate(SR.[DateTo], @Now) = 1)) -- VENCIDOS
-- 					OR (@FilterOption = 4 AND SR.[Deleted] = 1) -- Eliminados
-- 					OR (@FilterOption = 5 AND SR.[Deleted] = 0 AND (Tzdb.IsGreaterSystemDate(SR.[DateFrom], @Now) = 1)) -- PLANIFICADOS
-- 				)

-- 	GROUP BY SR.[Id], SR.[Name], SR.[IdTypeReport], SR.[DateFrom], SR.[DateTo],
-- 			SR.[SubjectEmail],  SRT.[Name] , SR.[RecurrenceCondition], SR.[RecurrenceNumber], 
-- 			SR.[FileFormat] ,AVT.[FileType], SR.[SendingHour],SR.[CreatedDate], SR.[Deleted]

-- 	ORDER BY SR.[CreatedDate] DESC

-- END
