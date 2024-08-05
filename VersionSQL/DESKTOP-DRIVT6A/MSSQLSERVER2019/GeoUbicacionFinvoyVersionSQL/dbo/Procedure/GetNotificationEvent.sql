/****** Object:  Procedure [dbo].[GetNotificationEvent]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 14/10/2015
-- Description:	SP para obtener los eventos de notificaciones
-- =============================================
CREATE PROCEDURE [dbo].[GetNotificationEvent]
(
	@NotificationCode [sys].[int],
	@EventType [sys].[int]
)
AS
BEGIN
	SELECT	E.[Code], E.[Name], E.[Type], E.[Visible], C.[Value] AS [ConfigurationValue]
	FROM	[dbo].[NotificationEvent] E WITH (NOLOCK)
			INNER JOIN [dbo].[NotificationEventNotification] NEN WITH (NOLOCK) ON NEN.[CodeEvent] = E.[Code]
			LEFT OUTER JOIN [dbo].[ConfigurationTranslated] C WITH (NOLOCK) ON E.[IdConfiguration] = C.[Id]
	WHERE	NEN.[CodeNotification] = @NotificationCode AND E.[Type] = @EventType
END
