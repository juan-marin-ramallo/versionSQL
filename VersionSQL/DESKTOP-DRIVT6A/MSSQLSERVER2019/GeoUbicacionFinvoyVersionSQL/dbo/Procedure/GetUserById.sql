/****** Object:  Procedure [dbo].[GetUserById]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Matias Corso
-- Create date: 15/09/2017
-- Description:	SP para obtener el usuario en base al id
-- =============================================
CREATE PROCEDURE [dbo].[GetUserById]
(
	@Id [sys].[INT]
)
AS
BEGIN
	SELECT	[Id], [Name], [LastName], [Email], [UserName], [FirstTimeLogin], [Type], 
			[Status], [ChangePassword], [SuperAdmin], [IdPersonOfInterest], [MicrosoftAccessToken],
			[MicrosoftAccessToken], [MicrosoftAccessTokenExpiration], [MicrosoftRefreshToken], [MicrosoftCalendarId]
	FROM	[dbo].[User]
	WHERE	[Id] = @Id
END
