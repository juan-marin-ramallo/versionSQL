/****** Object:  Procedure [dbo].[GetProductsByFilters]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Daniel Artigas
-- Create date: 15/04/2021
-- Description:	SP para obtener los productos infaltables
-- =============================================
CREATE PROCEDURE [dbo].[GetProductsByFilters]
(
  @IdUser [sys].[int] = NULL,
  @IdCompany [sys].[int] = NULL,
  @IdBrand [sys].[int] = NULL,
  @IdProductCategory [sys].[int] = NULL
)
AS
BEGIN
	SET NOCOUNT ON;

	IF (@IdCompany IS NULL AND @IdBrand IS NULL AND @IdProductCategory IS NULL)
	BEGIN
		SET @IdCompany = 0
		SET @IdBrand = 0
		SET @IdProductCategory = 0
	END

	SELECT		P.[Id], P.[Name], P.[Identifier]
	FROM		[dbo].[Product] P WITH (NOLOCK)
				LEFT JOIN [ProductBrand] PB ON PB.Id = P.IdProductBrand
				LEFT JOIN [Company] C ON PB.IdCompany = C.Id
				LEFT JOIN [ProductCategoryList] PCL ON PCL.IdProduct = P.Id
				LEFT JOIN [ProductCategory] PC ON PC.Id = PCL.IdProductCategory
	WHERE		--P.[Deleted] = 0 --AND P.[Indispensable] = 1
				(C.Id = @IdCompany OR @IdCompany IS NULL)
				AND (PB.Id = @IdBrand OR @IdBrand  IS NULL)
				AND (PC.Id = @IdProductCategory or @IdProductCategory IS NULL)
	ORDER BY	P.[Id]
END
