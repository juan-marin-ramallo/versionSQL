/****** Object:  Procedure [dbo].[SyncProducts]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================  
-- Author:  Federico Sobral  
-- Create date: 20/04/2015  
-- Description: SP para sincronizar los Productos  
-- Change: Matias Corso - 14/02/2017 - Agrego varias categorías a producto  
-- =============================================  
CREATE PROCEDURE [dbo].[SyncProducts]  
(  
  @SyncType [INT]  
 ,@Data [ProductTableType] READONLY  
)  
AS  
BEGIN  
 SET ANSI_WARNINGS  OFF;  
  
 DECLARE @Now [sys].[datetime]  
 SET @Now = GETUTCDATE()  
  
 DECLARE @Add [int] = 0  
 DECLARE @AddUpdate [int] = 1  
 DECLARE @AddUpdateDelete [int] = 2  
  
 -- Update ingresados  
 IF @AddUpdate <= @SyncType  
 BEGIN  
  UPDATE PR  
  SET  PR.[Identifier] = P.[Id]  
    ,PR.[ImageArray] = IIF(P.[ImageArray] IS NULL, PR.[ImageArray], P.[ImageArray])  
    ,PR.[Name] = P.[Name]  
    ,PR.[BarCode] = P.[BarCode]  
    ,PR.[BoxUnits] = P.[BoxUnits]  
    ,PR.[BoxBarCode] = P.[BoxBarCode]  
    ,PR.[Indispensable] = P.[Indispensable]  
    ,PR.[IdProductBrand] = b.[Id]  
    ,PR.[MinSalesQuantity] = P.[MinSalesQuantity]  
    ,PR.[MinUnitsPackage] = P.[MinUnitsPackage]  
    ,PR.[MaxSalesQuantity] = P.[MaxSalesQuantity]  
    ,PR.[TheoricalPrice] = P.[TheoricalPrice]  
    ,PR.[InStock] = P.[InStock]  
  
  FROM [dbo].[Product] PR WITH (NOLOCK)  
    INNER JOIN @Data AS P ON PR.[BarCode] = P.[BarCode]  
    LEFT OUTER JOIN dbo.[ProductBrand] b ON P.BrandIdentifier = b.Identifier AND b.Deleted = 0  
  WHERE PR.[Deleted] = 0  
  
  --Necesito los ids de los productos ingresados para asociarlos a las categorias.  
  DECLARE @IdAux2 [sys].[int]  
  DECLARE @BarCodeAux2 [sys].[varchar](100)  
  DECLARE cur2 CURSOR FOR SELECT PROD.[Id], PROD.[BarCode]  
        FROM [dbo].[Product] PROD WITH (NOLOCK)  
        INNER JOIN @Data P ON PROD.[BarCode] = P.[BarCode]   
        WHERE PROD.[Deleted] = 0  
      
  OPEN cur2  
  FETCH NEXT FROM cur2 INTO @IdAux2, @BarCodeAux2  
  WHILE @@FETCH_STATUS = 0   
  BEGIN  
     
   --Borro todas las asociaciones con categorias del producto y las vuelvo a ingresar.  
   DELETE FROM [dbo].[ProductCategoryList]  
   WHERE  [IdProduct] = @IdAux2  
  
   --Vuelvo a INSERTAR LAS NUEVAS  
   INSERT INTO [dbo].[ProductCategoryList]([IdProduct], [IdProductCategory])  
   (SELECT  @IdAux2 AS IdProduct, PC.[Id] AS [IdProductCategory]  
   FROM  @Data P  
   LEFT JOIN [dbo].[ProductCategory] PC WITH (NOLOCK) ON P.[ProductCategory1] = PC.[Name]  
   WHERE  PC.[Id] IS NOT NULL AND PC.[Deleted] = 0 AND P.[BarCode] = @BarCodeAux2)  
     
   INSERT INTO [dbo].[ProductCategoryList]([IdProduct], [IdProductCategory])  
   (SELECT  @IdAux2 AS IdProduct, PC.[Id] AS [IdProductCategory]  
   FROM  @Data P  
   LEFT JOIN [dbo].[ProductCategory] PC WITH (NOLOCK) ON P.[ProductCategory2] = PC.[Name]  
   WHERE  PC.[Id] IS NOT NULL AND PC.[Deleted] = 0 AND P.[BarCode] = @BarCodeAux2)  
  
   INSERT INTO [dbo].[ProductCategoryList]([IdProduct], [IdProductCategory])  
   (SELECT  @IdAux2 AS IdProduct, PC.[Id] AS [IdProductCategory]  
   FROM  @Data P  
   LEFT JOIN [dbo].[ProductCategory] PC WITH (NOLOCK) ON P.[ProductCategory3] = PC.[Name]  
   WHERE  PC.[Id] IS NOT NULL AND PC.[Deleted] = 0 AND P.[BarCode] = @BarCodeAux2)  
  
   INSERT INTO [dbo].[ProductCategoryList]([IdProduct], [IdProductCategory])  
   (SELECT  @IdAux2 AS IdProduct, PC.[Id] AS [IdProductCategory]  
   FROM  @Data P  
   LEFT JOIN [dbo].[ProductCategory] PC WITH (NOLOCK) ON P.[ProductCategory4] = PC.[Name]  
   WHERE  PC.[Id] IS NOT NULL AND PC.[Deleted] = 0 AND P.[BarCode] = @BarCodeAux2)  
  
   INSERT INTO [dbo].[ProductCategoryList]([IdProduct], [IdProductCategory])  
   (SELECT  @IdAux2 AS IdProduct, PC.[Id] AS [IdProductCategory]  
   FROM  @Data P  
   LEFT JOIN [dbo].[ProductCategory] PC WITH (NOLOCK) ON P.[ProductCategory5] = PC.[Name]  
   WHERE  PC.[Id] IS NOT NULL AND PC.[Deleted] = 0 AND P.[BarCode] = @BarCodeAux2)  
  
   FETCH NEXT FROM cur2 INTO @IdAux2, @BarCodeAux2  
  END  
  
  CLOSE cur2  
  DEALLOCATE cur2  
 END   
     
 -- Delete faltantes  
 IF @AddUpdateDelete <= @SyncType  
 BEGIN   
  UPDATE PR  
  SET  PR.[Deleted] = 1  
  FROM [dbo].[Product] PR WITH (NOLOCK)  
    LEFT OUTER JOIN @Data AS P ON PR.[BarCode] = P.[BarCode]  
  WHERE P.[Id] IS NULL  
  
  DELETE FROM [dbo].[ProductPointOfInterest]  
  WHERE IdProduct NOT IN (SELECT [Id] FROM [dbo].[Product] Where [Deleted] = 0)   
  
  DELETE   
  FROM [dbo].[CatalogProduct]  
  WHERE [IdProduct] NOT IN (SELECT [Id] FROM [dbo].[Product] Where [Deleted] = 0)   
  
 END  
  
 -- Si solo agrego Obtengo los repetidos antes de agregar los nuevos  
 -- de lo contrario siempre van a existir   
 SELECT P.[Id],P.[ImageArray],P.[Name],P.[BarCode],P.[BoxUnits],P.[BoxBarCode],IIF(PR.[Id] IS NOT NULL, 1, 0)  
 FROM @Data P  
   LEFT OUTER JOIN [dbo].[Product] PR WITH (NOLOCK) ON PR.[BarCode] = P.[BarCode] AND PR.[Deleted] = 0  
 WHERE   (@Add = @SyncType AND (PR.[Id] IS NOT NULL))  
  
 -- Insert nuevos  
 IF @Add <= @SyncType  
 BEGIN   
  INSERT INTO [dbo].[Product]([Name], [BarCode], [Identifier], [ImageArray], [BoxUnits], [BoxBarCode],  
     [Indispensable], [IdProductBrand], [Deleted],[MinSalesQuantity], [MinUnitsPackage],[MaxSalesQuantity], [InStock], [TheoricalPrice])  
  SELECT  P.[Name], P.[BarCode], P.[Id], P.[ImageArray], P.[BoxUnits], P.[BoxBarCode], P.[Indispensable], b.Id, 0,   
    P.[MinSalesQuantity], P.[MinUnitsPackage], P.[MaxSalesQuantity], P.[InStock], P.[TheoricalPrice]  
  FROM    @Data P  
    LEFT OUTER JOIN [dbo].[Product] PR WITH (NOLOCK) ON PR.[BarCode] = P.[BarCode] AND PR.[Deleted] = 0  
    LEFT OUTER JOIN dbo.[ProductBrand] b ON P.BrandIdentifier = b.Identifier AND b.Deleted = 0  
  WHERE   PR.[Id] IS NULL  
  
  --Necesito los ids de los productos ingresados para asociarlos a las categorias.  
  DECLARE @IdAux [sys].[int]  
  DECLARE @BarCodeAux [sys].[varchar](100)  
  DECLARE cur CURSOR FOR SELECT PROD.[Id], PROD.[BarCode]  
        FROM [dbo].[Product] PROD WITH (NOLOCK)  
        INNER JOIN @Data P ON PROD.[BarCode] = P.[BarCode]   
        WHERE PROD.[Deleted] = 0  
      
  OPEN cur  
  FETCH NEXT FROM cur INTO @IdAux, @BarCodeAux  
  WHILE @@FETCH_STATUS = 0   
  BEGIN  
  
   INSERT INTO [dbo].[ProductCategoryList]([IdProduct], [IdProductCategory])  
   (SELECT  @IdAux AS IdProduct, PC.[Id] AS [IdProductCategory]  
   FROM  @Data P  
   LEFT JOIN [dbo].[ProductCategory] PC WITH (NOLOCK) ON P.[ProductCategory1] = PC.[Name]  
   LEFT JOIN [dbo].[ProductCategoryList] PCL WITH (NOLOCK) ON PC.[Id] = PCL.[IdProductCategory] AND PCL.[IdProduct] = @IdAux  
   WHERE  PC.[Id] IS NOT NULL AND PCL.[Id] IS NULL AND PC.[Deleted] = 0 AND P.[BarCode] = @BarCodeAux)  
     
   INSERT INTO [dbo].[ProductCategoryList]([IdProduct], [IdProductCategory])  
   (SELECT  @IdAux AS IdProduct, PC.[Id] AS [IdProductCategory]  
   FROM  @Data P  
   LEFT JOIN [dbo].[ProductCategory] PC WITH (NOLOCK) ON P.[ProductCategory2] = PC.[Name]  
   LEFT JOIN [dbo].[ProductCategoryList] PCL WITH (NOLOCK) ON PC.[Id] = PCL.[IdProductCategory] AND PCL.[IdProduct] = @IdAux  
   WHERE  PC.[Id] IS NOT NULL AND PCL.[Id] IS NULL AND PC.[Deleted] = 0 AND P.[BarCode] = @BarCodeAux)  
  
   INSERT INTO [dbo].[ProductCategoryList]([IdProduct], [IdProductCategory])  
   (SELECT  @IdAux AS IdProduct, PC.[Id] AS [IdProductCategory]  
   FROM  @Data P  
   LEFT JOIN [dbo].[ProductCategory] PC WITH (NOLOCK) ON P.[ProductCategory3] = PC.[Name]  
   LEFT JOIN [dbo].[ProductCategoryList] PCL WITH (NOLOCK) ON PC.[Id] = PCL.[IdProductCategory] AND PCL.[IdProduct] = @IdAux  
   WHERE  PC.[Id] IS NOT NULL AND PCL.[Id] IS NULL AND PC.[Deleted] = 0 AND P.[BarCode] = @BarCodeAux)  
  
   INSERT INTO [dbo].[ProductCategoryList]([IdProduct], [IdProductCategory])  
   (SELECT  @IdAux AS IdProduct, PC.[Id] AS [IdProductCategory]  
   FROM  @Data P  
   LEFT JOIN [dbo].[ProductCategory] PC WITH (NOLOCK) ON P.[ProductCategory4] = PC.[Name]  
   LEFT JOIN [dbo].[ProductCategoryList] PCL WITH (NOLOCK) ON PC.[Id] = PCL.[IdProductCategory] AND PCL.[IdProduct] = @IdAux  
   WHERE  PC.[Id] IS NOT NULL AND PCL.[Id] IS NULL AND PC.[Deleted] = 0 AND P.[BarCode] = @BarCodeAux)  
  
   INSERT INTO [dbo].[ProductCategoryList]([IdProduct], [IdProductCategory])  
   (SELECT  @IdAux AS IdProduct, PC.[Id] AS [IdProductCategory]  
   FROM  @Data P  
   LEFT JOIN [dbo].[ProductCategory] PC WITH (NOLOCK) ON P.[ProductCategory5] = PC.[Name]  
   LEFT JOIN [dbo].[ProductCategoryList] PCL WITH (NOLOCK) ON PC.[Id] = PCL.[IdProductCategory] AND PCL.[IdProduct] = @IdAux  
   WHERE  PC.[Id] IS NOT NULL AND PCL.[Id] IS NULL AND PC.[Deleted] = 0 AND P.[BarCode] = @BarCodeAux)  
  
   FETCH NEXT FROM cur INTO @IdAux, @BarCodeAux  
  END  
  
  CLOSE cur      
  DEALLOCATE cur  
  
 END  
  
 --Tengo que actualizar el change log para que se vea reflejado en los disposiivos  
 UPDATE [dbo].[ProductPointOfInterestChangeLog]   
 SET  [LastUpdatedDate] = @Now  
  
 INSERT INTO [dbo].[ProductPointOfInterestChangeLog]  ([IdPointOfInterest], [LastUpdatedDate])  
 SELECT poi.[Id], @Now  
 FROM [dbo].[PointOfInterest] AS poi WITH (NOLOCK)  
 WHERE POI.[Deleted] = 0  
   AND NOT EXISTS (SELECT 1 FROM [dbo].[ProductPointOfInterestChangeLog] AS prpoi WITH (NOLOCK)  
       WHERE prpoi.[IdPointOfInterest] = poi.[Id])  
  
 SET ANSI_WARNINGS  ON;  
  
END
