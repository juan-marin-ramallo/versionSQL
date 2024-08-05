/****** Object:  Procedure [dbo].[SaveMailExceptionLog]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Diego Caceres	
-- Create date: 2015-11-29
-- Description:	Guardar una excepcion de envío de mails
-- =============================================
CREATE PROCEDURE [dbo].[SaveMailExceptionLog]
	@MailTo VARCHAR(50) = NULL,
	@MailSubject VARCHAR(50) = NULL,
	@ExceptionMessage VARCHAR(MAX) = NULL,
	@MailTemplate VARCHAR(MAX) = NULL
AS
BEGIN
	
	INSERT dbo.MailExceptionLog
	        (Date, MailTo, MailSubject, ExceptionMessage, MailTemplate)
	VALUES  (GETUTCDATE(), @MailTo, @MailSubject, @ExceptionMessage, @MailTemplate)

END
