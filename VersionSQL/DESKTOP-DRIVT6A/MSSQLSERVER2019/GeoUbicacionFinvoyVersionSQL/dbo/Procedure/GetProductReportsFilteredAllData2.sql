/****** Object:  Procedure [dbo].[GetProductReportsFilteredAllData2]    Committed by VersionSQL https://www.versionsql.com ******/

-- ==============================================      
-- Modified by: JUAN MARIN    
-- Modified date: 02/01/2024    
-- Description:  GT-519: Se aplica un case para considerar el valor de un atributo personalizado sea multiple opcion
-- =============================================  
CREATE PROCEDURE [dbo].[GetProductReportsFilteredAllData2]  
 @DateFrom datetime,  
 @DateTo datetime,  
    @IdProduct varchar(max) = null,  
    @IdPersonOfInterest varchar(max)=null,  
    @IdPointOfInterest varchar(max)=null,  
 @ProductBarCodes [sys].[varchar](max) = NULL,  
    @ProductCategoriesId [sys].[varchar](max) = NULL  
 ,@IdCompany [sys].[varchar](max) = NULL  
 ,@IdProductBrand [sys].[varchar](max) = NULL,  
 @ConditionQuery varchar(max)=NULL,  
 @IdUser [sys].INT = NULL,  
 @FilteredDynamicAttributeIds varchar(100)=NULL  
AS   
BEGIN  
    SET NOCOUNT ON;  
   
 --SET @DateTo = DATEADD (ms, -1, DATEADD(dd, 1, @DateTo))  
    DECLARE @DateFromLocal datetime = @DateFrom  
 DECLARE @DateToLocal datetime = @DateTo  
 DECLARE @IdProductLocal varchar(max) = @IdProduct  
 DECLARE @IdPersonOfInterestLocal varchar(max) = @IdPersonOfInterest  
 DECLARE @IdPointOfInterestLocal varchar(max) = @IdPointOfInterest  
 DECLARE @ProductBarCodesLocal [sys].[varchar](max) = @ProductBarCodes  
 DECLARE @ProductCategoriesIdLocal [sys].[varchar](max) = @ProductCategoriesId  
    DECLARE @IdCompanyLocal [sys].[varchar](max) = @IdCompany  
    DECLARE @IdProductBrandLocal [sys].[varchar](max) = @IdProductBrand  
 DECLARE @ConditionQueryLocal varchar(max)=@ConditionQuery  
 DECLARE @IdUserLocal int = @IdUser  
  
 CREATE TABLE #TempResultProducts  
    (   
 ProductId int,  
  ProductIdentifier varchar(50),   
  ProductName varchar(100),  
  ProductBarCode varchar(100),  
  ProductCategoryId int,   
  ProductCategoryName varchar(50),  
  BrandId int,  
  BrandIdentifier varchar(50),   
  BrandName varchar(50),  
  CompanyId int,   
  CompanyIdentifier varchar(50),   
  CompanyName  varchar(50),  
  ProductIndispensable bit,  
  ProductMinSalesQuantity int,  
  ProductMinUnitsPackage int,  
  ProductMaxSalesQuantity int,  
  ProductInStock bit,  
  ProductColumn_1 varchar(100),   
  ProductColumn_2 varchar(100),   
  ProductColumn_3 varchar(100),   
  ProductColumn_4 varchar(100),   
  ProductColumn_5 varchar(100),   
  ProductColumn_6 varchar(100),   
  ProductColumn_7 varchar(100),   
  ProductColumn_8 varchar(100),   
  ProductColumn_9 varchar(100),   
  ProductColumn_10 varchar(100),   
  ProductColumn_11 varchar(100),   
  ProductColumn_12 varchar(100),   
  ProductColumn_13 varchar(100),   
  ProductColumn_14 varchar(100),   
  ProductColumn_15 varchar(100),   
  ProductColumn_16 varchar(100),   
  ProductColumn_17 varchar(100),   
  ProductColumn_18 varchar(100),   
  ProductColumn_19 varchar(100),   
  ProductColumn_20 varchar(100),   
  ProductColumn_21 varchar(100),   
  ProductColumn_22 varchar(100),   
  ProductColumn_23 varchar(100),   
  ProductColumn_24 varchar(100),   
  ProductColumn_25 varchar(100),   
  ProductCategoryListId int  
    );  
  
  
  
 INSERT INTO #TempResultProducts(ProductId, ProductIdentifier, ProductName ,ProductBarCode,ProductCategoryId , ProductCategoryName ,  
 BrandId,BrandIdentifier, BrandName ,CompanyId, CompanyIdentifier, CompanyName, ProductIndispensable, ProductMinSalesQuantity, ProductMinUnitsPackage,  
 ProductMaxSalesQuantity, ProductInStock, ProductColumn_1, ProductColumn_2 , ProductColumn_3, ProductColumn_4 , ProductColumn_5, ProductColumn_6,   
 ProductColumn_7, ProductColumn_8 , ProductColumn_9 , ProductColumn_10 , ProductColumn_11,   
 ProductColumn_12, ProductColumn_13 , ProductColumn_14 , ProductColumn_15, ProductColumn_16 ,   
 ProductColumn_17 , ProductColumn_18 , ProductColumn_19, ProductColumn_20 , ProductColumn_21 ,   
 ProductColumn_22 , ProductColumn_23 , ProductColumn_24 , ProductColumn_25, ProductCategoryListId)  
   
 SELECT  P.[Id], P.ProductIdentifier, P.ProductName,P.ProductBarCode,P.ProductCategoryId, P.ProductCategoryName,P.BrandId, P.BrandIdentifier, P.BrandName  
   ,P.CompanyId, P.CompanyIdentifier, P.CompanyName, P.ProductIndispensable, P.ProductMinSalesQuantity,  
   P.ProductMinUnitsPackage, P.ProductMaxSalesQuantity, P.ProductInStock, P.[Column_1], P.[Column_2],P.[Column_3],P.[Column_4],P.[Column_5],P.[Column_6],P.[Column_7],P.[Column_8],P.[Column_9],  
   P.[Column_10], P.[Column_11],P.[Column_12],P.[Column_13],P.[Column_14],P.[Column_15],P.[Column_16],P.[Column_17],  
   P.[Column_18], P.[Column_19],P.[Column_20],P.[Column_21],P.[Column_22],P.[Column_23],P.[Column_24],  
   P.[Column_25], P.ProductCategoryListId  
  
 FROM   [dbo].[ProductInfo] P WITH (NOLOCK)  
  
 WHERE  ((@IdProductLocal IS NULL) OR dbo.CheckValueInList (P.[Id], @IdProductLocal)=1) AND  
  ((@ProductBarCodesLocal IS NULL) OR (dbo.CheckVarcharInList(P.ProductBarCode, @ProductBarCodesLocal) = 1)) AND  
  ((@ProductCategoriesIdLocal IS NULL) OR (dbo.CheckValueInList(P.ProductCategoryId, @ProductCategoriesIdLocal) = 1))      
  AND (@IdProductBrandLocal IS NULL OR dbo.CheckValueInList(IIF(P.BrandId IS NULL, 0, P.BrandId), @IdProductBrandLocal) = 1)  
  AND (@IdCompanyLocal IS NULL OR dbo.CheckValueInList(IIF(P.CompanyId IS NULL, 0, P.CompanyId), @IdCompanyLocal) = 1)  
  AND ((@IdUserLocal IS NULL) OR (dbo.CheckUserInProductCompanies(P.BrandId, @IdUserLocal) = 1))  
  
   
 CREATE TABLE #TempResultProductReportDynamic  
    (   
  ProductReportId int,   
  ProductId int,   
  PersonOfInterestId int,   
  PointOfInterestId int,  
  ReportDateTime datetime,  
  TheoricalStock int,   
  TheoricalPrice decimal(18, 2),  
  [Dynamic] varchar(100)  
    );  
  
 INSERT INTO #TempResultProductReportDynamic(ProductReportId, ProductId,   
  PersonOfInterestId, PointOfInterestId,ReportDateTime,TheoricalStock, TheoricalPrice, [Dynamic])  
 SELECT  PR.[Id], PR.[IdProduct] as ProductId, PR.[IdPersonOfInterest] as PersonOfInterestId,   
   PR.[IdPointOfInterest] AS PointOfInterestId, PR.[ReportDateTime], PR.[TheoricalStock], PR.[TheoricalPrice], PR.[Dynamic]  
 FROM   [dbo].[ProductReportDynamic] PR WITH (NOLOCK)  
  
 WHERE  (pr.[ReportDateTime] BETWEEN @DateFromLocal AND @DateToLocal) AND  
   ((@IdPersonOfInterestLocal IS NULL) OR dbo.CheckValueInList (PR.[IdPersonOfinterest], @IdPersonOfInterestLocal) =1) AND  
   ((@IdPointOfInterestLocal IS NULL) OR dbo.CheckValueInList (PR.[IdPointOfInterest], @IdPointOfInterestLocal) =1) AND  
   ((@IdUserLocal IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(PR.[IdPersonOfinterest], @IdUserLocal) = 1)) AND  
   ((@IdUserLocal IS NULL) OR (dbo.CheckUserInPointOfInterestZones(PR.[IdPointOfInterest], @IdUserLocal) = 1))  
  
 CREATE TABLE #TempResultProductReport  
    (   
  ProductReportId int,   
  ProductId int,   
  PersonOfInterestId int,   
  PointOfInterestId int,  
  ReportDateTime datetime,  
  TheoricalStock int,   
  TheoricalPrice decimal(18, 2),  
  [Dynamic] varchar(100),  
  IdProductReportAttribute int,   
  ProductReportAttributeValue varchar(max),   
  IdProductReportAttributeValue int,  
  IdProductReportAttributeType int,   
  IdProductReportAttributeOption int,  
  ProductReportAttributeOption varchar(100),  
  ProductReportAttributeName varchar(250),   
  ProductReportAttributeImageUrl varchar(5000),  
  ProductReportAttributeImageName  varchar(100)  
    );  
  
 CREATE TABLE #TempResultPointOfInterest  
    (   
  PointOfInterestId int ,  
  PointOfInterestName varchar(100),   
  PointOfInterestIdentifier varchar (50),   
  PointOfInterestAddress varchar (250),  
  IdDepartment int,  
  DepartmentName  varchar (50),  
  POIHierarchyLevel1Id int,   
  POIHierarchyLevel1Name varchar (100),   
  POIHierarchyLevel1SapId  varchar (100),   
  POIHierarchyLevel2Id int,   
  POIHierarchyLevel2Name  varchar (100),   
  POIHierarchyLevel2SapId  varchar (100),  
  CustomAttributeName  varchar (100),   
  CustomAttributeId int,   
  CustomAttributeValueType int,  
  CustomAttributeValue  varchar(max),  
  PointOfInterestContactName varchar (50),  
  PointOfInterestContactPhoneNumber varchar (50)  
    );  
  
 CREATE TABLE #TempResultPersonOfInterest  
    (   
  PersonOfInterestId int ,  
  PersonOfInterestName varchar(50), PersonOfInterestLastName varchar(50), PersonOfInterestIdentifier varchar(20),  
  PersonOfInterestMobile varchar(20),PersonOfInterestIMEI varchar(40)  
    );  
  
 INSERT INTO #TempResultProductReport(ProductReportId, ProductId,       PersonOfInterestId, PointOfInterestId,ReportDateTime,TheoricalStock, TheoricalPrice, [Dynamic], IdProductReportAttribute , ProductReportAttributeValue,   
    IdProductReportAttributeValue,IdProductReportAttributeType, IdProductReportAttributeOption, ProductReportAttributeOption,ProductReportAttributeName,   
    ProductReportAttributeImageUrl, ProductReportAttributeImageName)  
   
 SELECT  PR.ProductReportId, PR.ProductId, PR.PersonOfInterestId,   
   PR.PointOfInterestId, PR.[ReportDateTime], PR.[TheoricalStock], PR.[TheoricalPrice], PR.[Dynamic],  
   --PRAV.[IdProductReportAttribute], PRAV.[Value] AS ProductReportAttributeValue, PRAV.[Id] AS IdProductReportAttributeValue,  
   PRAV.[IdProductReportAttribute], (CASE PRAT.[IdType] WHEN 7 THEN PRO.[Text] ELSE PRAV.[Value] END) AS ProductReportAttributeValue, PRAV.[Id] AS IdProductReportAttributeValue,  
   PRAT.[IdType] AS IdProductReportAttributeType,   
   PRAV.IdProductReportAttributeOption, PRO.[Text] AS ProductReportAttributeOption, PRAT.[Name] AS ProductReportAttributeName  
   , PRAV.[ImageUrl] AS ProductReportAttributeImageUrl,  
   PRAV.[ImageName] AS ProductReportAttributeImageName  
 FROM   #TempResultProductReportDynamic PR WITH (NOLOCK)  
   LEFT JOIN   [dbo].[ProductReportAttributeValue] PRAV WITH (NOLOCK) ON PRAV.[IdProductReport] = PR.ProductReportId  
   LEFT JOIN   [dbo].[ProductReportAttribute] PRAT WITH (NOLOCK) ON PRAT.[Id] = PRAV.[IdProductReportAttribute]  
   LEFT JOIN   [dbo].[ProductReportAttributeOption] PRO WITH (NOLOCK) ON PRO.[Id] = PRAV.[IdProductReportAttributeOption]  
  
 WHERE  (PRAV.[Id] IS NULL OR PRAT.[FullDeleted] = 0)  
  
   
 INSERT INTO #TempResultPointOfInterest(PointOfInterestId ,PointOfInterestName, PointOfInterestIdentifier, POI.PointOfInterestAddress ,IdDepartment,  
    DepartmentName ,POIHierarchyLevel1Id , POIHierarchyLevel1Name , POIHierarchyLevel1SapId , POIHierarchyLevel2Id , POIHierarchyLevel2Name  ,   
    POIHierarchyLevel2SapId  ,CustomAttributeName, CustomAttributeId , CustomAttributeValueType ,CustomAttributeValue,PointOfInterestContactName,  
   PointOfInterestContactPhoneNumber)   
 SELECT POI.[PointOfInterestId],POI.PointOfInterestName, POI.PointOfInterestIdentifier, POI.PointOfInterestAddress,  
   POI.IdDepartment,POI.DepartmentName,POI.POIHierarchyLevel1Id, POI.POIHierarchyLevel1Name, POI.POIHierarchyLevel1SapId, POI.POIHierarchyLevel2Id,   
   POI.POIHierarchyLevel2Name, POI.POIHierarchyLevel2SapId,POI.CustomAttributeName, POI.CustomAttributeId,   
   POI.CustomAttributeValueType,POI.CustomAttributeValue, POI.PointOfInterestContactName, POI.PointOfInterestContactPhoneNumber  
 FROM    [dbo].[PointOfInterestInfo] POI WITH (NOLOCK)  
  
 WHERE  ((@IdUserLocal IS NULL) OR (dbo.CheckDepartmentInUserDepartments(POI.[IdDepartment], @IdUserLocal) = 1))  
  
 INSERT INTO #TempResultPersonOfInterest(PersonOfInterestId ,  
    PersonOfInterestName, PersonOfInterestLastName, PersonOfInterestIdentifier, PersonOfInterestMobile ,PersonOfInterestIMEI)  
 SELECT  PEOI.Id, PEOI.[Name], PEOI.[LastName], PEOI.[Identifier] ,  
   PEOI.[MobilePhoneNumber] , PEOI.[MobileIMEI]   
 FROM [dbo].[PersonOfInterest] PEOI WITH (NOLOCK)  
  
 WHERE  ((@IdUserLocal IS NULL) OR (dbo.CheckDepartmentInUserDepartments(PEOI.[IdDepartment], @IdUserLocal) = 1))   
   
 SELECT *, NULL ProductReportAttributeImage  
 FROM #TempResultProductReport  
 ORDER BY [ReportDateTime] ASC, [ProductReportId]  
  
 SELECT *, NULL ProductReportAttributeImage  
 FROM #TempResultProducts  
 order by [ProductCategoryListId]  
  
 SELECT *  
 FROM #TempResultPointOfInterest  
  
 SELECT *   
 FROM #TempResultPersonOfInterest  
    
 --SELECT  PR.[ProductReportId] AS Id, PR.ProductId, PR.PersonOfInterestId,   
 -- PR.PointOfInterestId, PR.[ReportDateTime], PR.[TheoricalStock], PR.[TheoricalPrice],  
 -- P.ProductIdentifier, P.ProductName, P.ProductBarCode,  
 -- POI.PointOfInterestName, POI.PointOfInterestIdentifier, POI.PointOfInterestAddress,  
 -- POI.IdDepartment, POI.DepartmentName, POI.POIHierarchyLevel1Id, POI.POIHierarchyLevel1Name, POI.POIHierarchyLevel1SapId,  
 -- POI.POIHierarchyLevel2Id, POI.POIHierarchyLevel2Name, POI.POIHierarchyLevel2SapId,  
 -- PEOI.PersonOfInterestName, PEOI.PersonOfInterestLastName, PEOI.PersonOfInterestIdentifier,PEOI.PersonOfInterestMobile,PEOI.PersonOfInterestIMEI,  
 -- P.ProductCategoryId, P.ProductCategoryName, POI.CustomAttributeName, POI.CustomAttributeId,POI.CustomAttributeValueType,  
 -- POI.CustomAttributeValue, PR.[IdProductReportAttribute], PR.ProductReportAttributeValue, PR.IdProductReportAttributeValue,  
 -- PR.IdProductReportAttributeType,   
 -- PR.ProductReportAttributeOption,PR.ProductReportAttributeName,  
 -- NULL AS ProductReportAttributeImage, PR.ProductReportAttributeImageUrl,  
 -- PR.ProductReportAttributeImageName, P.BrandId, P.BrandIdentifier, P.BrandName, P.CompanyId, P.CompanyIdentifier, P.CompanyName  
     
 --FROM #TempResultProductReport PR WITH (NOLOCK)  
 --  INNER JOIN #TempResultProducts P WITH (NOLOCK) ON P.[ProductId] = PR.[ProductId]   
 --  INNER JOIN #TempResultPointOfInterest POI WITH (NOLOCK) ON POI.[PointOfInterestId] = PR.[PointOfInterestId]  
 --  INNER JOIN #TempResultPersonOfInterest PEOI WITH (NOLOCK) ON PEOI.[PersonOfInterestId] = PR.[PersonOfInterestId]   
      
 --GROUP BY PR.[ProductReportId], PR.ProductId, PR.PersonOfInterestId,   
 --   PR.PointOfInterestId, PR.[ReportDateTime], PR.[TheoricalStock], PR.[TheoricalPrice],  
 --   P.ProductIdentifier, P.ProductName, P.ProductBarCode,  
 --   POI.PointOfInterestName, POI.PointOfInterestIdentifier, POI.PointOfInterestAddress,  
 --   POI.IdDepartment, POI.DepartmentName, POI.POIHierarchyLevel1Id, POI.POIHierarchyLevel1Name, POI.POIHierarchyLevel1SapId,  
 --   POI.POIHierarchyLevel2Id, POI.POIHierarchyLevel2Name, POI.POIHierarchyLevel2SapId,  
 --   PEOI.PersonOfInterestName, PEOI.PersonOfInterestLastName, PEOI.PersonOfInterestIdentifier,PEOI.PersonOfInterestMobile,PEOI.PersonOfInterestIMEI,  
 --   P.ProductCategoryId, P.ProductCategoryName, POI.CustomAttributeName, POI.CustomAttributeId,POI.CustomAttributeValueType,  
 --   POI.CustomAttributeValue, PR.[IdProductReportAttribute], PR.ProductReportAttributeValue, PR.IdProductReportAttributeValue,  
 --   PR.IdProductReportAttributeType,   
 --   PR.ProductReportAttributeOption,PR.ProductReportAttributeName, PR.ProductReportAttributeImageUrl,  
 --   PR.ProductReportAttributeImageName, P.BrandId, P.BrandIdentifier, P.BrandName, P.CompanyId, P.CompanyIdentifier, P.CompanyName  
   
 --ORDER BY PR.[ReportDateTime], PR.[ProductReportId], P.ProductCategoryId   
  
  
 DROP TABLE #TempResultProducts;  
 DROP TABLE #TempResultProductReportDynamic;  
 DROP TABLE #TempResultProductReport;  
 DROP TABLE #TempResultPointOfInterest;  
 DROP TABLE #TempResultPersonOfInterest;  
    
  
END
