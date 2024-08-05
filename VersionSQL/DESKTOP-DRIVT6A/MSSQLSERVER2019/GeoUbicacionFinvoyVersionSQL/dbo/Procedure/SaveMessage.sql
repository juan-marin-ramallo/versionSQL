/****** Object:  Procedure [dbo].[SaveMessage]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================  
-- Author:  Jesús Portillo  
-- Create date: 25/09/2012  
-- Description: SP para guardar un mensaje  
-- =============================================  
CREATE PROCEDURE [dbo].[SaveMessage]  
(  
  @Subject [sys].[varchar](100)  
 ,@Importance [sys].[smallint]  
 ,@Message [sys].[varchar](8000)  
 ,@IdPersonsOfInterest [sys].[varchar](1000)  
 ,@AllowReply [sys].[bit]  
 ,@IdUser [sys].[INT]  
 ,@Date [sys].[DateTime] = NULL
)  
AS  
BEGIN  
 DECLARE @Now [sys].[datetime]  
 SET @Now = ISNULL(@Date, GETUTCDATE())  
  
 DECLARE @Id [sys].[int]  
  
 INSERT INTO [dbo].[Message]([Date], [Importance], [Subject], [Message], [IdUser],[TheoricalSentDate], [ModifiedDate], [Deleted], [AllowReply])  
 VALUES (@Now, @Importance, @Subject, @Message, @IdUser,@Now, NULL, 0, @AllowReply)  
   
 SELECT @Id = SCOPE_IDENTITY()  
  
 INSERT INTO [dbo].[MessagePersonOfInterest]([IdMessage], [IdPersonOfInterest], [Received], [Read])  
 (SELECT @Id AS IdMessage, S.[Id] AS IdPersonOfInterest, 0 AS Received, 0 AS [Read]  
  FROM [dbo].[PersonOfInterest] S WITH (NOLOCK)  
  WHERE dbo.CheckValueInList(S.[Id], @IdPersonsOfInterest) = 1  
 )  
  
 SELECT [DeviceId] FROM [dbo].[PersonOfInterest] WITH (NOLOCK) WHERE dbo.CheckValueInList([Id], @IdPersonsOfInterest) = 1  
              AND [DeviceId] IS NOT NULL  
END
