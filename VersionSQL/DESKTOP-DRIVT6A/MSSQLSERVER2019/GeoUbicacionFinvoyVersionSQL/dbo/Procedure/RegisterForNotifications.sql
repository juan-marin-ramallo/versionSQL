/****** Object:  Procedure [dbo].[RegisterForNotifications]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Juan Manuel Sobral
-- Create date: 25/03/2014
-- Description:	SP para registrarse a las push notification
-- =============================================
CREATE PROCEDURE [dbo].[RegisterForNotifications]
(	
	@PersonOfInterestId [sys].[int]
	,@DeviceId [sys].[varchar](300) = NULL
)
AS
BEGIN
	UPDATE	[dbo].[PersonOfInterest]
	SET		[DeviceId] = NULL
	WHERE	[DeviceId] = @DeviceId

	UPDATE	[dbo].[PersonOfInterest]
	SET		[DeviceId] = @DeviceId
	WHERE	[Id] = @PersonOfInterestId
END
