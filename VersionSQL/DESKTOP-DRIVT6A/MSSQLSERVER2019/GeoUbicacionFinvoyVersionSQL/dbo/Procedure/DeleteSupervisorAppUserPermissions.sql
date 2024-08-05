/****** Object:  Procedure [dbo].[DeleteSupervisorAppUserPermissions]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[DeleteSupervisorAppUserPermissions]
	@IdUser int
AS
BEGIN
	
	DELETE FROM	[dbo].[UserSupervisorAppPermission]
	WHERE		IdUser = @IdUser

END
