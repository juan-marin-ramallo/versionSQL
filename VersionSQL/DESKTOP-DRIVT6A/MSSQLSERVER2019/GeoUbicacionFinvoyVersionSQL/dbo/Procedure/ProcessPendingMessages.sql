/****** Object:  Procedure [dbo].[ProcessPendingMessages]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Gastón Legnani
-- Create date: 27/07/2015
-- Description:	SP para procesar los mensajes agendados a enviar
-- =============================================
CREATE PROCEDURE [dbo].[ProcessPendingMessages]
(
	@MessagesIds [sys].VARCHAR(1000) = NULL
)
AS
BEGIN

	--Actualizo fecha de envio de los mensajes agendados
	UPDATE dbo.[MessageSchedule]
	SET SentDate = GETUTCDATE()
	WHERE	dbo.CheckValueInList([IdMessage], @MessagesIds) = 1
	
	--Inserto mensajes en tabla para que vean en el celular.
	INSERT INTO [dbo].[MessagePersonOfInterest]([IdMessage], [IdPersonOfInterest], [Received], [Read])
	(SELECT ms.[IdMessage] AS IdMessage, ms.[IdPersonOfInterest] AS IdPersonOfInterest, 0 AS Received, 0 AS [Read]
	 FROM	[dbo].[MessageSchedule] ms
	 WHERE	dbo.CheckValueInList(ms.[IdMessage], @MessagesIds) = 1
	)

	SELECT P.[DeviceId] FROM [dbo].[PersonOfInterest] P
	INNER JOIN dbo.MessagePersonOfInterest MP ON P.[Id] = MP.[IdPersonOfInterest]
	WHERE dbo.CheckValueInList(MP.[IdMessage], @MessagesIds) = 1 
	AND P.[DeviceId] IS NOT NULL
END
