/****** Object:  Procedure [dbo].[Login]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 25/09/2012
-- Description:	SP para validar login de un usuario
-- =============================================
CREATE PROCEDURE [dbo].[Login]
(
	 @UserName [sys].[varchar](150)
	,@Password [sys].[varchar](150)
)
AS

BEGIN
	SELECT	Id 
	FROM	[dbo].[User] WITH (NOLOCK)
	WHERE	((UserName = @UserName or Email = @UserName) AND [Password] = @Password AND [Status] = 'H') 
	AND NOT EXISTS (SELECT 1 FROM [dbo].[CustomerValidation] WITH (NOLOCK) WHERE [BlockedWeb] = 1)	
END
