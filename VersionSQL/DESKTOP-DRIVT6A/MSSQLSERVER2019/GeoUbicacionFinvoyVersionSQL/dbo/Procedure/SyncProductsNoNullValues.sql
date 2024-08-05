/****** Object:  Procedure [dbo].[SyncProductsNoNullValues]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================  
-- Author: Cristian Barbarini  
-- Create date: 26/04/2022 16:00:00  
-- Description: SP para sincronizar los Productos sin actualizar parámetros nulos  
-- =============================================  
CREATE PROCEDURE [dbo].[SyncProductsNoNullValues]  
(  
 @Data ProductNullValuesTableType READONLY  
)  
AS  
BEGIN  
 SET ANSI_WARNINGS OFF;  
  
 UPDATE PR SET PR.Identifier = P.Id  
  , PR.Name = P.Name  
  , PR.BarCode = P.BarCode  
  , PR.ImageArray = IIF(P.ImageArray IS NULL, PR.ImageArray, ISNULL(P.ImageArray, PR.ImageArray))  
  , PR.BoxUnits = ISNULL(P.BoxUnits, PR.BoxUnits)  
  , PR.BoxBarCode = ISNULL(P.BoxBarCode, PR.BoxBarCode)  
  , PR.Indispensable = ISNULL(P.Indispensable, PR.Indispensable)  
  , PR.IdProductBrand = ISNULL(PB.Id, PR.IdProductBrand)  
  , PR.MinSalesQuantity = ISNULL(P.MinSalesQuantity, PR.MinSalesQuantity)  
  , PR.MinUnitsPackage = ISNULL(P.MinUnitsPackage, PR.MinUnitsPackage)  
  , PR.MaxSalesQuantity = ISNULL(P.MaxSalesQuantity, PR.MaxSalesQuantity)  
  , PR.InStock = ISNULL(P.InStock, PR.InStock)  
 FROM Product PR WITH (NOLOCK)  
 INNER JOIN @Data AS P ON PR.BarCode = P.BarCode AND PR.Deleted = 0  
 LEFT OUTER JOIN dbo.ProductBrand PB ON P.BrandIdentifier = PB.Identifier AND PB.Deleted = 0  
  
 INSERT INTO Product(Name, BarCode, Identifier, ImageArray, BoxUnits, BoxBarCode,  
  Indispensable, IdProductBrand, Deleted,MinSalesQuantity, MinUnitsPackage,MaxSalesQuantity, InStock)  
 SELECT P.Name, P.BarCode, P.Id, P.ImageArray, P.BoxUnits, P.BoxBarCode, P.Indispensable, PB.Id, 0,  
  P.MinSalesQuantity, P.MinUnitsPackage, P.MaxSalesQuantity, P.InStock  
 FROM @Data P  
 LEFT OUTER JOIN dbo.ProductBrand PB WITH (NOLOCK) ON P.BrandIdentifier = PB.Identifier AND PB.Deleted = 0  
 WHERE NOT EXISTS (SELECT 1 FROM Product PR WITH (NOLOCK) WHERE P.BarCode = PR.BarCode AND PR.Deleted = 0)  
 
 DECLARE @IdAux sys.INT  
 DECLARE @BarCodeAux sys.VARCHAR(100)  
 DECLARE cur CURSOR FOR SELECT PROD.Id, PROD.BarCode  
  FROM Product PROD WITH (NOLOCK)  
  INNER JOIN @Data P ON PROD.BarCode = P.BarCode AND PROD.Deleted = 0  
  
 OPEN cur  
 FETCH NEXT FROM cur INTO @IdAux, @BarCodeAux  
 WHILE @@FETCH_STATUS = 0  
 BEGIN  
  DELETE FROM ProductCategoryList WHERE IdProduct = @IdAux  
  
  INSERT INTO ProductCategoryList(IdProduct, IdProductCategory)  
  (SELECT @IdAux AS IdProduct, PC.Id AS IdProductCategory  
  FROM @Data P  
  LEFT JOIN ProductCategory PC WITH (NOLOCK) ON P.ProductCategory1 = PC.Name  
  WHERE PC.Id IS NOT NULL AND PC.Deleted = 0 AND P.BarCode = @BarCodeAux)  
   
  INSERT INTO ProductCategoryList(IdProduct, IdProductCategory)  
  (SELECT @IdAux AS IdProduct, PC.Id AS IdProductCategory  
  FROM @Data P  
  LEFT JOIN ProductCategory PC WITH (NOLOCK) ON P.ProductCategory2 = PC.Name  
  WHERE PC.Id IS NOT NULL AND PC.Deleted = 0 AND P.BarCode = @BarCodeAux)  
  
  INSERT INTO ProductCategoryList(IdProduct, IdProductCategory)  
  (SELECT @IdAux AS IdProduct, PC.Id AS IdProductCategory  
  FROM @Data P  
  LEFT JOIN ProductCategory PC WITH (NOLOCK) ON P.ProductCategory3 = PC.Name  
  WHERE PC.Id IS NOT NULL AND PC.Deleted = 0 AND P.BarCode = @BarCodeAux)  
  
  INSERT INTO ProductCategoryList(IdProduct, IdProductCategory)  
  (SELECT @IdAux AS IdProduct, PC.Id AS IdProductCategory  
  FROM @Data P  
  LEFT JOIN ProductCategory PC WITH (NOLOCK) ON P.ProductCategory4 = PC.Name  
  WHERE PC.Id IS NOT NULL AND PC.Deleted = 0 AND P.BarCode = @BarCodeAux)  
  
  INSERT INTO ProductCategoryList(IdProduct, IdProductCategory)  
  (SELECT @IdAux AS IdProduct, PC.Id AS IdProductCategory  
  FROM @Data P  
  LEFT JOIN ProductCategory PC WITH (NOLOCK) ON P.ProductCategory5 = PC.Name  
  WHERE PC.Id IS NOT NULL AND PC.Deleted = 0 AND P.BarCode = @BarCodeAux)  
  
  FETCH NEXT FROM cur INTO @IdAux, @BarCodeAux  
 END  
 CLOSE cur  
 DEALLOCATE cur  
  
 DECLARE @Now sys.datetime  
 SET @Now = GETUTCDATE()  
  
 UPDATE ProductPointOfInterestChangeLog   
 SET LastUpdatedDate = @Now  
  
 INSERT INTO ProductPointOfInterestChangeLog(IdPointOfInterest, LastUpdatedDate)  
 SELECT poi.Id, @Now  
 FROM PointOfInterest AS poi WITH (NOLOCK)  
 WHERE POI.Deleted = 0  
  AND NOT EXISTS (SELECT 1 FROM ProductPointOfInterestChangeLog AS prpoi WITH (NOLOCK) WHERE prpoi.IdPointOfInterest = poi.Id)  
  
 SET ANSI_WARNINGS ON;  
END
