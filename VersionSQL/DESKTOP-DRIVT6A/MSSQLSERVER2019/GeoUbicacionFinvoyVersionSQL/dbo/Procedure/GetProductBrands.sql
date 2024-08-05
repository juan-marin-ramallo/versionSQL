/****** Object:  Procedure [dbo].[GetProductBrands]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		FS
-- Create date: 18/03/19
-- Description:	SP para obtener marcas
-- =============================================
CREATE PROCEDURE [dbo].[GetProductBrands]
	 @IncludeDeleted [sys].[BIT] = 0
	,@IdCompany [sys].[INT] = NULL
    ,@IdProductBrand [sys].[int] = NULL	
	,@IdCompanies [sys].VARCHAR(max) = null
	,@IdProductBrands [sys].VARCHAR(max) = null
	,@IdUser [sys].INT = NULL
AS
BEGIN

	SELECT b.[Id]
		  ,b.[IdCompany]
		  ,b.[Name]
		  ,b.[Identifier]
		  ,b.[Description]
		  ,b.[ImageName]
		  ,b.[IsSubBrand]
		  ,b.[IdFather]
		  ,b.[Deleted]
		  ,c.[Id] AS CompanyId
		  ,c.[Identifier] AS CompanyIdentifier
		  ,c.[Name] AS CompanyName
		  ,c.[IsMain] AS CompanyIsMain
		  ,b2.[Id] AS FatherId
		  ,b2.[Identifier]  AS FatherIdentifier
		  ,b2.[Name] AS FatherName
		  ,pc.[Id] as ProductCategoryId
		  ,pc.[Name] as ProductCategoryName
	FROM [dbo].[ProductBrand] b
		INNER JOIN [dbo].[Company] c ON b.[IdCompany] = c.[Id]
		LEFT OUTER JOIN [dbo].[ProductBrand] b2 ON b.[IdFather] = b2.[Id]
		LEFT OUTER JOIN [dbo].[ProductBrandProductCategory] pbc ON pbc.[IdProductBrand] = b.[Id]
		LEFT OUTER JOIN [dbo].[ProductCategory] pc ON pc.[Id] = pbc.[IdProductCategory]
	WHERE (b.[Deleted] = 0 OR @IncludeDeleted = 1) AND (pc.Id IS NULL OR pc.Deleted = 0)
		AND (@IdCompany IS NULL OR @IdCompany = b.[IdCompany])
		AND (@IdProductBrand IS NULL OR @IdProductBrand = b.[Id])
		AND (@IdCompanies IS NULL OR [dbo].CheckValueInList(b.[IdCompany], @IdCompanies) > 0)
		AND (@IdProductBrands IS NULL OR [dbo].CheckValueInList(b.[Id], @IdProductBrands) > 0)
		AND ((@IdUser IS NULL) OR (dbo.CheckUserInFormCompanies(C.[Id], @IdUser) = 1))
	GROUP BY  b.[Id]
		  ,b.[IdCompany]
		  ,b.[Name]
		  ,b.[Identifier]
		  ,b.[Description]
		  ,b.[ImageName]
		  ,b.[IsSubBrand]
		  ,b.[IdFather]
		  ,b.[Deleted]
		  ,c.[Id]
		  ,c.[Identifier]
		  ,c.[Name]
		  ,c.[IsMain]
		  ,b2.[Id],b2.[Identifier],b2.[Name]
		  ,pc.[Id],pc.[Name]
	ORDER BY IIF(b.[IdFather] IS NULL, b.[Name], b2.[Name]) ASC, IIF(b.[IdFather] IS NULL, b.[IdFather], b2.[Id]) ASC
	, b.[IsSubbrand] ASC, b.[Name] asc, b.[Id] asc, pc.Name, pc.Id
    
END
