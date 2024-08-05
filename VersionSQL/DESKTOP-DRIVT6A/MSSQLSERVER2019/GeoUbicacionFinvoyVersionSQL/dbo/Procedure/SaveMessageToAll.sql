/****** Object:  Procedure [dbo].[SaveMessageToAll]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 06/06/2017
-- Description:	SP para guardar un mensaje para todos
-- =============================================
CREATE PROCEDURE [dbo].[SaveMessageToAll]
(
	 @Subject [sys].[varchar](100)
	,@Importance [sys].[smallint]
	,@Message [sys].[varchar](8000)
	,@AllowReply [sys].[bit]
	,@IdUser [sys].[INT]
	,@IdPersonOfInterest [sys].[INT]
)
AS
BEGIN
	DECLARE @Now [sys].[datetime]
	SET @Now = GETUTCDATE()

	DECLARE @Id [sys].[int]

	INSERT INTO [dbo].[Message]([Date], [Importance], [Subject], [Message], [IdUser],[TheoricalSentDate], 
				[ModifiedDate], [Deleted], [AllowReply])
	VALUES		(@Now, @Importance, @Subject, @Message, @IdUser,@Now, NULL, 0, @AllowReply)
	
	SELECT @Id = SCOPE_IDENTITY()

	INSERT INTO [dbo].[MessagePersonOfInterest]([IdMessage], [IdPersonOfInterest], [Received], [Read])
	(SELECT @Id AS IdMessage, S.[Id] AS IdPersonOfInterest, 0 AS Received, 0 AS [Read]
	 FROM	[dbo].[PersonOfInterest] S WITH (NOLOCK)
	 WHERE	S.[Deleted] = 0 AND S.[Id] <> @IdPersonOfInterest
	)

	SELECT	[DeviceId] FROM [dbo].[PersonOfInterest] WITH (NOLOCK)
	WHERE	[Deleted] = 0 AND [DeviceId] IS NOT NULL AND [Id] <> @IdPersonOfInterest

END
