/****** Object:  Procedure [dbo].[GetShareOfShelfReportDetailed]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================  
-- Author:  Federico Sobral  
-- Create date: 27/03/2019  
-- Description: SP para obtener el reporte Share of shelf  
-- =============================================  
CREATE PROCEDURE [dbo].[GetShareOfShelfReportDetailed]  
(  
	@DateFrom [sys].[datetime]  
	,@DateTo [sys].[datetime]  
	,@IdProductCategorySOS [sys].[int]  
	,@IdProduct [sys].[varchar](max) = NULL  
	,@IdProductCategories [sys].[varchar](max) = NULL  
	,@IdProductBrand [sys].[varchar](max) = NULL  
	,@IdCompany [sys].[varchar](max) = NULL   
	,@IdPointOfInterest [sys].[varchar](max) = NULL  
	,@IdPersonOfInterest [sys].[varchar](max) = NULL
	,@IsManual [sys].[bit] = NULL
	,@IdUser [sys].INT = NULL  
) AS  
BEGIN  
	SELECT SOS.[Id], SOS.[Date], SOS.[IsManual]
	,SOS.PointOfInterestId, SOS.PointOfInterestName, SOS.PointOfInterestIdentifier, SOS.[PointOfInterestDepartment], SOS.[PointOfInterestDepartmentName], SOS.[PointOfInterestAddress], SOS.[PointOfInterestContactName], SOS.[PointOfInterestContactPhoneNumber]  
	,SOS.[HierarchyLevel1Id], SOS.[HierarchyLevel2Id], SOS.[HierarchyLevel1Name], SOS.[HierarchyLevel2Name], SOS.[HierarchyLevel1SapId], SOS.[HierarchyLevel2SapId]  
	,SOS.PersonOfInterestId, SOS.PersonOfInterestName, SOS.PersonOfInterestLastName, SOS.[PersonOfInterestIdentifier], SOS.[PersonOfInterestMobilePhoneNumber], SOS.[PersonOfInterestMobileIMEI]  
	,SOS.ProductId, SOS.ProductName, SOS.ProductBarCode, SOS.ProductIdentifier, SOS.ProductIndispensable  
	,SOS.BrandId, SOS.BrandName, SOS.BrandIdentifier  
	,SOS.CompanyId, SOS.CompanyName, SOS.CompanyIdentifier, SOS.[CompanyIsMain]  
	,SOS.ItemId, SOS.[Total], SOS.ProductMinSalesQuantity, SOS.ProductMinUnitsPackage, SOS.ProductMaxSalesQuantity, SOS.ProductInStock,  
	SOS.ProductColumn_1, SOS.ProductColumn_2 , SOS.ProductColumn_3, SOS.ProductColumn_4 , SOS.ProductColumn_5, SOS.ProductColumn_6,   
	SOS.ProductColumn_7, SOS.ProductColumn_8 , SOS.ProductColumn_9 , SOS.ProductColumn_10 , SOS.ProductColumn_11,   
	SOS.ProductColumn_12, SOS.ProductColumn_13 , SOS.ProductColumn_14 , SOS.ProductColumn_15, SOS.ProductColumn_16 ,   
	SOS.ProductColumn_17 , SOS.ProductColumn_18 , SOS.ProductColumn_19, SOS.ProductColumn_20 , SOS.ProductColumn_21 ,   
	SOS.ProductColumn_22 , SOS.ProductColumn_23 , SOS.ProductColumn_24 , SOS.ProductColumn_25  
	,PC.[Id] AS ProductCategoryId, PC.[Name] AS ProductCategoryName  
	,CA.[Id] AS CustomAttributeId, CA.[Name] AS CustomAttributeName, CA.[IdValueType] AS CustomAttributeValueType, CAV.[Value] AS CustomAttributeValue  
   
	FROM  dbo.[GetShareOfShelfReport](@DateFrom,@DateTo,@IdProductCategorySOS,@IdProduct,@IdProductCategories,@IdProductBrand,@IdCompany,@IdPointOfInterest,@IdPersonOfInterest,@IsManual,@IdUser) AS SOS  
	LEFT JOIN [dbo].[ProductCategoryList] PCL WITH(NOLOCK) ON PCL.[IdProduct] = SOS.ProductId  
	LEFT JOIN [dbo].[ProductCategory] PC WITH(NOLOCK) ON PC.[Id] = PCL.[IdProductCategory]  
	LEFT JOIN [dbo].[CustomAttributeValue] CAV WITH (NOLOCK) ON CAV.[IdPointOfInterest] = SOS.[PointOfInterestId]  
	LEFT JOIN [dbo].[CustomAttribute] CA WITH (NOLOCK) ON CAV.[IdCustomAttribute] = CA.[Id] AND CA.[Deleted] = 0  
  
	ORDER BY SOS.[Date] ASC, SOS.[Id] DESC, SOS.[CompanyIsMain] DESC, SOS.CompanyName ASC, SOS.BrandName ASC, SOS.ProductName ASC, SOS.Total DESC--, PCL.Id ASC  
END;
