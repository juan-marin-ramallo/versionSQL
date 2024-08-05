/****** Object:  Procedure [dbo].[GetShortageStockReport]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================  
-- Author:  GL  
-- Create date: 04/08/2016  
-- Description: SP para obtener el reporte de faltantes, en base al inventario teórico  
-- =============================================  

CREATE PROCEDURE [dbo].[GetShortageStockReport]
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
 CREATE TABLE #ProductsFiltered  
  (  
   IdProduct [sys].[int]  
  )  
  
  
  INSERT INTO #ProductsFiltered(IdProduct)  
  SELECT DISTINCT P.[Id]  
  FROM [dbo].[Product] P WITH (NOLOCK)  
  LEFT JOIN [dbo].[ProductCategoryList] PCL ON PCL.[IdProduct] = P.[Id]  
    LEFT OUTER JOIN [dbo].[ProductBrand] PB WITH (NOLOCK) ON PB.[Id] = P.IdProductBrand  
    LEFT OUTER JOIN [dbo].[Company] CM WITH (NOLOCK) ON CM.[Id] = PB.IdCompany  
  WHERE ((@IdProduct IS NULL) OR (dbo.CheckValueInList(P.[Id], @IdProduct) = 1))   
    AND ((@ProductCategoriesId IS NULL) OR (dbo.CheckValueInList(PCL.[IdProductCategory], @ProductCategoriesId) = 1))   
    AND ((@IdUser IS NULL) OR (dbo.CheckUserInProductCompanies(P.[IdProductBrand], @IdUser) = 1))    
    AND (@IdProductBrand IS NULL OR dbo.CheckValueInList(IIF(PB.[Id] IS NULL, 0, PB.[Id]), @IdProductBrand) = 1)  
    AND (@IdCompany IS NULL OR dbo.CheckValueInList(IIF(CM.[Id] IS NULL, 0, CM.[Id]), @IdCompany) = 1)  
  
    
  
 SELECT  PM.[Id], PM.[Date] AS ReportDate,  
    PM.[IdPointOfInterest] AS PointOfInterestId, POI.[Name] AS PointOfInterestName, POI.[Identifier] AS PointOfInterestIdentifier,  
    PM.[IdPersonOfInterest] AS PersonOfInterestId, S.[Name] AS PersonOfInterestName, 
	S.[LastName] AS PersonOfInterestLastName, S.Identifier as PersonOfInterestIdentifier,
	S.MobilePhoneNumber as PersonOfInterestMobile, S.MobileIMEI as PersonOfInterestIMEI,
    PM.[MissingConfirmation], PMRT.[Name] AS ProductMissingReportTypeName,  
    --(CASE WHEN IRD.[Id] IS NULL THEN 1 ELSE 0 END) AS IsManual
	1 AS IsManual
 FROM  [dbo].[ProductMissingPointOfInterest] PM WITH (NOLOCK)  
    INNER JOIN [dbo].[PointOfInterest] POI WITH (NOLOCK) ON POI.[Id] = PM.[IdPointOfInterest]  
    INNER JOIN [dbo].[PersonOfInterest] S WITH (NOLOCK) ON S.[Id] = PM.[IdPersonOfInterest]  
    LEFT JOIN [dbo].[ProductMissingReportType] PMRT WITH (NOLOCK) ON PMRT.[Id] = PM.[IdProductMissingType]  
    --LEFT JOIN [dbo].[IRData] IRD WITH (NOLOCK) ON IRD.[IdMissingProduct] = PM.[Id]  
  
 WHERE  PM.[Deleted] = 0 AND PM.[Date] >= DATEADD(MINUTE, -1, @DateFrom) AND PM.[Date] <= DATEADD(MINUTE, 1, @DateTo) AND PM.[Deleted] = 0 AND  
    ((@IdPointOfInterest IS NULL) OR (dbo.CheckValueInList(POI.[Id], @IdPointOfInterest) = 1)) AND  
    ((@IdPersonOfInterest IS NULL) OR (dbo.CheckValueInList(S.[Id], @IdPersonOfInterest) = 1)) AND  
    ((@IdShortageType IS NULL) OR (dbo.CheckValueInList(PM.[IdProductMissingType], @IdShortageType) = 1)) AND  
    ((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1)) AND  
    ((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(POI.[Id], @IdUser) = 1)) AND  
    ((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1)) AND  
    ((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(POI.[IdDepartment], @IdUser) = 1))  
    AND ((PM.[MissingConfirmation] = 0 AND @IdProduct IS NULL AND @ProductCategoriesId IS NULL AND @IdCompany IS NULL AND @IdProductBrand IS NULL)   
     OR EXISTS (SELECT 1 FROM  
        [dbo].[ProductMissingReport] PMR   
        INNER JOIN #ProductsFiltered P ON P.[IdProduct] = PMR.[IdProduct]  
        WHERE PMR.[IdMissingProductPoi] = PM.[Id]))  
  
  
 ORDER BY PM.[Date] ASC  
  
 DROP TABLE #ProductsFiltered  
END
