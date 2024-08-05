/****** Object:  Procedure [dbo].[GetNotificationEvents]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 14/10/2015
-- Description:	SP para obtener los eventos de notificaciones
-- =============================================
CREATE PROCEDURE [dbo].[GetNotificationEvents]
(
	@Types [sys].[varchar](200) = NULL
	,@Visible [sys].[bit] = null
)
AS
BEGIN
	SELECT	E.[Code], E.[Name], E.[Type], E.[Visible], C.[Value] AS [ConfigurationValue]
	FROM	[dbo].[NotificationEvent] E WITH (NOLOCK)
			LEFT OUTER JOIN [dbo].[ConfigurationTranslated] C WITH (NOLOCK) ON E.[IdConfiguration] = C.[Id]
	WHERE	(@Types IS NULL OR [dbo].[CheckValueInList](E.[Type], @Types) > 0)
			AND (@Visible IS NULL OR E.[Visible] = @Visible)
END
