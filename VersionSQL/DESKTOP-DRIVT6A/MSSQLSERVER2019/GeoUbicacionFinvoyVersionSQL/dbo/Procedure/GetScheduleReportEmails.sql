/****** Object:  Procedure [dbo].[GetScheduleReportEmails]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 17/04/2019
-- Description:	SP para obtener los emails a enviar de los reportes automaticos
-- =============================================
CREATE PROCEDURE [dbo].[GetScheduleReportEmails]
(
	@IdScheduleReport [sys].[int]
)
AS
BEGIN

	SELECT	SR.[Id], U.[Email], U.[Id] as IdUser
	
	FROM	[dbo].[ScheduleReport] SR
	JOIN	[dbo].[ScheduleReportUser] S ON S.[IdScheduleReport] = SR.[Id]	
	JOIN	[dbo].[User] U ON U.[Id] = S.[IdUser]	

	WHERE	SR.[Id] = @IdScheduleReport
	
	UNION

	SELECT	SR.[Id], S.[Email], 0 AS IdUser
	
	FROM	[dbo].[ScheduleReport] SR
	JOIN	[dbo].[ScheduleReportUserEmail] S ON S.[IdScheduleReport] = SR.[Id]		

	WHERE	SR.[Id] = @IdScheduleReport
	

END
