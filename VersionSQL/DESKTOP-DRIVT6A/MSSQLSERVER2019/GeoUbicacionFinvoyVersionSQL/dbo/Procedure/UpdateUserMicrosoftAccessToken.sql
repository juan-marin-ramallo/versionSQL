/****** Object:  Procedure [dbo].[UpdateUserMicrosoftAccessToken]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 12/09/17
-- Description:	SP para actualizar el client_id usado para interactuar con office
-- =============================================
CREATE PROCEDURE [dbo].[UpdateUserMicrosoftAccessToken]
(
	 @Id [sys].[int]
	,@MicrosoftAccessToken VARCHAR(2048) = NULL
	,@MicrosoftAccessTokenExpiration DATETIME = NULL
	,@MicrosoftRefreshToken VARCHAR(2048) = NULL
	,@MicrosoftCalendarId VARCHAR(2048) = NULL
)
AS
BEGIN	
	UPDATE	[dbo].[User]
	SET		 [MicrosoftAccessToken] = @MicrosoftAccessToken
			 ,[MicrosoftAccessTokenExpiration] = @MicrosoftAccessTokenExpiration
			 ,[MicrosoftRefreshToken] = @MicrosoftRefreshToken
			 ,[MicrosoftCalendarId] = @MicrosoftCalendarId
	WHERE	[Id] = @Id
END
