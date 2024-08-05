/****** Object:  Procedure [dbo].[GetScheduledReportEmails]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<GL
-- Create date: 04-03-2019
-- Description:	Devuelve emails asociados a un reprote automatico
-- =============================================
CREATE PROCEDURE [dbo].[GetScheduledReportEmails]
	 @IdScheduleReport [sys].[int]
AS
BEGIN
	
	SELECT	SR.[Id] AS ScheduleReportId, SR.[Name] AS ScheduleReportName, SRU.[Email], SR.[IdTypeReport]
	
	FROM	[dbo].[ScheduleReport] SR
	JOIN	[dbo].[ScheduleReportUserEmail] SRU ON SRU.[IdScheduleReport] = SR.[Id]
	
	WHERE	SR.[Deleted] = 0 AND SR.[Id] = @IdScheduleReport

	GROUP BY SR.[Id], SR.[Name], SRU.[Email], SR.[IdTypeReport]

END
