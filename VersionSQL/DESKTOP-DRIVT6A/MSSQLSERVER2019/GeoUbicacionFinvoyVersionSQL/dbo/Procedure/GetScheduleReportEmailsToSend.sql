/****** Object:  Procedure [dbo].[GetScheduleReportEmailsToSend]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 17/04/2019
-- Description:	SP para obtener los emails a enviar de los reportes automaticos
-- =============================================
CREATE PROCEDURE [dbo].[GetScheduleReportEmailsToSend]
AS
BEGIN

	SELECT	SR.[Id], SR.[IdScheduleReport], SR.[DateFrom], SR.[DateTo], S.[BodyEmail], 
			S.[SubjectEmail], S.[FileLink], S.[IdTypeReport]
	
	FROM	[dbo].[ScheduleReportEmailsToSend] SR
	JOIN	[dbo].[ScheduleReport] S ON S.[Id] = SR.[IdScheduleReport]
	
	WHERE	SR.[Sent] = 0 AND S.[Deleted] = 0 
			AND SR.[SendingAttempts] < 15 
			AND SR.[EmailSendDateTime] <= GETUTCDATE()
	
	GROUP BY	SR.[Id], SR.[IdScheduleReport], S.[IdTypeReport], SR.[DateFrom],
				SR.[DateTo], S.[BodyEmail], S.[SubjectEmail], S.[FileLink]

END
