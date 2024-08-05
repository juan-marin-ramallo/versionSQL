/****** Object:  Procedure [dbo].[SaveMessageSchedule]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 22/07/2015
-- Description:	SP para guardar un mensaje AGENDADO
-- =============================================
CREATE PROCEDURE [dbo].[SaveMessageSchedule]
(
	 @Subject [sys].[varchar](100)
	,@Importance [sys].[smallint]
	,@Message [sys].[varchar](8000)
	,@IdPersonsOfInterest [sys].[varchar](1000)
	,@IdUser [sys].[INT]
	,@AllowReply [sys].[bit]
	,@ScheduledDate [sys].[datetime]
)
AS
BEGIN
	DECLARE @Id [sys].[int]

	INSERT INTO [dbo].[Message]([Date], [Importance], [Subject], [Message], [IdUser],[TheoricalSentDate], [ModifiedDate], [Deleted], [AllowReply])
	VALUES (GETUTCDATE(), @Importance, @Subject, @Message, @IdUser,@ScheduledDate,NULL,0, @AllowReply)
	
	SET @Id = SCOPE_IDENTITY()

	INSERT INTO [dbo].[MessageSchedule]([IdMessage], [IdPersonOfInterest], [SentDate])
	(SELECT @Id AS IdMessage, S.[Id] AS IdPersonOfInterest, NULL
	 FROM	[dbo].[PersonOfInterest] S WITH (NOLOCK)
	 WHERE	dbo.CheckValueInList(S.[Id], @IdPersonsOfInterest) = 1
	)

	SELECT @Id

	--SELECT	RTRIM(LTRIM([Name])) + RTRIM(' ' + LTRIM([LastName])) AS PersonOfInterestFullName, [DeviceId]
	--FROM	[dbo].[PersonOfInterest] WITH (NOLOCK)
	--WHERE	dbo.CheckValueInList([Id], @IdPersonsOfInterest) = 1 AND [DeviceId] IS NOT NULL
END
