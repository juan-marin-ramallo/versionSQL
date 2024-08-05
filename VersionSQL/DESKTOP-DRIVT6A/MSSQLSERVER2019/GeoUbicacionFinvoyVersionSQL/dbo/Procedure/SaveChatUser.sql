/****** Object:  Procedure [dbo].[SaveChatUser]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 28/02/2018
-- Description:	SP para guardar un usuario de chat
-- =============================================
CREATE PROCEDURE [dbo].[SaveChatUser]
(
	 @Id [sys].[int] OUTPUT
	,@IdUser [sys].[int] = NULL
	,@IdPersonOfInterest [sys].[int] = NULL
	,@UserId [sys].[varchar](100) = NULL
	,@DisplayName [sys].[varchar](500) = NULL
	,@ImageLink [sys].[varchar](255) = NULL
)
AS
BEGIN
	IF @IdUser IS NOT NULL OR @IdPersonOfInterest IS NOT NULL
	BEGIN
		INSERT INTO [dbo].[ChatUser]([IdUser], [IdPersonOfInterest], [UserId], [DisplayName], [ImageLink], [Deleted])
		VALUES (@IdUser, @IdPersonOfInterest, @UserId, @DisplayName, @ImageLink, 0)
	
		SELECT @Id = SCOPE_IDENTITY()
	END
END
