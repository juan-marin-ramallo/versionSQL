/****** Object:  TableFunction [dbo].[GetShareOfShelfReport]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================  
-- Author:  Federico Sobral  
-- Create date: 27/03/2019  
-- Description: <Description,,>  
-- =============================================  
CREATE FUNCTION [dbo].[GetShareOfShelfReport]  
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
)  
RETURNS @t TABLE ([Id] [sys].[INT], [Date] [sys].DATETIME, [IsManual] [sys].[bit], [GrandTotal] [sys].[DECIMAL](18,2), [ValidationImage] [sys].[varchar](512),
 [PointOfInterestId] [sys].[int], PointOfInterestName [sys].[varchar](100),[PointOfInterestIdentifier] [sys].[varchar](50), [PointOfInterestDepartment] [sys].[INT], [PointOfInterestDepartmentName] [sys].[varchar](50), [PointOfInterestAddress] [sys].[varchar](250), [PointOfInterestContactName] [sys].[varchar](50), [PointOfInterestContactPhoneNumber] [sys].[varchar](50),  
 [HierarchyLevel1Id] [sys].[int], [HierarchyLevel2Id] [sys].[int], [HierarchyLevel1Name] [sys].[varchar](100), [HierarchyLevel2Name] [sys].[varchar](100), [HierarchyLevel1SapId] [sys].[VARCHAR](100), [HierarchyLevel2SapId] [sys].[VARCHAR](100),  
 [PersonOfInterestId] [sys].[int], [PersonOfInterestName] [sys].[varchar](50), [PersonOfInterestLastName] [sys].[varchar](50), [PersonOfInterestIdentifier] [sys].[varchar](20), [PersonOfInterestMobilePhoneNumber] [sys].[varchar](20), [PersonOfInterestMobileIMEI] [sys].[varchar](40),  
 [ProductId] [sys].[int], [ProductName] [sys].[varchar](100), [ProductBarCode] [sys].[varchar](100), [ProductIdentifier] [sys].[varchar](50), [ProductIndispensable] [sys].[bit],  
 [BrandId] [sys].[int], [BrandName] [sys].[varchar](50), [BrandIdentifier] [sys].[varchar](50),  
 [CompanyId] [sys].[int], [CompanyName] [sys].[varchar](50), [CompanyIdentifier] [sys].[varchar](50), [CompanyIsMain] [sys].[BIT],  
 [ItemId] [sys].[int], [Total] [sys].[DECIMAL](10,2), [ProductMinSalesQuantity] [sys].[int], [ProductMinUnitsPackage] [sys].[int],  
 [ProductMaxSalesQuantity] [sys].[int], [ProductInStock] [sys].[BIT], ProductColumn_1 varchar(100), ProductColumn_2 varchar(100),   
 ProductColumn_3 varchar(100), ProductColumn_4 varchar(100), ProductColumn_5 varchar(100), ProductColumn_6 varchar(100), ProductColumn_7 varchar(100),   
 ProductColumn_8 varchar(100), ProductColumn_9 varchar(100), ProductColumn_10 varchar(100), ProductColumn_11 varchar(100), ProductColumn_12 varchar(100),   
 ProductColumn_13 varchar(100), ProductColumn_14 varchar(100), ProductColumn_15 varchar(100), ProductColumn_16 varchar(100), ProductColumn_17 varchar(100),   
 ProductColumn_18 varchar(100), ProductColumn_19 varchar(100), ProductColumn_20 varchar(100), ProductColumn_21 varchar(100),   
 ProductColumn_22 varchar(100), ProductColumn_23 varchar(100), ProductColumn_24 varchar(100), ProductColumn_25 varchar(100))  
AS  
BEGIN  
 IF @IdProductCategorySOS = 0
 BEGIN
  SET @IdProductCategorySOS = NULL;
 END

 INSERT INTO @t   
 SELECT   SOS.[Id], SOS.[Date], SOS.[IsManual], SOS.[GrandTotal], SOS.[ValidationImage]
    ,SOS.[IdPointOfInterest] AS PointOfInterestId, POI.[Name] AS PointOfInterestName, POI.[Identifier] AS PointOfInterestIdentifier, POI.IdDepartment AS [PointOfInterestDepartment], D.[Name] AS [PointOfInterestDepartmentName], POI.[Address] AS [PointOfInterestAddress]
	, POI.ContactName AS [PointOfInterestContactName], POI.ContactPhoneNumber AS [PointOfInterestContactPhoneNumber]  
    , POI.[GrandfatherId] AS HierarchyLevel1Id, POI.[FatherId] AS HierarchyLevel2Id, PHL1.[Name] AS HierarchyLevel1Name, PHL2.[Name] AS HierarchyLevel2Name, PHL1.SapId AS [HierarchyLevel1SapId], PHL2.SapId AS [HierarchyLevel2SapId]  
    ,SOS.[IdPersonOfInterest] AS PersonOfInterestId, S.[Name] AS PersonOfInterestName, S.[LastName] AS PersonOfInterestLastName, S.Identifier AS [PersonOfInterestIdentifier], S.MobilePhoneNumber AS [PersonOfInterestMobilePhoneNumber], S.MobileIMEI AS [PersonOfInterestMobileIMEI]  
    ,P.[Id] AS ProductId, P.[Name] AS ProductName, P.[BarCode] AS ProductBarCode, P.Identifier AS ProductIdentifier, P.[Indispensable] AS ProductIndispensable  
    ,B.[Id] AS BrandId, B.[Name] AS BrandName, B.[Identifier] AS BrandIdentifier  
    ,C.[Id] AS [CompanyId], C.[Name] AS CompanyName, C.[Identifier] AS CompanyIdentifier, C.[IsMain] AS CompanyIsMain  
    ,SI.[Id] AS ItemId, SI.[Total], P.[MinSalesQuantity] AS ProductMinSalesQuantity, P.[MinUnitsPackage] AS ProductMinUnitsPackage,   
    P.[MaxSalesQuantity] AS ProductMaxSalesQuantity, P.[InStock] AS ProductInStock,  
    P.[Column_1] AS ProductColumn_1, P.[Column_2] AS ProductColumn_2,P.[Column_3] AS ProductColumn_3,P.[Column_4] AS ProductColumn_4,  
    P.[Column_5]  AS ProductColumn_5,P.[Column_6] AS ProductColumn_6,P.[Column_7] AS ProductColumn_7,P.[Column_8] AS ProductColumn_8,  
    P.[Column_9] AS ProductColumn_9, P.[Column_10] AS ProductColumn_10, P.[Column_11] AS ProductColumn_11,P.[Column_12] AS ProductColumn_12,  
    P.[Column_13] AS ProductColumn_13, P.[Column_14] AS ProductColumn_14,P.[Column_15] AS ProductColumn_15,P.[Column_16] AS ProductColumn_17,  
    P.[Column_17] AS ProductColumn_17,P.[Column_18] AS ProductColumn_18, P.[Column_19] AS ProductColumn_19,P.[Column_20] AS ProductColumn_20,  
    P.[Column_21] AS ProductColumn_21,P.[Column_22] AS ProductColumn_22,P.[Column_23] AS ProductColumn_23,P.[Column_24] AS ProductColumn_24,  
    P.[Column_25]  AS ProductColumn_25  
   
 FROM  [dbo].[ShareOfShelfReport] SOS WITH (NOLOCK)  
    INNER JOIN  [dbo].[ShareOfShelfProductCategory] SOSPC WITH(NOLOCK) ON SOS.Id = SOSPC.IdShareOfShelf  
    INNER JOIN [dbo].[PointOfInterest] POI WITH (NOLOCK) ON POI.[Id] = SOS.[IdPointOfInterest]  
    INNER JOIN [dbo].[PersonOfInterest] S WITH (NOLOCK) ON S.[Id] = SOS.[IdPersonOfInterest]  
    LEFT OUTER JOIN [dbo].[ShareOfShelfItem] SI WITH (NOLOCK) ON SOS.[Id] = SI.IdShareOfShelf  
    LEFT OUTER JOIN [dbo].[Product] P WITH (NOLOCK) ON P.[Id] = SI.IdProduct  
    LEFT OUTER JOIN [dbo].[ProductBrand] B WITH (NOLOCK) ON B.[Id] = SI.IdProductBrand OR B.[Id] = P.IdProductBrand  
    LEFT OUTER JOIN [dbo].[Company] C WITH (NOLOCK) ON C.[Id] = B.IdCompany  
    LEFT OUTER JOIN [dbo].[ProductCategoryList] PCL WITH (NOLOCK) ON P.Id = PCL.IdProduct  
    LEFT OUTER JOIN [dbo].[Department] D WITH (NOLOCK) ON D.Id =  POI.IdDepartment  
    LEFT OUTER JOIN [dbo].[POIHierarchyLevel1] PHL1 WITH (NOLOCK) ON POI.[GrandfatherId] = PHL1.[Id]   
    LEFT OUTER JOIN [dbo].[POIHierarchyLevel2] PHL2 WITH (NOLOCK) ON POI.[FatherId] = PHL2.[Id]  
   
 WHERE (SOS.ISManual = 1 OR SOS.IsValid = 1) AND SOS.[Date] >= @DateFrom AND SOS.[Date] <= @DateTo   
    AND ISNULL(@IdProductCategorySOS, SOSPC.IdProductCategory) = SOSPC.IdProductCategory  
    AND (@IdPointOfInterest IS NULL OR dbo.CheckValueInList(POI.[Id], @IdPointOfInterest) = 1)   
    AND (@IdPersonOfInterest IS NULL OR dbo.CheckValueInList(S.[Id], @IdPersonOfInterest) = 1)   
    AND (@IdUser IS NULL OR dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1)  
    AND (@IdUser IS NULL OR dbo.CheckUserInPointOfInterestZones(POI.[Id], @IdUser) = 1)  
    AND (@IdUser IS NULL OR dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1)  
    AND (@IdUser IS NULL OR dbo.CheckDepartmentInUserDepartments(POI.[IdDepartment], @IdUser) = 1)  
    AND (@IdProduct IS NULL OR dbo.CheckValueInList(P.[Id], @IdProduct) = 1)  
    AND (@IdProductBrand IS NULL OR dbo.CheckValueInList(IIF(B.[Id] IS NULL, 0, B.[Id]), @IdProductBrand) = 1)  
    AND (@IdCompany IS NULL OR dbo.CheckValueInList(IIF(C.[Id] IS NULL, 0, C.[Id]), @IdCompany) = 1)  
    AND (@IdProductCategories IS NULL OR dbo.CheckValueInList(PCL.IdProductCategory, @IdProductCategories) = 1)
	AND (@IsManual IS NULL OR SOS.[IsManual] = @IsManual)
    AND ((@IdUser IS NULL) OR (dbo.CheckUserInProductCompanies(P.[IdProductBrand], @IdUser) = 1) OR (dbo.CheckUserInProductCompanies(SI.[IdProductBrand], @IdUser) = 1))   
    -- Revisa que esten todas las categorias  
    --AND @CategoriesCount = (SELECT COUNT(1) FROM dbo.[ShareOfShelfProductCategory] PC WHERE PC.IdShareOfShelf = SOS.Id AND dbo.CheckValueInList(PC.[IdProductCategory], @IdProductCategoriesSOS) > 0)  
   
 GROUP BY SOS.[Id], SOS.[Date], SOS.[IsManual], SOS.[GrandTotal], SOS.[ValidationImage]
    ,SOS.[IdPointOfInterest], POI.[Name], POI.[Identifier], POI.IdDepartment, D.[Name], POI.[Address], POI.ContactName, POI.ContactPhoneNumber  
    ,POI.[GrandfatherId], POI.[FatherId] , PHL1.[Name] , PHL2.[Name], PHL1.SapId, PHL2.SapId    
    ,SOS.[IdPersonOfInterest], S.[Name], S.[LastName], S.Identifier, S.MobilePhoneNumber , S.MobileIMEI  
    ,P.[Id], P.[Name], P.[BarCode], P.Identifier, P.[Indispensable]  
    ,B.[Id], B.[Name], B.[Identifier]  
    ,C.[Id], C.[Name], C.[Identifier], C.[IsMain]  
    ,SI.[Id],SI.[Total], P.[MinSalesQuantity], P.[MinUnitsPackage] , P.[MaxSalesQuantity], P.[InStock],  
    P.[Column_1] , P.[Column_2] ,P.[Column_3],P.[Column_4] ,  
    P.[Column_5] ,P.[Column_6] ,P.[Column_7],P.[Column_8] ,  
    P.[Column_9] , P.[Column_10] , P.[Column_11],P.[Column_12] ,  
    P.[Column_13] , P.[Column_14] ,P.[Column_15],P.[Column_16] ,  
    P.[Column_17],P.[Column_18] , P.[Column_19],P.[Column_20] ,  
    P.[Column_21] ,P.[Column_22] ,P.[Column_23] ,P.[Column_24],  
    P.[Column_25]    
   
 ORDER BY SOS.[Date] DESC, SOS.[Id] DESC, SI.[Id] ASC  
 RETURN   
  
END
