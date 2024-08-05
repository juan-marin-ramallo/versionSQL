/****** Object:  Procedure [dbo].[GetPersonOfInterestPermissionsForScheduleProfile]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 24/10/2018
-- Description:	SP para obtener los permisos para personas de interés QUE SE PUEDEN AGENDAR EN CRONOGRAMA DE ACTIVIDADES

-- =============================================
CREATE PROCEDURE [dbo].[GetPersonOfInterestPermissionsForScheduleProfile]
@IdScheduleProfile [sys].[int] = NULL
AS
BEGIN

	IF @IdScheduleProfile IS NULL
	BEGIN
		SELECT	P.[Id], P.[Description], P.[PermissionSet], 0 AS LimitOnlyOnce
		FROM	[dbo].[PersonOfInterestPermissionTranslated] P with(nolock)
		WHERE	P.[Enabled] = 1 AND [ScheduleProfileSelection] = 1
		ORDER BY P.[Order], P.[Id]
	END
	ELSE
	BEGIN
		SELECT	P.[Id], P.[Description], P.[PermissionSet], SPP.[LimitOnlyOnce]
		FROM	[dbo].[PersonOfInterestPermissionTranslated] P with(nolock)
				INNER JOIN [dbo].[ScheduleProfilePermission] SPP with(nolock) ON SPP.[IdPersonOfInterestPermission] = P.[Id]		
		WHERE	P.[Enabled] = 1 AND [ScheduleProfileSelection] = 1 AND SPP.[IdScheduleProfile] = @IdScheduleProfile
		ORDER BY P.[Order], P.[Id]
	END
END
