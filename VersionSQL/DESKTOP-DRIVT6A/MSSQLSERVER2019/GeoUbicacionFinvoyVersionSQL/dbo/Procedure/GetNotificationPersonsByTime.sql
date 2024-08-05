/****** Object:  Procedure [dbo].[GetNotificationPersonsByTime]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 22/12/2017
-- Description:	SP para obtener las suscripciones a  notificaciones según el evento y la hora que hay que enviarlo.
-- =============================================
CREATE PROCEDURE [dbo].[GetNotificationPersonsByTime]
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
	
	IF DATEDIFF(SECOND, @DateToCheck, @DateToSend) BETWEEN -150 AND 150 -- 2.5min
	BEGIN
		SELECT	N.[Code], N.[Name], N.[Subject], N.[Template], N.[TemplateExcel],
				S.[Id] as [PersonId], S.[Name] as [PersonName], S.[LastName] as [PersonLastName], 
				S.[Email] AS [PersonEmail], S.[Identifier] AS PersonIdentifier
	
		FROM	[dbo].[NotificationTranslated] N WITH (NOLOCK),
				[dbo].[PersonOfInterest] S WITH(NOLOCK) 
	
		WHERE	N.[Code] = @NotificationCode
				AND S.[Status] = 'H' AND S.Email IS NOT NULL
				AND (N.[IdPersonPermission] IS NULL 
					OR EXISTS (SELECT TOP 1 1 FROM [dbo].[PersonOfInterestTypePermission] PTP WITH(NOLOCK) 
							   WHERE N.IdPersonPermission = PTP.IdPersonOfInterestPermission AND PTP.CodePersonOfInterestType = S.[Type]))
	
		GROUP BY N.[Code], N.[Name], N.[Subject], N.[Template], N.[TemplateExcel],
				S.[Id], S.[Name], S.[LastName], S.[Email], S.[Identifier]
		ORDER BY N.[Code], S.[Id]
	END
END
