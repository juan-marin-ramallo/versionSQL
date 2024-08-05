/****** Object:  Procedure [dbo].[DeleteProductBrand]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		FS
-- Create date: 18/03/19
-- Description:	SP para eliminar una marcas
-- =============================================
CREATE PROCEDURE [dbo].[DeleteProductBrand]
	 @Id [sys].[int]
AS
BEGIN

	UPDATE [dbo].[ProductBrand]
	SET  [Deleted] = 1
	WHERE [Id] = @Id OR [IdFather] = @Id

	--Actualizo productos que tengan asociada la marca. No tiene sentido que se tengan productos asociados a marcas eliminadas porque genera confusiòn en los reportes
	UPDATE P
	SET  P.[IdProductBrand] = NULL
	FROM [dbo].[Product] P
		INNER JOIN  [dbo].[ProductBrand] PB ON P.IdProductBrand = PB.[Id]
	WHERE PB.[Id] = @Id OR PB.[IdFather] = @Id

END
