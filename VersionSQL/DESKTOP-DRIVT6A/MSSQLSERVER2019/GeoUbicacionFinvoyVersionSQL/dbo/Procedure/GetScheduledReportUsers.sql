/****** Object:  Procedure [dbo].[GetScheduledReportUsers]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<GL
-- Create date: 04-03-2019
-- Description:	Devuelve usuarios asociados a un reprote automatico
-- =============================================
CREATE PROCEDURE [dbo].[GetScheduledReportUsers]
	 @IdScheduleReport [sys].[int]
AS
BEGIN
	
	SELECT	SR.[Id] AS ScheduleReportId, SR.[Name] AS ScheduleReportName,
			U.[Id] AS UserId, U.[Name] AS UserName, U.[LastName] AS UserLastName, U.[Email] AS UserEmail
	
	FROM	[dbo].[ScheduleReport] SR
	JOIN	[dbo].[ScheduleReportUser] SRU ON SRU.[IdScheduleReport] = SR.[Id]
	JOIN	[dbo].[User] U ON SRU.[IdUser] = U.[Id]
	
	WHERE SR.[Deleted] = 0 AND SR.[Id] = @IdScheduleReport

	GROUP BY SR.[Id], SR.[Name], U.[Id], U.[Name], U.[LastName], U.[Email]

END
