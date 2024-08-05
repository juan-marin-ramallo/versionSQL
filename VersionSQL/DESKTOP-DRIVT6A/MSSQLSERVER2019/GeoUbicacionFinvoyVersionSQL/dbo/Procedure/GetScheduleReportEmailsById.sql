/****** Object:  Procedure [dbo].[GetScheduleReportEmailsById]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 17/04/2019
-- Description:	SP para obtener los emails a enviar de los reportes automaticos
-- =============================================
CREATE PROCEDURE [dbo].[GetScheduleReportEmailsById]
(
	@ScheduleReportId [sys].[int] 
)
AS
BEGIN

	SELECT	SR.[Id], SR.[IdScheduleReport], SR.[DateFrom], SR.[DateTo], S.[BodyEmail], 
			S.[SubjectEmail], S.[FileLink], S.[IdTypeReport],
			U.[Email], U.[Id] as IdUser, SRUE.Email AS ExternalEmail
	
	FROM	[dbo].[ScheduleReport] S 
	JOIN	[dbo].[ScheduleReportEmailsToSend] SR ON S.[Id] = SR.[IdScheduleReport]
	left outer JOIN	[dbo].[ScheduleReportUser] SRU ON SRU.[IdScheduleReport] = S.[Id]	
	left outer JOIN	[dbo].[User] U ON U.[Id] = SRU.[IdUser]	
	LEFT OUTER JOIN [dbo].[ScheduleReportUserEmail] SRUE ON SRUE.IdScheduleReport = S.Id
	
	WHERE	S.Id = @ScheduleReportId AND SR.[Sent] = 0 AND S.[Deleted] = 0 
			AND SR.[SendingAttempts] < 15 
			AND SR.[EmailSendDateTime] <= GETUTCDATE()
	
	GROUP BY	SR.[Id], SR.[IdScheduleReport], S.[IdTypeReport], SR.[DateFrom],
				SR.[DateTo], S.[BodyEmail], S.[SubjectEmail], S.[FileLink],
				U.[Email], U.[Id], SRUE.Email
	ORDER BY SR.Id

END
