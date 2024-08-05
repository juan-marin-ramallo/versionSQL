/****** Object:  Procedure [dbo].[GetUserByEmail]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 14/11/2012
-- Description:	SP para obtener el usuario en base al email
-- =============================================
CREATE PROCEDURE [dbo].[GetUserByEmail]
(
	@Email [sys].[varchar](255)
)
AS
BEGIN
	SELECT	[Id], [Name], [LastName], [Email], [UserName], [FirstTimeLogin], [Type], 
			[Status], [ChangePassword], [SuperAdmin], [IdPersonOfInterest], [MicrosoftAccessToken],
			[MicrosoftAccessToken], [MicrosoftAccessTokenExpiration], [MicrosoftRefreshToken], [MicrosoftCalendarId]
	FROM	[dbo].[User] WITH (NOLOCK)
	WHERE	[Email] = @Email
END
