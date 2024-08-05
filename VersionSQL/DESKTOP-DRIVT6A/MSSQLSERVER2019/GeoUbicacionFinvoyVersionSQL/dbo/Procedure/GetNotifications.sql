/****** Object:  Procedure [dbo].[GetNotifications]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 14/10/2015
-- Description:	SP para obtener las notificaciones según el evento
-- =============================================
CREATE PROCEDURE [dbo].[GetNotifications]
(
	@NotificationCode [sys].[INT] = NULL
)
AS
BEGIN
	SELECT	N.[Code], N.[Name], N.[Subject], N.[Template], N.[TemplateExcel], N.[Description], N.[Visible]
	FROM	[dbo].[NotificationTranslated] N WITH (NOLOCK)
	WHERE	@NotificationCode IS NULL OR N.Code = @NotificationCode
	GROUP BY	N.[Code], N.[Name], N.[Subject], N.[Template], N.[TemplateExcel], N.[Description], N.[Visible]
	ORDER BY	N.[Code]
END
