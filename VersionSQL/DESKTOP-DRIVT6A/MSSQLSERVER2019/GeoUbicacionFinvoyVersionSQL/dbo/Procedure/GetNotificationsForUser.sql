/****** Object:  Procedure [dbo].[GetNotificationsForUser]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 15/10/2015
-- Description:	SP para obtener las las notificaciones para una Personas de Interes
-- =============================================
CREATE PROCEDURE [dbo].[GetNotificationsForUser]
(
	@IdUser [sys].[int]
)
AS
BEGIN
	SELECT	N.[Code], N.[Name], N.[IdPermission], N.[Description]
			,IIF(UN.IdUser IS NULL, 0, 1) AS [Subscripted]
	FROM	[dbo].[NotificationTranslated] N WITH (NOLOCK)
		LEFT JOIN [dbo].[UserNotification] UN WITH (NOLOCK) ON N.Code = UN.CodeNotification AND UN.IdUser = @IdUser
	WHERE N.[Visible] = 1
	ORDER BY N.[Code]
END
