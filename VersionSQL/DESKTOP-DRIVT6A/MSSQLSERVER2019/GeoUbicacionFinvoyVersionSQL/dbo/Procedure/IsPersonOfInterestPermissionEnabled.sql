/****** Object:  Procedure [dbo].[IsPersonOfInterestPermissionEnabled]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================  
-- Author: Cbarbarini
-- Create date: 09/12/2021
-- Description: SP para chequear si un permiso esta habilitado
-- =============================================  
CREATE PROCEDURE [dbo].[IsPersonOfInterestPermissionEnabled]
	@PersonOfInterestPermissionId [sys].[INT]
AS
BEGIN
	SELECT Enabled
	FROM PersonOfInterestPermission (NOLOCK)
	WHERE Id = @PersonOfInterestPermissionId
END
