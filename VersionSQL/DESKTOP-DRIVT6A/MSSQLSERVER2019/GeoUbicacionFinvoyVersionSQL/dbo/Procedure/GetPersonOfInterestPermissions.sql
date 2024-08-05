/****** Object:  Procedure [dbo].[GetPersonOfInterestPermissions]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 20/04/2015
-- Description:	SP para sincronizar los Productos
-- =============================================
CREATE PROCEDURE [dbo].[GetPersonOfInterestPermissions]
(
	 @IdPersonOfInterest [int]
)
AS
BEGIN
	SELECT P.[Id], P.[Description]
	FROM [dbo].[PersonOfInterestPermissionTranslated] P WITH (NOLOCK)
			INNER JOIN [dbo].[PersonOfInterestTypePermission] T WITH (NOLOCK) on T.[IdPersonOfInterestPermission] = P.[Id]
			INNER JOIN [dbo].[PersonOfInterest] S WITH (NOLOCK) on S.[Type] = T.[CodePersonOfInterestType]
	WHERE S.[Id] = @IdPersonOfInterest AND P.[Enabled] = 1
	GROUP BY P.[Id], P.[Description]
	ORDER BY P.[Id]
END
