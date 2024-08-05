/****** Object:  Procedure [dbo].[GetProductReportsFiltered]    Committed by VersionSQL https://www.versionsql.com ******/

-- ==============================================      
-- Modified by: JUAN MARIN    
-- Modified date: 02/01/2024    
-- Description:  GT-519: Se aplica un case para considerar el valor de un atributo personalizado sea multiple opcion
-- =============================================  
CREATE PROCEDURE [dbo].[GetProductReportsFiltered]  
 @DateFrom datetime,  
 @DateTo datetime,  
    @IdProduct varchar(max) = NULL,  
    @IdPersonOfInterest varchar(max) = NULL,  
    @IdPointOfInterest varchar(max) = NULL,  
 @ProductBarCodes [sys].[varchar](max) = NULL,  
    @ProductCategoriesId [sys].[varchar](max) = NULL  
 ,@IdCompany [sys].[varchar](max) = NULL  
 ,@IdProductBrand [sys].[varchar](max) = NULL,  
 @ConditionQuery varchar(max)=NULL,  
 @IdUser int = NULL,  
 @FilteredDynamicAttributeIds varchar(max)=NULL  
AS   
BEGIN  
    SET NOCOUNT ON;  
  
 IF @ConditionQuery IS NULL  
 BEGIN  
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
  
  SELECT PR.[Id], PR.[IdProduct] as ProductId, PR.[IdPersonOfInterest] as PersonOfInterestId,   
   PR.[IdPointOfInterest] as PointOfInterestId, PR.[ReportDateTime], PR.[TheoricalStock], pr.[TheoricalPrice],  
   P.[Identifier] AS ProductIdentifier, P.[Name] as ProductName, P.[BarCode] AS ProductBarCode,  
   POI.[Name] as PointOfInterestName, POI.[Identifier] AS PointOfInterestIdentifier,  
   PEOI.[Name] as PersonOfInterestName, PEOI.[LastName] AS PersonOfInterestLastName,   
   PC.[Id] AS ProductCategoryId, PC.[Name] AS ProductCategoryName,  
   --PRAV.[IdProductReportAttribute], PRAV.[Value] AS ProductReportAttributeValue, PRAV.[Id] AS IdProductReportAttributeValue,  
   PRAV.[IdProductReportAttribute], (CASE PRAT.[IdType] WHEN 7 THEN PRO.[Text] ELSE PRAV.[Value] END) AS ProductReportAttributeValue, PRAV.[Id] AS IdProductReportAttributeValue,  
   PRAT.[IdType] AS IdProductReportAttributeType,   
   PRO.[Text] AS ProductReportAttributeOption, PRO.[Id] AS [IdProductReportAttributeOption],  
   (CASE WHEN PRAV.[ImageEncoded] IS NULL AND PRAV.[ImageUrl] IS NULL THEN 0 ELSE 1 END) AS ProductReportAttributeImage,  
   PRAV.[ImageUrl] AS ProductReportAttributeImageUrl, PRAT.[Name] AS ProductReportAttributeName,  
   PRAV.[ImageName] AS ProductReportAttributeImageName,  
   PRATYPE.[Id] AS IdProductReportAttributeType  
    
  FROM [dbo].[ProductReportDynamic] PR WITH (NOLOCK)   
   INNER JOIN [dbo].[Product] P WITH (NOLOCK) ON P.[Id] = PR.[IdProduct]   
   INNER JOIN [dbo].[PointOfInterest] POI WITH (NOLOCK) ON POI.[Id] = PR.[IdPointOfInterest]  
   INNER JOIN [dbo].[PersonOfInterest] PEOI WITH (NOLOCK) ON PEOI.[Id] = PR.[IdPersonOfInterest]  
   LEFT JOIN [dbo].[ProductCategoryList] PCL WITH (NOLOCK) ON PCL.[IdProduct] = P.[Id]  
   LEFT JOIN [dbo].[ProductCategory] PC WITH (NOLOCK) ON PCL.[IdProductCategory] = PC.[Id]  
   LEFT JOIN   [dbo].[ProductReportAttributeValue] PRAV WITH (NOLOCK) ON PRAV.[IdProductReport] = PR.[Id]  
   LEFT JOIN   [dbo].[ProductReportAttribute] PRAT WITH (NOLOCK) ON PRAT.[Id] = PRAV.[IdProductReportAttribute]  
   LEFT JOIN   [dbo].[ProductReportAttributeOption] PRO WITH (NOLOCK) ON PRO.[Id] = PRAV.[IdProductReportAttributeOption]  
   LEFT JOIN [dbo].[ProductReportAttributeType] PRATYPE WITH (NOLOCK) ON PRATYPE.[Id] = PRAT.[IdType]      
   LEFT OUTER JOIN [dbo].[ProductBrand] B WITH (NOLOCK) ON B.[Id] = P.IdProductBrand  
   LEFT OUTER JOIN [dbo].[Company] CM WITH (NOLOCK) ON CM.[Id] = B.IdCompany  
    
  WHERE (pr.[ReportDateTime] BETWEEN @DateFromLocal  AND @DateToLocal)   
    AND ((@IdProductLocal IS NULL) OR dbo.CheckValueInList (PR.[IdProduct], @IdProductLocal)=1)  
    AND ((@IdPersonOfInterestLocal IS NULL) OR dbo.CheckValueInList (PR.[IdPersonOfinterest], @IdPersonOfInterestLocal) =1)  
    AND ((@IdPointOfInterestLocal IS NULL) OR dbo.CheckValueInList (PR.[IdPointOfInterest], @IdPointOfInterestLocal) =1)  
    AND ((@IdUserLocal IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(PEOI.[Id], @IdUserLocal) = 1))  
    AND ((@IdUserLocal IS NULL) OR (dbo.CheckUserInPointOfInterestZones(POI.[Id], @IdUserLocal) = 1))  
    AND ((@IdUserLocal IS NULL) OR (dbo.CheckDepartmentInUserDepartments(PEOI.[IdDepartment], @IdUserLocal) = 1))  
    AND ((@IdUserLocal IS NULL) OR (dbo.CheckDepartmentInUserDepartments(POI.[IdDepartment], @IdUserLocal) = 1))  
    AND ((@ProductBarCodesLocal IS NULL) OR (dbo.CheckVarcharInList(P.[BarCode], @ProductBarCodesLocal) = 1))  
    AND ((@ProductCategoriesIdLocal IS NULL) OR (dbo.CheckValueInList(PCL.[IdProductCategory], @ProductCategoriesIdLocal) = 1))  
    AND (@IdProductBrandLocal IS NULL OR dbo.CheckValueInList(IIF(B.[Id] IS NULL, 0, B.[Id]), @IdProductBrandLocal) = 1)  
    AND (@IdCompanyLocal IS NULL OR dbo.CheckValueInList(IIF(CM.[Id] IS NULL, 0, CM.[Id]), @IdCompanyLocal) = 1)  
    AND ((@IdUserLocal IS NULL) OR (dbo.CheckUserInProductCompanies(P.[IdProductBrand], @IdUserLocal) = 1))  
    AND (PRAV.[Id] IS NULL OR PRAT.[FullDeleted] = 0)  
  GROUP BY PR.[Id], PR.[IdProduct], PR.[IdPersonOfInterest] , PR.[ReportDateTime], PCL.[Id], PR.[IdPointOfInterest] , PR.[ReportDateTime], PR.[TheoricalStock], pr.[TheoricalPrice],  
   P.[Identifier], P.[Name], P.[BarCode], POI.[Name], POI.[Identifier], PEOI.[Name], PEOI.[LastName],  PC.[Id], PC.[Name] ,  
   PRAV.[IdProductReportAttribute], PRAV.[Value], PRAV.[Id] , PRAT.[IdType],  PRO.[Text], PRO.[Id], (CASE WHEN PRAV.[ImageEncoded] IS NULL AND PRAV.[ImageUrl] IS NULL THEN 0 ELSE 1 END) ,  
   PRAV.[ImageUrl] , PRAV.[ImageName], PRATYPE.[Id], PRAT.[Name]  
  ORDER BY PR.[ReportDateTime] DESC, PR.[Id], PCL.[Id]  
  
 END  
 ELSE  
 BEGIN  
  DECLARE @SqlQuery nvarchar(max)  
  SET @SqlQuery =   
   N'SELECT PR.[Id], PR.[IdProduct] as ProductId, PR.[IdPersonOfInterest] as PersonOfInterestId,   
    PR.[IdPointOfInterest] as PointOfInterestId, PR.[ReportDateTime], PR.[TheoricalStock], pr.[TheoricalPrice],  
    P.[Identifier] AS ProductIdentifier, P.[Name] as ProductName, P.[BarCode] AS ProductBarCode,  
    POI.[Name] as PointOfInterestName, POI.[Identifier] AS PointOfInterestIdentifier,  
    PEOI.[Name] as PersonOfInterestName, PEOI.[LastName] AS PersonOfInterestLastName,   
    PC.[Id] AS ProductCategoryId, PC.[Name] AS ProductCategoryName,  
    --PRAV.[IdProductReportAttribute], PRAV.[Value] AS ProductReportAttributeValue, PRAV.[Id] AS IdProductReportAttributeValue,  
	PRAV.[IdProductReportAttribute], (CASE PRAT.[IdType] WHEN 7 THEN PRO.[Text] ELSE PRAV.[Value] END) AS ProductReportAttributeValue, PRAV.[Id] AS IdProductReportAttributeValue,  
    PRAT.[IdType] AS IdProductReportAttributeType,   
    PRO.[Text] AS ProductReportAttributeOption,  
    (CASE WHEN PRAV.[ImageEncoded] IS NULL THEN 0 ELSE 1 END) AS ProductReportAttributeImage,  
    PRATYPE.[Id] AS IdProductReportAttributeType  
    
   FROM [dbo].[ProductReportDynamic] PR  
    INNER JOIN [dbo].[Product] P ON P.[Id] = PR.[IdProduct]   
    INNER JOIN [dbo].[PointOfInterest] POI ON POI.[Id] = PR.[IdPointOfInterest]  
    INNER JOIN [dbo].[PersonOfInterest] PEOI ON PEOI.[Id] = PR.[IdPersonOfInterest]  
    LEFT JOIN [dbo].[ProductCategoryList] PCL ON PCL.[IdProduct] = P.[Id]  
    LEFT JOIN [dbo].[ProductCategory] PC ON PCL.[IdProductCategory] = PC.[Id]  
    LEFT JOIN   [dbo].[ProductReportAttributeValue] PRAV ON PRAV.[IdProductReport] = PR.[Id]  
    LEFT JOIN   [dbo].[ProductReportAttribute] PRAT ON PRAT.[Id] = PRAV.[IdProductReportAttribute]  
    LEFT JOIN   [dbo].[ProductReportAttributeOption] PRO ON PRO.[IdProductReportAttribute] = PRAT.[Id]  
    LEFT JOIN [dbo].[ProductReportAttributeType] PRATYPE ON PRATYPE.[Id] = PRAT.[IdType]     
    LEFT OUTER JOIN [dbo].[ProductBrand] B WITH (NOLOCK) ON B.[Id] = P.IdProductBrand  
    LEFT OUTER JOIN [dbo].[Company] CM WITH (NOLOCK) ON CM.[Id] = B.IdCompany  
    
   WHERE (pr.[ReportDateTime] BETWEEN @DateFrom  AND @DateTo) AND  
    ((@IdProduct IS NULL) OR dbo.CheckValueInList (PR.[IdProduct], @IdProduct)=1) AND  
    ((@IdPersonOfInterest IS NULL) OR dbo.CheckValueInList (PR.[IdPersonOfinterest], @IdPersonOfInterest) =1) AND  
    ((@IdPointOfInterest IS NULL) OR dbo.CheckValueInList (PR.[IdPointOfInterest], @IdPointOfInterest) =1) AND  
    ((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(PEOI.[Id], @IdUser) = 1)) AND  
    ((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(POI.[Id], @IdUser) = 1)) AND  
    ((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(PEOI.[IdDepartment], @IdUser) = 1)) AND  
    ((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(POI.[IdDepartment], @IdUser) = 1)) AND  
    ((@ProductBarCodes IS NULL) OR (dbo.CheckVarcharInList(P.[BarCode], @ProductBarCodes) = 1)) AND  
    ((@ProductCategoriesId IS NULL) OR (dbo.CheckValueInList(PCL.[IdProductCategory], @ProductCategoriesId) = 1))  
    AND (@IdProductBrand IS NULL OR dbo.CheckValueInList(IIF(B.[Id] IS NULL, 0, B.[Id]), @IdProductBrand) = 1)  
    AND (@IdCompany IS NULL OR dbo.CheckValueInList(IIF(CM.[Id] IS NULL, 0, CM.[Id]), @IdCompany) = 1)   
    AND ((@IdUser IS NULL) OR (dbo.CheckUserInProductCompanies(P.[IdProductBrand], @IdUser) = 1))  
    AND ' + @ConditionQuery + '   
  
   GROUP BY PR.[Id], PR.[IdProduct], PR.[IdPersonOfInterest] , PR.[ReportDateTime], PCL.[Id], PR.[IdPointOfInterest] , PR.[ReportDateTime], PR.[TheoricalStock], pr.[TheoricalPrice],  
    P.[Identifier], P.[Name], P.[BarCode], POI.[Name], POI.[Identifier], PEOI.[Name], PEOI.[LastName],  PC.[Id], PC.[Name] ,  
    PRAV.[IdProductReportAttribute], PRAV.[Value], PRAV.[Id] , PRAT.[IdType],  PRO.[Text], (CASE WHEN PRAV.[ImageEncoded] IS NULL AND PRAV.[ImageUrl] IS NULL THEN 0 ELSE 1 END) ,  
    PRAV.[ImageUrl] , PRAV.[ImageName], PRATYPE.[Id]  
      
    ORDER BY PR.[ReportDateTime] DESC, PR.[Id], PCL.[Id]'  
    
  EXECUTE sp_executesql @SqlQuery,   
        N'@DateFrom datetime,  
       @DateTo datetime,  
       @IdProduct varchar(max) = NULL,  
       @IdPersonOfInterest varchar(max) = NULL,  
       @IdPointOfInterest varchar(max) = NULL,  
       @ProductBarCodes [sys].[varchar](max) = NULL,  
       @ProductCategoriesId [sys].[varchar](max) = NULL,  
       @ConditionQuery varchar(max) = NULL,  
       @IdUser int = NULL',  
       @DateFrom = @DateFrom,  
       @DateTo = @DateTo,  
       @IdProduct = @IdProduct,  
       @IdPersonOfInterest = @IdPersonOfInterest,  
       @IdPointOfInterest = @IdPointOfInterest,  
       @ProductBarCodes = @ProductBarCodes,  
       @ProductCategoriesId = @ProductCategoriesId,  
       @IdUser = @IdUser  
 END  
END
