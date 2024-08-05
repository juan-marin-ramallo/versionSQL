/****** Object:  Procedure [dbo].[DeleteCustomAttributeGroupForProfile]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 25/03/2018
-- Description:	Borrado de grupo para perfil
-- =============================================
CREATE PROCEDURE [dbo].[DeleteCustomAttributeGroupForProfile]
	@IdGroup [sys].[int],
	@CodeProfile [sys].[char]
AS
BEGIN

	DELETE FROM [dbo].[CustomAttributeGroupPersonType]
	WHERE		[IdCustomAttributeGroup] = @IdGroup AND [PersonOfInterestType] = @CodeProfile

END
