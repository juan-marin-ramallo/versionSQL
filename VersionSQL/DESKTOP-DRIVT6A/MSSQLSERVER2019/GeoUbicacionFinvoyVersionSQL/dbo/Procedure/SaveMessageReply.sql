/****** Object:  Procedure [dbo].[SaveMessageReply]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 28/07/2016
-- Description:	SP para guardar una respuesta a un aviso
-- =============================================
CREATE PROCEDURE [dbo].[SaveMessageReply]
	@IdPersonOfInterest [sys].[INT],
	@IdMessage [sys].[INT],
	@Message [sys].[VARCHAR](1000) = NULL,
	@DateReply [sys].[DATETIME],
	@ResultCode [sys].[int] OUT
AS
BEGIN
	SET @ResultCode = 0

	IF EXISTS (SELECT 1 FROM [dbo].[Message] WITH (NOLOCK) WHERE [Id] = @IdMessage) 
	BEGIN	

		IF NOT EXISTS (SELECT 1 FROM [dbo].[MessageReply] WITH (NOLOCK) WHERE [IdPersonOfInterest] = @IdPersonOfInterest AND [IdMessage] = @IdMessage)
		BEGIN
			INSERT INTO [dbo].[MessageReply]([Message], [IdPersonOfInterest], [IdMessage], [Date], [ReceivedDate])
			VALUES		(@Message, @IdPersonOfInterest, @IdMessage, @DateReply, GETUTCDATE())

			DECLARE @ReplyId int = SCOPE_IDENTITY()
			DECLARE @MessageUserId int = (SELECT IdUser FROM [dbo].[Message] WHERE [Id] = @IdMessage)

			INSERT INTO [dbo].[MessageReplyUser]([IdMessageReply], [IdUser])
			SELECT @ReplyId, u.Id
			FROM [dbo].[User] u WITH (NOLOCK)
			WHERE u.[Status] = 'H' AND EXISTS (SELECT TOP 1 1 FROM [dbo].[UserPermission] up WITH (NOLOCK) WHERE up.IdUser = u.Id AND up.IdPermission = 9 AND (@MessageUserId = u.Id OR up.CanViewAll = 1 ))
		END
		SET @ResultCode = 1
	END
END
