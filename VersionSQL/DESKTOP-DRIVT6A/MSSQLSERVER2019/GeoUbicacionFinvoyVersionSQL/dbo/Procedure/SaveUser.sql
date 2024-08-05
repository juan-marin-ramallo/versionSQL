/****** Object:  Procedure [dbo].[SaveUser]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 25/09/2012
-- Description:	SP para guardar un usuario
-- =============================================
CREATE PROCEDURE [dbo].[SaveUser]
(
	 @Id [sys].[int] OUTPUT
	,@Name [sys].[varchar](50)
	,@LastName [sys].[varchar](50)
	,@Email [sys].[varchar](255)
	,@UserName [sys].[varchar](50)
	,@Password [sys].[varchar](150)
	,@Type [sys].[int] = 0
	,@Status [sys].[char](1)
	,@IdPersonOfInterest [sys].[int] = NULL
	,@AppUserStatus [sys].[char](1)
	,@Result [sys].[smallint] OUTPUT
)
AS
BEGIN
	DECLARE @ExistingEmail [sys].[varchar](255)
	DECLARE @ExistingUserName [sys].[varchar](50)
	
	SET @ExistingEmail = (SELECT U.Email FROM [dbo].[User] U WHERE U.Email = @Email)
	SET @ExistingUserName = (SELECT U.UserName FROM [dbo].[User] U WHERE U.UserName = @UserName)

	IF @ExistingEmail IS NULL AND @ExistingUserName IS NULL
		BEGIN
			INSERT INTO [dbo].[User]([Name], [LastName], [Email], [UserName], [Password], [FirstTimeLogin], 
				[Type], [Status], [SuperAdmin], [ChangePassword], [IdPersonOfInterest], [AppUserStatus])
			VALUES (@Name, @LastName, @Email, @UserName, @Password, 1, 
				@Type, @Status, 0, 0, @IdPersonOfInterest, @AppUserStatus)
	
			SELECT @Id = SCOPE_IDENTITY()
			SET @Result = 0
			
			--INSERT INTO [dbo].[UserNotification](IdUser, CodeNotification)
			--SELECT @Id, Code FROM [dbo].[Notification]
		END
	ELSE
	BEGIN
		SET @Result = 0
		IF @ExistingUserName = @UserName
		BEGIN
			SET @Result = @Result + 1
		END	
		IF @ExistingEmail = @Email
		BEGIN
			SET @Result = @Result + 2
		END
	END
END
