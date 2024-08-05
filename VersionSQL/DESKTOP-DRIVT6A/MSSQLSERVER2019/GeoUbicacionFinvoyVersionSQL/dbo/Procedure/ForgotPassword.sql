/****** Object:  Procedure [dbo].[ForgotPassword]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 14/11/2012
-- Description:	SP para generar nuevos datos de acceso para un usuario
-- =============================================
CREATE PROCEDURE [dbo].[ForgotPassword]
(
	 @UserName [sys].[varchar](50) = NULL
	,@Email [sys].[varchar](255) = NULL
	,@NewPassword [sys].[varchar](100)
	,@Result [sys].[smallint] OUTPUT
)
AS
BEGIN
	DECLARE @ExistingUserName [sys].[varchar](50)
	DECLARE @ExistingEmail [sys].[varchar](255)
	
	SET @ExistingEmail = (SELECT U.Email FROM [dbo].[User] U WITH (NOLOCK) WHERE U.Email = @Email)
	SET @ExistingUserName = (SELECT U.UserName FROM [dbo].[User] U WITH (NOLOCK) WHERE U.UserName = @UserName)

	IF @UserName IS NULL AND @Email IS NULL
		BEGIN
			SET @Result = 4
		END
	ELSE IF @Email IS NULL AND (@ExistingUserName IS NULL OR  @ExistingUserName <> @UserName)
		BEGIN
			SET @Result = 2
		END
	ELSE IF @UserName IS NULL AND (@ExistingEmail IS NULL OR @ExistingEmail <> @Email)
		BEGIN
			SET @Result = 3
		END
	ELSE IF @ExistingUserName = @UserName OR @ExistingEmail = @Email
		BEGIN
			UPDATE	[dbo].[User]
			SET		[Password] = @NewPassword, [ChangePassword] = 'True'
			WHERE	[UserName] = @UserName OR [Email] = @Email
	
			SET @Result = 1
		END
END
