/****** Object:  Procedure [dbo].[DeleteProductCategory]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Matias Corso
-- Create date: 12/10/2016
-- Description:	SP para eliminar una categoría de producto
-- =============================================
CREATE PROCEDURE [dbo].[DeleteProductCategory]
(
	 @Id [sys].[int]
	 , @DeleteAsignation [sys].[bit]
)
AS
BEGIN
	DECLARE @Now [sys].[datetime]
    SET @Now = GETUTCDATE()

	UPDATE	[dbo].[ProductCategory]		
	SET		[EditedDate] = @Now,
			[Deleted] = 1 		
	WHERE	 [Id] = @Id

	--Cambio para que actuaice el cambio de categoria como una diferencia de productos.
	UPDATE	[dbo].[ProductPointOfInterestChangeLog] 
	SET		[LastUpdatedDate] = @Now

	IF @DeleteAsignation = 1
	BEGIN
		DELETE FROM [dbo].[ProductCategoryList] WHERE [IdProductCategory] = @Id 
		DELETE FROM [dbo].[ProductBrandProductCategory] WHERE [IdProductCategory] = @Id 
	END
END
