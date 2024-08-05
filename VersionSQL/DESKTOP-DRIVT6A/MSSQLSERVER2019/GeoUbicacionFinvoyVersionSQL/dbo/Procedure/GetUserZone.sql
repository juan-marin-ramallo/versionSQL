/****** Object:  Procedure [dbo].[GetUserZone]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Leo Repetto
-- Create date: 20/11/2012
-- Description:	SP para obtener las zonas de un usuario dado
-- =============================================
CREATE PROCEDURE [dbo].[GetUserZone]
(
	@IdUser [sys].[int]
)
AS
BEGIN
	SELECT		D.[Id], D.[Description]
	FROM		[dbo].[ZoneTranslated] D WITH (NOLOCK)
				INNER JOIN [dbo].[UserZone] UD WITH (NOLOCK) ON UD.[IdZone] = D.[Id]
	WHERE		UD.[IdUser] = @IdUser
END
