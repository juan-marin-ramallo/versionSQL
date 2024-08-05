/****** Object:  Procedure [dbo].[GetNotificationSuscriptorsByTime]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 22/12/2017
-- Description:	SP para obtener las suscripciones a  notificaciones según el evento y la hora que hay que enviarlo.
-- =============================================
CREATE PROCEDURE [dbo].[GetNotificationSuscriptorsByTime]
(
	@NotificationCode [sys].[int],
	@DateToCheck [sys].[datetime],
	@ConfigurationId [sys].[int]
)
AS
BEGIN
	DECLARE @DateToCheckSystem [sys].[datetime] = Tzdb.FromUtc(@DateToCheck)
	DECLARE @DateToSend [sys].[datetime] = (SELECT CAST([Value] AS [sys].[datetime]) FROM [dbo].[ConfigurationTranslated] WITH (NOLOCK) 
										WHERE [Id] = @ConfigurationId)
	SET @DateToSend = Tzdb.ToUtc(DATEADD(DAY, DATEDIFF(DAY, 0, @DateToCheckSystem), @DateToSend)) -- Current date with configuration time

	SELECT	N.[Code], N.[Name], N.[Subject], N.[Template], N.[TemplateExcel],
			U.[Id] as [UserId], U.[Name] as [UserFirstName], U.[LastName] as [UserLastName], 
			U.[Email] AS [UserEmail], U.[UserName] AS UserUserName
	
	FROM	[dbo].[NotificationTranslated] N WITH (NOLOCK)
			INNER JOIN [dbo].[UserNotification] UN WITH (NOLOCK) ON N.[Code] = UN.[CodeNotification]
			INNER JOIN [dbo].[User] U WITH (NOLOCK) ON UN.[IdUser] = U.[Id]
			LEFT JOIN [dbo].[PermissionTranslated] P WITH (NOLOCK) ON P.[Id] = N.[IdPermission]
	
	WHERE	N.[Code] = @NotificationCode
			AND (N.[IdPermission] IS NULL OR EXISTS (SELECT 1 FROM [dbo].[UserPermission] UP 
			WHERE UP.[IdUser] = U.[Id] AND UP.[IdPermission] = P.[Id]))
			AND U.[Status] = 'H' AND
			(DATEDIFF(SECOND, @DateToCheck, @DateToSend) BETWEEN -150 AND 150) -- 2.5min
	
	GROUP BY	N.[Code], N.[Name], N.[Subject], N.[Template], N.[TemplateExcel]
				, U.[Id], U.[Name], U.[LastName], U.[Email], U.[UserName]
	ORDER BY	N.[Code], U.[Id]
END
