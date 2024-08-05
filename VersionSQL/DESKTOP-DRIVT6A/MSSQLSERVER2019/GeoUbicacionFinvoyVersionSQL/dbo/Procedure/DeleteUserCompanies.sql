/****** Object:  Procedure [dbo].[DeleteUserCompanies]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		gl
-- Create date: 23/07/2019
-- Description:	SP para eliminar las compañias de un usuario
-- =============================================
create PROCEDURE [dbo].[DeleteUserCompanies]
(
	 @IdUser [sys].[int]
)
AS
BEGIN
	DELETE FROM	[dbo].[UserCompany]
	WHERE		IdUser = @IdUser
END
