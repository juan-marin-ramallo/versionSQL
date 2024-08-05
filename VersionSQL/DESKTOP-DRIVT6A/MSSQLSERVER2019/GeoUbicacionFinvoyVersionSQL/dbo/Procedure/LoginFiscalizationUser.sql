/****** Object:  Procedure [dbo].[LoginFiscalizationUser]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 16/08/2023
-- Description:	SP para validar login de un
--				usuario fiscalizador
-- =============================================
CREATE PROCEDURE [dbo].[LoginFiscalizationUser]
(
	 @Email [sys].[varchar](255)
	,@Password [sys].[varchar](150)
)
AS
BEGIN
	DECLARE @Today [sys].[datetime] = DATEADD(DAY, DATEDIFF(DAY, 0, GETUTCDATE()), 0)

	SELECT	[Id], [Name]
	FROM	[dbo].[FiscalizationUser] WITH (NOLOCK)
	WHERE	[Email] = @Email
            AND [Password] = @Password
			AND [PasswordExpirationDate] >= @Today
END
