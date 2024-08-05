/****** Object:  Procedure [dbo].[SaveUserZone]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Leo Repetto
-- Create date: 20/11/2012
-- Description:	SP para guardar departamentos de un usuario
-- =============================================
CREATE PROCEDURE [dbo].[SaveUserZone]
(
	 @IdUser [sys].[int]
	,@IdZone [sys].[varchar](200)
)
AS
BEGIN
	INSERT INTO [dbo].[UserZone](IdUser, IdZone)
	(SELECT	@IdUser, D.[Id]
	FROM	[dbo].[ZoneTranslated] D WITH (NOLOCK)
	WHERE	dbo.CheckValueInList(D.[Id], @IdZone) = 1)
END
