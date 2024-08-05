/****** Object:  Procedure [dbo].[GetNotification]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 24/11/2015
-- Description:	SP para obtener las notificaciones según el evento
-- =============================================
CREATE PROCEDURE [dbo].[GetNotification]
(
	@NotificationCode [sys].[int]
   ,@PointsOfInterestIds [sys].[varchar](2000) = null
)
AS
BEGIN
	SELECT	N.[Code], N.[Name], N.[Subject], N.[Template], N.[TemplateExcel]
			, U.[Id] as [UserId], U.[Name] as [UserFirstName], U.[LastName] as [UserLastName], U.[Email] AS [UserEmail], U.[UserName] AS UserUserName
	FROM	[dbo].[NotificationTranslated] N WITH (NOLOCK)
			INNER JOIN [dbo].[UserNotification] UN WITH (NOLOCK) ON N.[Code] = UN.[CodeNotification]
			INNER JOIN [dbo].[User] U WITH (NOLOCK) ON UN.[IdUser] = U.[Id]
			LEFT OUTER JOIN [dbo].[UserZone] UZ WITH (NOLOCK) ON U.[Id] = UZ.[IdUser]
			LEFT OUTER JOIN [dbo].[PointOfInterestZone] PZ WITH (NOLOCK) ON PZ.[IdZone] = UZ.[IdZone]
			LEFT JOIN [dbo].[PermissionTranslated] P WITH (NOLOCK) ON P.[Id] = N.[IdPermission]
	WHERE	N.[Code] = @NotificationCode
			AND (@PointsOfInterestIds IS NULL OR
			([dbo].CheckValueInList(PZ.[IdPointOfInterest], @PointsOfInterestIds) > 0 OR UZ.[IdUser] IS NULL))
			AND (N.[IdPermission] IS NULL OR EXISTS (SELECT 1 FROM [dbo].[UserPermission] UP 
			WHERE UP.[IdUser] = U.[Id] AND UP.[IdPermission] = P.[Id]))
			AND U.[Status] = 'H'
	GROUP BY	N.[Code], N.[Name], N.[Subject], N.[Template], N.[TemplateExcel]
				, U.[Id], U.[Name], U.[LastName], U.[Email], U.[UserName]
	ORDER BY	N.[Code], U.[Id]
END
