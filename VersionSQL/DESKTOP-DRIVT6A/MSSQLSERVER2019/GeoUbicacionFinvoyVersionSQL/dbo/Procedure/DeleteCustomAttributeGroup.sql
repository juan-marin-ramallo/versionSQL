/****** Object:  Procedure [dbo].[DeleteCustomAttributeGroup]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 25/03/2018
-- Description:	Borrado de grupo de atributos personalizados para punto
-- =============================================
CREATE PROCEDURE [dbo].[DeleteCustomAttributeGroup]
	@Id [sys].[int]
AS
BEGIN

	UPDATE [dbo].[CustomAttributeGroup]
	SET [Deleted] = 1
	WHERE [Id] = @Id

	DELETE FROM [dbo].[CustomAttributeGroupPersonType]
	WHERE		[IdCustomAttributeGroup] = @Id

END
