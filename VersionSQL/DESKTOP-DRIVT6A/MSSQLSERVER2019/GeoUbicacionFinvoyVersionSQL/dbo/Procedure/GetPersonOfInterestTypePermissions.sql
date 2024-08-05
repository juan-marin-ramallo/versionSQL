/****** Object:  Procedure [dbo].[GetPersonOfInterestTypePermissions]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 20/04/2015
-- Description:	SP para sincronizar los Productos
-- =============================================
CREATE PROCEDURE [dbo].[GetPersonOfInterestTypePermissions]
(
	 @Code [char](1)
)
AS
BEGIN
	SELECT P.[Id], P.[Description]
	FROM [dbo].[PersonOfInterestPermissionTranslated] P WITH (NOLOCK)
			INNER JOIN [dbo].[PersonOfInterestTypePermission] T WITH (NOLOCK) on T.[IdPersonOfInterestPermission] = P.[Id]
	WHERE T.[CodePersonOfInterestType] = @Code AND P.[Enabled] = 1
	GROUP BY P.[Id], P.[Description]
	ORDER BY P.[Id]
END
