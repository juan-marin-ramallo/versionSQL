/****** Object:  Procedure [dbo].[GetOrderReportsAllDataById]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetOrderReportsAllDataById]                
 @IdProduct varchar(max) = null,                
@IdOrderReport int,                
 @ProductBarCodes [sys].[varchar](max) = NULL,                
 @ProductCategoriesId [sys].[varchar](max) = NULL,                
 @IdCompany [sys].[varchar](max) = NULL,                
 @IdProductBrand [sys].[varchar](max) = NULL,                
 @IdUser [sys].INT = NULL                
AS                 
BEGIN                
    SET NOCOUNT ON;                
                
 DECLARE @IdOrderReportLocal int = @IdOrderReport                
 DECLARE @IdProductLocal varchar(max) = @IdProduct                
 DECLARE @ProductBarCodesLocal [sys].[varchar](max) = @ProductBarCodes                
 DECLARE @ProductCategoriesIdLocal [sys].[varchar](max) = @ProductCategoriesId                
 DECLARE @IdCompanyLocal [sys].[varchar](max) = @IdCompany                
 DECLARE @IdProductBrandLocal [sys].[varchar](max) = @IdProductBrand                
 DECLARE @IdUserLocal int = @IdUser                
 DECLARE @IdInitialStatus int          
 SELECT @IdInitialStatus = Id FROM OrderStatus WHERE IsInitial = 1 AND Disabled = 0          
                
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
  ProductColumn_25 varchar(100)                
    );                
                
 INSERT INTO #TempResultProducts(ProductId, ProductIdentifier, ProductName ,ProductBarCode,ProductCategoryId , ProductCategoryName ,                
 BrandId,BrandIdentifier, BrandName ,CompanyId, CompanyIdentifier, CompanyName, ProductIndispensable, ProductMinSalesQuantity, ProductMinUnitsPackage,                
 ProductMaxSalesQuantity, ProductInStock, ProductColumn_1, ProductColumn_2 , ProductColumn_3, ProductColumn_4 , ProductColumn_5, ProductColumn_6,                 
 ProductColumn_7, ProductColumn_8 , ProductColumn_9 , ProductColumn_10 , ProductColumn_11,                 
 ProductColumn_12, ProductColumn_13 , ProductColumn_14 , ProductColumn_15, ProductColumn_16 ,                 
 ProductColumn_17 , ProductColumn_18 , ProductColumn_19, ProductColumn_20 , ProductColumn_21 ,                 
 ProductColumn_22 , ProductColumn_23 , ProductColumn_24 , ProductColumn_25)                
          
 SELECT  P.[Id], P.ProductIdentifier, P.ProductName,P.ProductBarCode,P.ProductCategoryId, P.ProductCategoryName,P.BrandId, P.BrandIdentifier, P.BrandName,                
   P.CompanyId, P.CompanyIdentifier, P.CompanyName, P.ProductIndispensable, P.ProductMinSalesQuantity, P.ProductMinUnitsPackage,                 
   P.ProductMaxSalesQuantity, P.ProductInStock, P.[Column_1], P.[Column_2],P.[Column_3],P.[Column_4],P.[Column_5],P.[Column_6],P.[Column_7],P.[Column_8],P.[Column_9],                
   P.[Column_10], P.[Column_11],P.[Column_12],P.[Column_13],P.[Column_14],P.[Column_15],P.[Column_16],P.[Column_17],                
   P.[Column_18], P.[Column_19],P.[Column_20],P.[Column_21],P.[Column_22],P.[Column_23],P.[Column_24],                
   P.[Column_25]                
                 
 FROM   [dbo].[ProductInfo] P WITH (NOLOCK)                
                
 WHERE ((@IdProductLocal IS NULL) OR dbo.CheckValueInList (P.[Id], @IdProductLocal)=1) AND                
  ((@ProductBarCodesLocal IS NULL) OR (dbo.CheckVarcharInList(P.ProductBarCode, @ProductBarCodesLocal) = 1)) AND                
   ((@ProductCategoriesIdLocal IS NULL) OR (dbo.CheckValueInList(P.ProductCategoryId, @ProductCategoriesIdLocal) = 1))                    
   AND (@IdProductBrandLocal IS NULL OR dbo.CheckValueInList(IIF(P.BrandId IS NULL, 0, P.BrandId), @IdProductBrandLocal) = 1)                
   AND (@IdCompanyLocal IS NULL OR dbo.CheckValueInList(IIF(P.CompanyId IS NULL, 0, P.CompanyId), @IdCompanyLocal) = 1)                
   AND ((@IdUserLocal IS NULL) OR (dbo.CheckUserInProductCompanies(P.BrandId, @IdUserLocal) = 1))                
                 
 CREATE TABLE #TempResultOrderReportDynamic                
    (                 
  OrderReportId int,                 
  PersonOfInterestId int,                 
  PointOfInterestId int,                
  OrderReportDateTime datetime,                
  OrderComment varchar(250),                 
  OrderEmails varchar(500),                
  OrderStatus smallint              
    );                
                
 INSERT INTO #TempResultOrderReportDynamic(OrderReportId,                 
    PersonOfInterestId, PointOfInterestId,OrderReportDateTime,OrderComment, OrderEmails,OrderStatus)                
                 
 SELECT  PR.[Id], PR.[IdPersonOfInterest] as PersonOfInterestId,                 
   PR.[IdPointOfInterest] AS PointOfInterestId, PR.[OrderDateTime], PR.[Comment] AS OrderComment, PR.[Emails] AS OrderEmails, PR.[Status] AS OrderStatus                
                 
 FROM   [dbo].[OrderReport] PR WITH (NOLOCK)                
                
 WHERE  PR.[Id]  = @IdOrderReportLocal                
                
                
 CREATE TABLE #TempResultOrderReport                
    (                 
  OrderReportId int,                 
  ProductId int,                 
  PersonOfInterestId int,                 
  PointOfInterestId int,                
  OrderReportDateTime datetime,                
  OrderComment varchar(250),                 
  OrderEmails varchar(500),                 
  Quantity int,                
  IdOrderReportAttribute int,                 
  OrderReportAttributeValue varchar(max),                 
  IdOrderReportAttributeValue int,                
  IdOrderReportAttributeType int,                 
  OrderReportAttributeOption varchar(100),                
  OrderReportAttributeName varchar(100),                 
  OrderReportAttributeImageUrl varchar(5000),                
  OrderReportAttributeImageName  varchar(100),                
  UnitPrice decimal(18, 3),    
  InitialQuantity int,                
  TotalQuantity int,                
  OrderStatus smallint,                
  OrderStatusIsFinal bit,            
  OrderStatusCanEdit bit  
    );                
                
 INSERT INTO #TempResultOrderReport(OrderReportId, ProductId, PersonOfInterestId, PointOfInterestId, OrderReportDateTime,OrderComment, OrderEmails,                
    Quantity , IdOrderReportAttribute, OrderReportAttributeValue, IdOrderReportAttributeValue,IdOrderReportAttributeType, OrderReportAttributeOption,                
    OrderReportAttributeName, OrderReportAttributeImageUrl, OrderReportAttributeImageName, UnitPrice, InitialQuantity, TotalQuantity, OrderStatus, OrderStatusIsFinal, OrderStatusCanEdit)                
                 
 SELECT  PR.OrderReportId, ORPQ.IdProduct, PR.PersonOfInterestId,                 
   PR.PointOfInterestId, PR.[OrderReportDateTime], PR.[OrderComment], PR.[OrderEmails], ORPQ.[Quantity],                
   PRAV.[IdOrderReportAttribute], PRAV.[Value] AS OrderReportAttributeValue, PRAV.[Id] AS IdOrderReportAttributeValue,                
   PRAT.[IdType] AS IdOrderReportAttributeType,                 
   PRO.[Text] AS OrderReportAttributeOption,PRAT.[Name] AS OrderReportAttributeName, PRAV.[ImageUrl] AS OrderReportAttributeImageUrl,                
   PRAV.[ImageName] AS OrderReportAttributeImageName, ORT.[ProductPrice], 
   CASE WHEN(EXISTS(SELECT 1 FROM [dbo].[Configuration] WHERE [Description] = 'Seguimiento de Pedidos' AND [Value] = 1)) 
		THEN ORT.[Quantity] 
		ELSE ORPQ.[Quantity]
   END	AS InitialQuantity, 
   ORPQ.[Quantity] AS TotalQuantity, PR.[OrderStatus], OS.IsFinal, OS.CanEdit                  
                 
FROM #TempResultOrderReportDynamic PR WITH (NOLOCK)                
   LEFT JOIN   [dbo].[OrderReportProductQuantity] ORPQ WITH (NOLOCK) ON ORPQ.[IdOrderReport] = PR.OrderReportId                
   LEFT JOIN   [dbo].[OrderReportAttributeValue] PRAV WITH (NOLOCK) ON PRAV.[IdOrderReport] = ORPQ.IdOrderReport and ORPQ.IdProduct = PRAV.IdProduct                
   LEFT JOIN   [dbo].[OrderReportAttribute] PRAT WITH (NOLOCK) ON PRAT.[Id] = PRAV.[IdOrderReportAttribute]                
   LEFT JOIN   [dbo].[OrderReportAttributeOption] PRO WITH (NOLOCK) ON PRO.[Id] = PRAV.[IdOrderReportAttributeOption]                
   LEFT JOIN.  [dbo].[OrderStatus] OS WITH (NOLOCK) ON PR.[OrderStatus] = OS.Id            
   LEFT JOIN   [dbo].[OrderReportTrazability] ORT WITH (NOLOCK) ON ORT.[IdOrderReport] = PR.OrderReportId AND ORT.[Status] = @IdInitialStatus AND ORT.IdProduct = ORPQ.IdProduct                
 --WHERE  (PRAV.[Id] IS NULL OR PRAT.[Deleted] = 0)                
                
 SELECT *, NULL OrderReportAttributeImage                
 FROM #TempResultOrderReport TROR                
 ORDER BY [OrderReportDateTime], [OrderReportId]                
                
 SELECT *, NULL OrderReportAttributeImage                
 FROM #TempResultProducts                
                
                
 DROP TABLE #TempResultProducts;                
 DROP TABLE #TempResultOrderReportDynamic;                
 DROP TABLE #TempResultOrderReport;                
                  
                
END
