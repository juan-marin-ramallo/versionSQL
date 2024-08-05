/****** Object:  Procedure [dbo].[GetProductReportsFilteredAllDataNoImage]    Committed by VersionSQL https://www.versionsql.com ******/

-- ==============================================      
-- Modified by: JUAN MARIN    
-- Modified date: 02/01/2024    
-- Description:  GT-519: Se aplica un case para considerar el valor de un atributo personalizado sea multiple opcion
-- =============================================  
CREATE PROCEDURE [dbo].[GetProductReportsFilteredAllDataNoImage]  
 @DateFrom datetime,  
 @DateTo datetime,  
    @IdProduct varchar(max) = null,  
    @IdPersonOfInterest varchar(max)=null,  
    @IdPointOfInterest varchar(max)=null,  
 @ProductBarCodes [sys].[varchar](max) = NULL,  
    @ProductCategoriesId [sys].[varchar](max) = NULL,  
 @ConditionQuery varchar(max)=NULL,  
 @IdUser [sys].INT = NULL  
AS   
BEGIN  
    SET NOCOUNT ON;  
   
 --SET @DateTo = DATEADD (ms, -1, DATEADD(dd, 1, @DateTo))  
  
 IF @ConditionQuery IS NULL  
 BEGIN  
  SELECT PR.[Id], PR.[IdProduct] as ProductId, PR.[IdPersonOfInterest] as PersonOfInterestId,   
   PR.[IdPointOfInterest] AS PointOfInterestId, PR.[ReportDateTime], PR.[TheoricalStock], PR.[TheoricalPrice],  
   P.[Identifier] AS ProductIdentifier, P.[Name] as ProductName, P.[BarCode] AS ProductBarCode, P.[Indispensable] AS ProductIndispensable,  
   POI.[Name] AS PointOfInterestName, POI.[Identifier] AS PointOfInterestIdentifier, POI.[Address] AS PointOfInterestAddress,  
   D.[Id] AS IdDepartment, D.[Name] AS DepartmentName, POI.[ContactName] AS PointOfInterestContactName, POI.[ContactPhoneNumber] AS PointOfInterestContactPhoneNumber,  
   POIH1.[Id] AS POIHierarchyLevel1Id, POIH1.[Name] AS POIHierarchyLevel1Name, POIH1.[SapId] AS POIHierarchyLevel1SapId,  
   POIH2.[Id] AS POIHierarchyLevel2Id, POIH2.[Name] AS POIHierarchyLevel2Name, POIH2.[SapId] AS POIHierarchyLevel2SapId,  
   PEOI.[Name] as PersonOfInterestName, PEOI.[LastName] AS PersonOfInterestLastName, PEOI.[Identifier] AS PersonOfInterestIdentifier,  
   PEOI.[MobilePhoneNumber] AS PersonOfInterestMobile, PEOI.[MobileIMEI] AS PersonOfInterestIMEI,  
   PC.[Id] AS ProductCategoryId, PC.[Name] AS ProductCategoryName,  
   CAT.[Name] AS CustomAttributeName, CAT.[Id] AS CustomAttributeId, CAT.[IdValueType] AS CustomAttributeValueType,  
   CAV.[Value] AS CustomAttributeValue,  
   --PRAV.[IdProductReportAttribute], PRAV.[Value] AS ProductReportAttributeValue, PRAV.[Id] AS IdProductReportAttributeValue,  
   PRAV.[IdProductReportAttribute], (CASE PRAT.[IdType] WHEN 7 THEN PRO.[Text] ELSE PRAV.[Value] END) AS ProductReportAttributeValue, PRAV.[Id] AS IdProductReportAttributeValue,  
   PRAT.[IdType] AS IdProductReportAttributeType, PRAT.[Name] AS ProductReportAttributeName,  
   PRO.[Text] AS ProductReportAttributeOption,  
   NULL AS ProductReportAttributeImage, PRAV.[ImageUrl] AS ProductReportAttributeImageUrl,  
   PRAV.[ImageName] AS ProductReportAttributeImageName  
   ,PB.[Id] AS BrandId, PB.[Identifier] AS BrandIdentifier, PB.[Name] AS BrandName  
   ,C.[Id] AS CompanyId, C.[Identifier] AS CompanyIdentifier, C.[Name] AS CompanyName,PRAV.IdProductReportAttributeOption  
  FROM [dbo].[ProductReportDynamic] PR WITH(NOLOCK)  
    INNER JOIN [dbo].[Product] P WITH(NOLOCK) ON P.[Id] = PR.[IdProduct]   
    INNER JOIN [dbo].[PointOfInterest] POI WITH(NOLOCK) ON POI.[Id] = PR.[IdPointOfInterest]  
    INNER JOIN [dbo].[PersonOfInterest] PEOI WITH(NOLOCK) ON PEOI.[Id] = PR.[IdPersonOfInterest]  
    LEFT JOIN [dbo].[ProductBrand] PB WITH(NOLOCK) ON P.IdProductBrand = PB.Id  
    LEFT JOIN [dbo].[Company] C WITH(NOLOCK) ON PB.IdCompany = C.Id  
    LEFT JOIN [dbo].[ProductCategoryList] PCL WITH(NOLOCK) ON PCL.[IdProduct] = P.[Id]  
    LEFT JOIN [dbo].[ProductCategory] PC WITH(NOLOCK) ON PCL.[IdProductCategory] = PC.[Id]  
    LEFT JOIN [dbo].[Department] D WITH(NOLOCK) ON D.[Id] = POI.[IdDepartment]  
    LEFT JOIN [dbo].[POIHierarchyLevel1] POIH1 WITH (NOLOCK) ON POIH1.[Id] = POI.[GrandfatherId]  
    LEFT JOIN [dbo].[POIHierarchyLevel2] POIH2 WITH (NOLOCK) ON POIH2.[Id] = POI.[FatherId]  
    LEFT JOIN [dbo].[CustomAttributeValue] CAV WITH(NOLOCK) ON CAV.[IdPointOfInterest] = POI.[Id]  
    LEFT JOIN [dbo].[CustomAttributeTranslated] CAT WITH(NOLOCK) ON CAV.[IdCustomAttribute] = CAT.[Id] AND CAT.[Deleted] = 0  
    LEFT JOIN   [dbo].[ProductReportAttributeValue] PRAV WITH(NOLOCK) ON PRAV.[IdProductReport] = PR.[Id]  
    LEFT JOIN   [dbo].[ProductReportAttribute] PRAT WITH(NOLOCK) ON PRAT.[Id] = PRAV.[IdProductReportAttribute]  
    LEFT JOIN   [dbo].[ProductReportAttributeOption] PRO WITH(NOLOCK) ON PRO.[Id] = PRAV.[IdProductReportAttributeOption]  
  
  WHERE (pr.[ReportDateTime] BETWEEN @DateFrom AND @DateTo) AND   
   ((@IdProduct IS NULL) OR dbo.CheckValueInList (PR.[IdProduct], @IdProduct)=1) AND  
   ((@IdPersonOfInterest IS NULL) OR dbo.CheckValueInList (PR.[IdPersonOfinterest], @IdPersonOfInterest) =1) AND  
   ((@IdPointOfInterest IS NULL) OR dbo.CheckValueInList (PR.[IdPointOfInterest], @IdPointOfInterest) =1) AND  
   ((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(PEOI.[Id], @IdUser) = 1)) AND  
   ((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(POI.[Id], @IdUser) = 1)) AND  
   ((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(PEOI.[IdDepartment], @IdUser) = 1)) AND  
   ((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(POI.[IdDepartment], @IdUser) = 1)) AND  
   ((@ProductBarCodes IS NULL) OR (dbo.CheckVarcharInList(P.[BarCode], @ProductBarCodes) = 1)) AND  
   ((@ProductCategoriesId IS NULL) OR (dbo.CheckValueInList(PCL.[IdProductCategory], @ProductCategoriesId) = 1)) AND  
   ((@IdUser IS NULL) OR (dbo.CheckUserInProductCompanies(P.[IdProductBrand], @IdUser) = 1)) AND  
   (PRAV.[Id] IS NULL OR PRAT.[FullDeleted] = 0)  
    
  ORDER BY PR.[ReportDateTime], PR.[Id], PCL.[Id]   
 END  
 ELSE  
 BEGIN  
  DECLARE @SqlQuery nvarchar(max)  
  SET @SqlQuery =   
   N'SELECT PR.[Id], PR.[IdProduct] as ProductId, PR.[IdPersonOfInterest] as PersonOfInterestId,   
    PR.[IdPointOfInterest] AS PointOfInterestId, PR.[ReportDateTime], PR.[TheoricalStock], PR.[TheoricalPrice],  
    P.[Identifier] AS ProductIdentifier, P.[Name] as ProductName, P.[BarCode] AS ProductBarCode, P.[Indispensable] AS ProductIndispensable,  
    POI.[Name] AS PointOfInterestName, POI.[Identifier] AS PointOfInterestIdentifier, POI.[Address] AS PointOfInterestAddress,  
    D.[Id] AS IdDepartment, D.[Name] AS DepartmentName, POI.[ContactName] AS PointOfInterestContactName, POI.[ContactPhoneNumber] AS PointOfInterestContactPhoneNumber,  
    POIH1.[Id] AS POIHierarchyLevel1Id, POIH1.[Name] AS POIHierarchyLevel1Name, POIH1.[SapId] AS POIHierarchyLevel1SapId,  
    POIH2.[Id] AS POIHierarchyLevel2Id, POIH2.[Name] AS POIHierarchyLevel2Name, POIH2.[SapId] AS POIHierarchyLevel2SapId,  
    PEOI.[Name] as PersonOfInterestName, PEOI.[LastName] AS PersonOfInterestLastName, PEOI.[Identifier] AS PersonOfInterestIdentifier,  
    PEOI.[MobilePhoneNumber] AS PersonOfInterestMobile, PEOI.[MobileIMEI] AS PersonOfInterestIMEI,  
    PC.[Id] AS ProductCategoryId, PC.[Name] AS ProductCategoryName,  
    CAT.[Name] AS CustomAttributeName, CAT.[Id] AS CustomAttributeId, CAT.[IdValueType] AS CustomAttributeValueType,  
    CAV.[Value] AS CustomAttributeValue,  
    --PRAV.[IdProductReportAttribute], PRAV.[Value] AS ProductReportAttributeValue,  
	PRAV.[IdProductReportAttribute], (CASE PRAT.[IdType] WHEN 7 THEN PRO.[Text] ELSE PRAV.[Value] END) AS ProductReportAttributeValue
    PRAT.[IdType] AS IdProductReportAttributeType, PRAT.[Name] AS ProductReportAttributeName,  
    PRO.[Text] AS ProductReportAttributeOption,  
    NULL AS ProductReportAttributeImage, NULL AS ProductReportAttributeImageUrl,  
    NULL AS ProductReportAttributeImageName  
    ,PB.[Id] AS BrandId, PB.[Identifier] AS BrandIdentifier, PB.[Name] AS BrandName  
    ,C.[Id] AS CompanyId, C.[Identifier] AS CompanyIdentifier, C.[Name] AS CompanyName  
   FROM [dbo].[ProductReportDynamic] PR WITH (NOLOCK)  
     INNER JOIN [dbo].[Product] P WITH (NOLOCK) ON P.[Id] = PR.[IdProduct]   
     INNER JOIN [dbo].[PointOfInterest] POI WITH (NOLOCK) ON POI.[Id] = PR.[IdPointOfInterest]  
     INNER JOIN [dbo].[PersonOfInterest] PEOI WITH (NOLOCK) ON PEOI.[Id] = PR.[IdPersonOfInterest]  
     LEFT JOIN [dbo].[ProductBrand] PB WITH(NOLOCK) ON P.IdProductBrand = PB.Id  
     LEFT JOIN [dbo].[Company] C WITH(NOLOCK) ON PB.IdCompany = C.Id  
     LEFT JOIN [dbo].[ProductCategoryList] PCL WITH (NOLOCK) ON PCL.[IdProduct] = P.[Id]  
     LEFT JOIN [dbo].[ProductCategory] PC WITH (NOLOCK) ON PCL.[IdProductCategory] = PC.[Id]  
     LEFT JOIN [dbo].[Department] D WITH (NOLOCK) ON D.[Id] = POI.[IdDepartment]  
     LEFT JOIN [dbo].[POIHierarchyLevel1] POIH1 WITH (NOLOCK) ON POIH1.[Id] = POI.[GrandfatherId]  
     LEFT JOIN [dbo].[POIHierarchyLevel2] POIH2 WITH (NOLOCK) ON POIH2.[Id] = POI.[FatherId]  
     LEFT JOIN [dbo].[CustomAttributeValue] CAV WITH (NOLOCK) ON CAV.[IdPointOfInterest] = POI.[Id]  
     LEFT JOIN [dbo].[CustomAttributeTranslated] CAT WITH (NOLOCK) ON CAV.[IdCustomAttribute] = CAT.[Id] AND CAT.[Deleted] = 0  
     LEFT JOIN   [dbo].[ProductReportAttributeValue] PRAV WITH (NOLOCK) ON PRAV.[IdProductReport] = PR.[Id]  
     LEFT JOIN   [dbo].[ProductReportAttribute] PRAT WITH (NOLOCK) ON PRAT.[Id] = PRAV.[IdProductReportAttribute]  
     LEFT JOIN   [dbo].[ProductReportAttributeOption] PRO WITH (NOLOCK) ON PRO.[IdProductReportAttribute] = PRAT.[Id]  
    
   WHERE (pr.[ReportDateTime] BETWEEN @DateFrom AND @DateTo) AND  
    ((@IdProduct IS NULL) OR dbo.CheckValueInList (PR.[IdProduct], @IdProduct)=1) AND  
    ((@IdPersonOfInterest IS NULL) OR dbo.CheckValueInList (PR.[IdPersonOfinterest], @IdPersonOfInterest) =1) AND  
    ((@IdPointOfInterest IS NULL) OR dbo.CheckValueInList (PR.[IdPointOfInterest], @IdPointOfInterest) =1) AND  
    ((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(PEOI.[Id], @IdUser) = 1)) AND  
    ((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(POI.[Id], @IdUser) = 1)) AND  
    ((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(PEOI.[IdDepartment], @IdUser) = 1)) AND  
    ((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(POI.[IdDepartment], @IdUser) = 1)) AND  
    ((@ProductBarCodes IS NULL) OR (dbo.CheckVarcharInList(P.[BarCode], @ProductBarCodes) = 1)) AND  
    ((@ProductCategoriesId IS NULL) OR (dbo.CheckValueInList(PCL.[IdProductCategory], @ProductCategoriesId) = 1)) AND  
    ((@IdUser IS NULL) OR (dbo.CheckUserInProductCompanies(P.[IdProductBrand], @IdUser) = 1))  
    AND ' + @ConditionQuery + ' ORDER BY ReportDateTime, Id, PCL.[Id]'  
  
  EXECUTE sp_executesql @SqlQuery, N'@DateFrom datetime,  
       @DateTo datetime,  
       @IdProduct varchar(max),  
       @IdPersonOfInterest varchar(max),  
       @IdPointOfInterest varchar(max),  
       @IdUser [sys].INT = NULL,  
       @ProductBarCodes [sys].[varchar](max) = NULL,  
       @ProductCategoriesId [sys].[varchar](max) = NULL',  
       @DateFrom = @DateFrom,  
       @DateTo = @DateTo,  
       @IdProduct = @IdProduct,  
       @IdPersonOfInterest = @IdPersonOfInterest,  
       @IdPointOfInterest = @IdPointOfInterest,  
       @IdUser = @IdUser,  
       @ProductBarCodes = @ProductBarCodes,  
       @ProductCategoriesId = @ProductCategoriesId  
 END  
END
