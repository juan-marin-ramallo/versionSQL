/****** Object:  Procedure [dbo].[UpdateUser]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 25/09/2012
-- Description:	SP para actualizar un usuario
-- =============================================
CREATE PROCEDURE [dbo].[UpdateUser]
(
	 @Id [sys].[int]
	,@Name [sys].[varchar](50)
	,@LastName [sys].[varchar](50)
	,@Email [sys].[varchar](255)
	,@Password [sys].[varchar](150) = NULL
	,@Type [sys].[int] = 0
	,@Status [sys].[char](1)
	,@IdPersonOfInterest [sys].[int] = NULL
	,@AppUserStatus [sys].[char](1)
	,@Result [sys].[smallint] OUTPUT
)
AS
BEGIN
	DECLARE @ExistingEmail [sys].[varchar](255)
	
	SET @ExistingEmail = (SELECT U.Email FROM [dbo].[User] U WHERE U.Id <> @Id AND U.Email = @Email)

	IF @ExistingEmail IS NULL
		BEGIN
			-- Obtengo todas las notis y subscriptores
			DECLARE @SubsCount Table(CodeNotification [int], SubCount [int])
			INSERT INTO @SubsCount (CodeNotification, SubCount)
			SELECT n.Code, COUNT(u.Id) as SubCount
			FROM [dbo].[Notification] n
			LEFT OUTER JOIN [dbo].[UserNotification] un on un.CodeNotification = n.Code
			LEFT OUTER JOIN [dbo].[User] u on u.Id = un.IdUser and u.[Status] = 'H'
			GROUP BY n.Code

			UPDATE	[dbo].[User]
			SET		 [Name] = @Name
					,[LastName] = @LastName
					,[Email] = @Email
					,[Password] = ISNULL(@Password, [Password])
					,[Type] = @Type
					,[Status] = @Status
					,[IdPersonOfInterest] = @IdPersonOfInterest
					,[AppUserStatus] = @AppUserStatus
			WHERE	[Id] = @Id

			SET @Result = 0

			SELECT sc.CodeNotification, 
				CASE
				WHEN @Status = 'H' AND COUNT(u.Id) > 0 AND sc.SubCount = 0 THEN 1 -- suscribo y no había -> prendo noti
				WHEN @Status = 'D' AND COUNT(u.Id) = 0 AND sc.SubCount > 0 THEN -1 -- desuscribo, no hay y antes había -> apago noti
				ELSE 0 END AS Subscribe -- No modifico la notificación
			FROM @SubsCount sc
			LEFT OUTER JOIN [dbo].[UserNotification] n ON n.CodeNotification = sc.CodeNotification
			LEFT OUTER JOIN [dbo].[User] u on u.Id = n.IdUser and u.[Status] = 'H'
			GROUP BY sc.CodeNotification, sc.SubCount
		END
	ELSE IF @ExistingEmail = @Email
	BEGIN
		SET @Result = 2
	END
END
