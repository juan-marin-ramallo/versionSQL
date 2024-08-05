/****** Object:  Procedure [dbo].[DeleteScheduleReport]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 2019-04-03
-- Description:	PARA ELIMINAR UN REPORTE AUTOMATICO
-- =============================================
CREATE PROCEDURE [dbo].[DeleteScheduleReport]
	@Id int
AS
BEGIN
    DECLARE @Now [sys].[datetime]
    SET @Now = GETUTCDATE()
	
	UPDATE [dbo].[ScheduleReport]
	SET [Deleted] = 1, [EditedDate] = @Now
	WHERE [Id] = @Id

	--Elimino envios programados a partir de hoy
	DELETE FROM [dbo].[ScheduleReportEmailsToSend]
	WHERE		[IdScheduleReport] = @Id AND [EmailSendDateTime] > @Now

END
