/****** Object:  Procedure [dbo].[UpdateUserLastLogin]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		gl
-- Create date: 27/01/2021
-- Description:	SP para obtener el usuario en base al nombre de usuario
-- =============================================
CREATE PROCEDURE [dbo].[UpdateUserLastLogin]
(
	@UserName [sys].[varchar](50)
)
AS
BEGIN
	UPDATE	[dbo].[User]
	SET		[LastLoginDate] = GETUTCDATE()
	WHERE	[UserName] = @UserName
END
