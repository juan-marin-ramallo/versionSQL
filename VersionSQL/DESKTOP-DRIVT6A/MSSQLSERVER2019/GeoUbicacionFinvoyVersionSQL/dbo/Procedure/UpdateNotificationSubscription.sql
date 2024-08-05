/****** Object:  Procedure [dbo].[UpdateNotificationSubscription]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 06/02/2013
-- Description:	SP actualizar las subscripción a una notificacion
-- =============================================
CREATE PROCEDURE [dbo].[UpdateNotificationSubscription]
(
	 @IdUser [sys].[int]
	,@CodeNotification [sys].[int]
	,@Subscripted [sys].[bit]
)
AS
BEGIN
	DECLARE @SubsCount [sys].[int] = (	SELECT COUNT(n.IdUser) 
										FROM [dbo].[UserNotification] n
										INNER JOIN [dbo].[User] u on u.Id = n.IdUser and u.[Status] = 'H'
										WHERE n.CodeNotification = @CodeNotification)

	IF @Subscripted = 0 
	BEGIN
		DELETE [dbo].[UserNotification]
		WHERE IdUser = @IdUser AND CodeNotification = @CodeNotification
	END
	ELSE IF NOT EXISTS (SELECT 1 FROM [dbo].[UserNotification] WHERE IdUser = @IdUser AND CodeNotification = @CodeNotification)
	BEGIN
		INSERT INTO [dbo].[UserNotification] (IdUser, CodeNotification)
		VALUES (@IdUser, @CodeNotification) 
	END

	SELECT CASE 
			WHEN @Subscripted = 1 AND @SubsCount = 0 THEN 1 -- suscribo y no había -> prendo noti
			WHEN @Subscripted = 0 AND COUNT(n.IdUser) = 0 AND @SubsCount > 0 THEN -1 -- desuscribo, no hay y antes había -> apago noti
			ELSE 0 END -- No modifico la notificación
	FROM [dbo].[UserNotification] n
	INNER JOIN [dbo].[User] u on u.Id = n.IdUser and u.[Status] = 'H'
	WHERE n.CodeNotification = @CodeNotification
END
