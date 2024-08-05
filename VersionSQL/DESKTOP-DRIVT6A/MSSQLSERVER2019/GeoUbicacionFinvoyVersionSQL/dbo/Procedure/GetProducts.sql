/****** Object:  Procedure [dbo].[GetProducts]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetProducts]

	@Id int
	
AS
BEGIN

	SET NOCOUNT ON;

	SELECT	 p.Id
			,p.[Name]
			,p.Identifier
			,p.BarCode
			,P.[Indispensable]
			,p.IdProductBrand as ProductBrandId
			,b.[Name] AS [ProductBrandName],
			P.[MinSalesQuantity],P.[MinUnitsPackage], P.[MaxSalesQuantity], P.[InStock],
			P.[Column_1], P.[Column_2],P.[Column_3],P.[Column_4],P.[Column_5],P.[Column_6],P.[Column_7],P.[Column_8],P.[Column_9],
			P.[Column_10], P.[Column_11],P.[Column_12],P.[Column_13],P.[Column_14],P.[Column_15],P.[Column_16],P.[Column_17],
			P.[Column_18], P.[Column_19],P.[Column_20],P.[Column_21],P.[Column_22],P.[Column_23],P.[Column_24],
			P.[Column_25]

	FROM	dbo.Product p WITH (NOLOCK)
			LEFT OUTER JOIN dbo.ProductBrand b WITH (NOLOCK) ON  p.IdProductBrand = b.Id
	WHERE ((@Id IS NULL) OR p.Id = @Id) AND p.Deleted = 0

END
