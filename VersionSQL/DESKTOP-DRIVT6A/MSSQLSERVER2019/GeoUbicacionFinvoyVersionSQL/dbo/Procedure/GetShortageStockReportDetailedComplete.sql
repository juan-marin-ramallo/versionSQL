/****** Object:  Procedure [dbo].[GetShortageStockReportDetailedComplete]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 04/08/2016
-- Description:	SP para obtener el reporte de faltantes, en base al inventario teórico
-- =============================================
CREATE PROCEDURE [dbo].[GetShortageStockReportDetailedComplete]
(
	 @DateFrom [sys].[datetime]
	,@DateTo [sys].[datetime]
	,@IdProduct [sys].[varchar](max) = NULL
	,@ProductCategoriesId [sys].[varchar](max) = NULL
	,@IdPointOfInterest [sys].[varchar](max) = NULL
	,@IdPersonOfInterest [sys].[varchar](max) = NULL
	,@IdShortageType [sys].[varchar](max) = NULL
	,@IdCompany [sys].[varchar](max) = NULL
	,@IdProductBrand [sys].[varchar](max) = NULL
	,@IdUser [sys].INT = NULL
)
AS
BEGIN

	SELECT		PM.[Id], PM.[Date] AS ReportDate,
				PM.[IdPointOfInterest] AS PointOfInterestId, POI.[Name] AS PointOfInterestName, POI.[Identifier] AS PointOfInterestIdentifier,
				PM.[IdPersonOfInterest] AS PersonOfInterestId, S.[Name] AS PersonOfInterestName, S.[LastName] AS PersonOfInterestLastName,
				PM.[MissingConfirmation], PMRT.[Name] AS ProductMissingReportTypeName,
				P.[Id] AS ProductId, P.[Name] AS ProductName, P.[Identifier] AS ProductIdentifier, P.[BarCode] AS ProductBarCode
				,P.[Indispensable] AS ProductIndispensable
				,PC.[Id] AS ProductCategoryId, PC.[Name] AS ProductCategoryName
				,PB.[Id] AS BrandId, PB.[Identifier] AS BrandIdentifier, PB.[Name] AS BrandName
				,C.[Id] AS CompanyId, C.[Identifier] AS CompanyIdentifier, C.[Name] AS CompanyName, 
				P.[MinSalesQuantity] AS ProductMinSalesQuantity, P.[MinUnitsPackage] AS ProductMinUnitsPackage, 
				P.[MaxSalesQuantity] AS ProductMaxSalesQuantity, P.[InStock] AS ProductInStock, 
				P.[Column_1] AS ProductColumn_1, P.[Column_2] AS ProductColumn_2,P.[Column_3] AS ProductColumn_3,P.[Column_4] AS ProductColumn_4,
				P.[Column_5]  AS ProductColumn_5,P.[Column_6] AS ProductColumn_6,P.[Column_7] AS ProductColumn_7,P.[Column_8] AS ProductColumn_8,
				P.[Column_9] AS ProductColumn_9, P.[Column_10] AS ProductColumn_10, P.[Column_11] AS ProductColumn_11,P.[Column_12] AS ProductColumn_12,
				P.[Column_13] AS ProductColumn_13, P.[Column_14] AS ProductColumn_14,P.[Column_15] AS ProductColumn_15,P.[Column_16] AS ProductColumn_16,
				P.[Column_17] AS ProductColumn_17,P.[Column_18] AS ProductColumn_18, P.[Column_19] AS ProductColumn_19,P.[Column_20] AS ProductColumn_20,
				P.[Column_21] AS ProductColumn_21,P.[Column_22] AS ProductColumn_22,P.[Column_23] AS ProductColumn_23,P.[Column_24] AS ProductColumn_24,
				P.[Column_25]  AS ProductColumn_25


	FROM		[dbo].[ProductMissingPointOfInterest] PM WITH (NOLOCK)
				INNER JOIN	[dbo].[PointOfInterest] POI WITH (NOLOCK) ON POI.[Id] = PM.[IdPointOfInterest]
				INNER JOIN	[dbo].[PersonOfInterest] S WITH (NOLOCK) ON S.[Id] = PM.[IdPersonOfInterest]
				LEFT JOIN	[dbo].[ProductMissingReportType] PMRT WITH (NOLOCK) ON PMRT.[Id] = PM.[IdProductMissingType]
				LEFT JOIN [dbo].[ProductMissingReport] PMR WITH(NOLOCK) ON PM.MissingConfirmation = 1 AND PM.Id = PMR.IdMissingProductPoi
				LEFT JOIN [dbo].[Product] P WITH(NOLOCK) ON P.[Id] = PMR.[IdProduct]
				LEFT JOIN [dbo].[ProductBrand] PB WITH(NOLOCK) ON P.IdProductBrand = PB.Id
				LEFT JOIN [dbo].[Company] C WITH(NOLOCK) ON PB.IdCompany = C.Id
				LEFT JOIN [dbo].[ProductCategoryList] PCL WITH(NOLOCK) ON PCL.[IdProduct] = P.[Id]
				LEFT JOIN [dbo].[ProductCategory] PC WITH(NOLOCK) ON PCL.[IdProductCategory] = PC.[Id]

	WHERE		PM.[Deleted] = 0 AND PM.[Date] >= DATEADD(MINUTE, -1, @DateFrom) AND PM.[Date] <= DATEADD(MINUTE, 1, @DateTo) AND PM.[Deleted] = 0 AND
				((@IdPointOfInterest IS NULL) OR (dbo.CheckValueInList(POI.[Id], @IdPointOfInterest) = 1)) AND
				((@IdPersonOfInterest IS NULL) OR (dbo.CheckValueInList(S.[Id], @IdPersonOfInterest) = 1)) AND
				((@IdShortageType IS NULL) OR (dbo.CheckValueInList(PM.[IdProductMissingType], @IdShortageType) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(POI.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(POI.[IdDepartment], @IdUser) = 1))
				AND ((@IdProduct IS NULL) OR dbo.CheckValueInList (P.[Id], @IdProduct) = 1) 
				AND ((@ProductCategoriesId IS NULL) OR (dbo.CheckValueInList (PC.[Id], @ProductCategoriesId) = 1)) 
				AND (@IdProductBrand IS NULL OR dbo.CheckValueInList(IIF(PB.[Id] IS NULL, 0, PB.[Id]), @IdProductBrand) = 1)
				AND (@IdCompany IS NULL OR dbo.CheckValueInList(IIF(C.[Id] IS NULL, 0, C.[Id]), @IdCompany) = 1)
				AND ((@IdUser IS NULL) OR (dbo.CheckUserInProductCompanies(P.[IdProductBrand], @IdUser) = 1)) 
				AND ((PM.[MissingConfirmation] = 0 AND @IdProduct IS NULL AND @ProductCategoriesId IS NULL AND @IdCompany IS NULL AND @IdProductBrand IS NULL) 
					OR P.Id IS NOT NULL)
	ORDER BY	PM.[Date] DESC, P.[Name] ASC
END
