/****** Object:  Procedure [dbo].[SaveOrUpdateFiscalizationUser]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 16/08/2023
-- Description:	SP para guardar un usuario
--				fiscalizador
-- =============================================
CREATE PROCEDURE [dbo].[SaveOrUpdateFiscalizationUser]
(
	 @Id [sys].[int] OUTPUT
    ,@Name [sys].[varchar](100)
	,@Email [sys].[varchar](255)
	,@Password [sys].[varchar](150)
)
AS
BEGIN
	DECLARE @Now [sys].[datetime] = GETUTCDATE()
	DECLARE @ExpirationDateSystem [sys].[datetime] = DATEADD(DAY, DATEDIFF(DAY, 0, Tzdb.FromUtc(@Now)), 10) --10 days at 00:00

	IF EXISTS (SELECT 1 FROM [dbo].[FiscalizationUser] WITH (NOLOCK) WHERE [Email] = @Email)
	BEGIN
		DECLARE @UpdatedRows TABLE (Id [sys].[int]);

		UPDATE	[dbo].[FiscalizationUser]
		SET		[Name] = @Name, [Password] = @Password, [PasswordRequestedDate] = @Now, [PasswordExpirationDate] = Tzdb.ToUtc(@ExpirationDateSystem)
		OUTPUT	INSERTED.[Id] INTO @UpdatedRows
		WHERE	[Email] = @Email

		SELECT @Id = [Id] FROM @UpdatedRows;
	END
	ELSE
	BEGIN
		INSERT INTO [dbo].[FiscalizationUser]([Name], [Email], [Password], [PasswordRequestedDate], [PasswordExpirationDate], [CreatedDate])
		VALUES (@Name, @Email, @Password, @Now, Tzdb.ToUtc(@ExpirationDateSystem), @Now)
	
		SELECT @Id = SCOPE_IDENTITY()
	END
END
