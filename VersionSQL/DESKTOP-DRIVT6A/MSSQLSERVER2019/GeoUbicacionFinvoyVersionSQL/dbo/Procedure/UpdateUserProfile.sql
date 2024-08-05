/****** Object:  Procedure [dbo].[UpdateUserProfile]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 09/11/2012
-- Description:	SP para actualizar el perfil de un usuario
-- =============================================
CREATE PROCEDURE [dbo].[UpdateUserProfile]
(
	 @Id [sys].[int]
	,@Name [sys].[varchar](50)
	,@LastName [sys].[varchar](50)
	,@Email [sys].[varchar](255)
	,@Password [sys].[varchar](150) = NULL
	,@Result [sys].[smallint] OUTPUT
)
AS
BEGIN
	DECLARE @ExistingEmail [sys].[varchar](255)
	
	SET @ExistingEmail = (SELECT U.Email FROM [dbo].[User] U WHERE U.Id <> @Id AND U.Email = @Email)

	IF @ExistingEmail IS NULL
		BEGIN
			UPDATE	[dbo].[User]
			SET		 [Name] = @Name
					,[LastName] = @LastName
					,[Email] = @Email
					,[Password] = ISNULL(@Password, [Password])
			WHERE	[Id] = @Id

			SET @Result = 0
		END
	ELSE IF @ExistingEmail = @Email
		BEGIN
			SET @Result = 2
		END
END
