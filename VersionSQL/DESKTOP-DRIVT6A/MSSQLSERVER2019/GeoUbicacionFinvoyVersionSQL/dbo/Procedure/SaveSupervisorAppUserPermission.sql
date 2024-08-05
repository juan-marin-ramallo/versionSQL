/****** Object:  Procedure [dbo].[SaveSupervisorAppUserPermission]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SaveSupervisorAppUserPermission]
	 @IdUser int
	,@IdPermission int
AS
BEGIN
	
	INSERT INTO [dbo].[UserSupervisorAppPermission] ([IdUser], [IdSupervisorAppPermission])
	VALUES (@IdUser, @IdPermission)

END
