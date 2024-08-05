/****** Object:  Procedure [dbo].[GetUsersInChargeOfPersonForNotification]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		FS
-- Create date: 23/01/2018
-- Description:	Sp que obtiene todos los uaurios acargo de una persona y que estén susciptos a una notificacion
-- =============================================
CREATE PROCEDURE [dbo].[GetUsersInChargeOfPersonForNotification] 
(
	@PersonOfInterestId [sys].[int]
	, @NotificationCode [sys].[INT]
)
AS
BEGIN
	SELECT U.[Id], U.[Name], U.[LastName], U.[Email]
	FROM [dbo].[PersonOfInterest] P WITH (NOLOCK)
		INNER JOIN [dbo].[PersonOfInterestZone] PZ WITH (NOLOCK) ON P.Id = PZ.IdPersonOfInterest
		INNER JOIN [dbo].[User] U WITH (NOLOCK) ON dbo.CheckZoneInUserZones(Pz.IdZone, U.Id) > 0
		INNER JOIN [dbo].[UserNotification] UN WITH (NOLOCK) ON UN.IdUser = U.Id AND UN.CodeNotification = @NotificationCode
		INNER JOIN [dbo].[NotificationTranslated] N WITH (NOLOCK) ON N.Code = UN.CodeNotification
		LEFT OUTER JOIN [dbo].[UserPermission] UP WITH (NOLOCK) ON Up.IdUser = U.Id AND N.IdPermission = UP.IdPermission
	WHERE P.Id = @PersonOfInterestId AND U.IdPersonOfInterest <> P.Id
		AND (N.IdPermission IS NULL OR UP.IdUser IS NOT NULL)
	GROUP BY U.[Id], U.[Name], U.[LastName], U.[Email]
END
