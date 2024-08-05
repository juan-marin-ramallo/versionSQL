/****** Object:  Procedure [dbo].[SaveProduct]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[SaveProduct]  
  
    @Id [sys].[int] OUTPUT,  
    @Result [sys].[int] OUTPUT,  
 @Name VARCHAR(100) = NULL,   
 @Identifier VARCHAR(50) = NULL,  
    @BarCode VARCHAR(100) = NULL,  
 @Indispensable BIT = 0,  
 @IdProductBrand INT = NULL,  
 @IdProductCategory1 [sys].[int] = NULL,  
 @IdProductCategory2 [sys].[int] = NULL,  
 @IdProductCategory3 [sys].[int] = NULL,  
 @IdProductCategory4 [sys].[int] = NULL,  
 @IdProductCategory5 [sys].[int] = NULL,  
 @ProductImageArray VARBINARY(MAX) = NULL,  
 @MinSalesQuantity [sys].[int] = NULL,  
 @MinUnitsPackage [sys].[int] = NULL,  
 @MaxSalesQuantity [sys].[int] = NULL,  
 @InStock BIT = 0,  
 @TheoricalPrice DECIMAL(18, 3) = 0
   
AS   
BEGIN  
  
    SET NOCOUNT ON;  
  
 --DECLARE @BarCodeDuplicated AS INT = 0  
 --DECLARE @IdentifierDuplicated AS INT = 0  
   
 --SELECT @BarCodeDuplicated = SUM(IIF(BarCode = @BarCode, 1, 0)), @IdentifierDuplicated = SUM(IIF(Identifier = @Identifier, 1, 0))  
 --FROM dbo.Product WITH (NOLOCK)  
 --WHERE (BarCode = @BarCode OR Identifier = @Identifier)  
 --  AND Deleted = 0  
 --GROUP BY BarCode, Identifier  
  
 DECLARE @BarCodeDuplicated AS INT = 0  
   
    SELECT @BarCodeDuplicated = SUM(IIF(BarCode = @BarCode, 1, 0))  
    FROM dbo.Product WITH (NOLOCK)  
    WHERE (BarCode = @BarCode)  
   AND Deleted = 0  
 GROUP BY BarCode  
  
 IF @BarCodeDuplicated = 0 --AND @IdentifierDuplicated = 0  
  BEGIN  
   DECLARE @Now [sys].[datetime]  
   SET @Now = GETUTCDATE()  
  
   INSERT INTO dbo.Product ([Name], Identifier, BarCode, Indispensable, IdProductBrand, ImageArray, Deleted, [MinSalesQuantity], [MinUnitsPackage],[MaxSalesQuantity], [InStock], [TheoricalPrice])  
   VALUES (@Name, @Identifier, @BarCode, @Indispensable, @IdProductBrand, @ProductImageArray, 0,@MinSalesQuantity, @MinUnitsPackage, @MaxSalesQuantity,@InStock,@TheoricalPrice)  
   SET @Id = SCOPE_IDENTITY()  
   SET @Result = 0  
  
   IF @IdProductCategory1 IS NOT NULL  
   BEGIN  
    INSERT INTO [dbo].[ProductCategoryList]([IdProduct], [IdProductCategory])  
    (SELECT  @Id AS IdProduct, PC.[Id] AS IdProductCategory  
    FROM  dbo.[ProductCategory] PC WITH (NOLOCK)  
    WHERE  PC.[Deleted] = 0 AND @IdProductCategory1 IS NOT NULL AND PC.[Id] = @IdProductCategory1)  
   END  
  
   IF @IdProductCategory2 IS NOT NULL  
   BEGIN  
    INSERT INTO [dbo].[ProductCategoryList]([IdProduct], [IdProductCategory])  
    (SELECT  @Id AS IdProduct, PC.[Id] AS IdProductCategory  
    FROM  dbo.[ProductCategory] PC WITH (NOLOCK)  
    WHERE  PC.[Deleted] = 0 AND @IdProductCategory2 IS NOT NULL AND PC.[Id] = @IdProductCategory2)  
   END  
  
   IF @IdProductCategory3 IS NOT NULL  
   BEGIN  
    INSERT INTO [dbo].[ProductCategoryList]([IdProduct], [IdProductCategory])  
    (SELECT  @Id AS IdProduct, PC.[Id] AS IdProductCategory  
    FROM  dbo.[ProductCategory] PC WITH (NOLOCK)  
    WHERE  PC.[Deleted] = 0 AND @IdProductCategory3 IS NOT NULL AND PC.[Id] = @IdProductCategory3)  
   END  
  
   IF @IdProductCategory4 IS NOT NULL  
   BEGIN  
    INSERT INTO [dbo].[ProductCategoryList]([IdProduct], [IdProductCategory])  
    (SELECT  @Id AS IdProduct, PC.[Id] AS IdProductCategory  
    FROM  dbo.[ProductCategory] PC WITH (NOLOCK)  
    WHERE  PC.[Deleted] = 0 AND @IdProductCategory4 IS NOT NULL AND PC.[Id] = @IdProductCategory4)  
   END  
  
   IF @IdProductCategory5 IS NOT NULL  
   BEGIN  
    INSERT INTO [dbo].[ProductCategoryList]([IdProduct], [IdProductCategory])  
    (SELECT  @Id AS IdProduct, PC.[Id] AS IdProductCategory  
    FROM  dbo.[ProductCategory] PC WITH (NOLOCK)  
    WHERE  PC.[Deleted] = 0 AND @IdProductCategory5 IS NOT NULL AND PC.[Id] = @IdProductCategory5)  
   END  
  
   UPDATE [dbo].[ProductPointOfInterestChangeLog]   
   SET  [LastUpdatedDate] = @Now  
  
   INSERT INTO [dbo].[ProductPointOfInterestChangeLog]  ([IdPointOfInterest], [LastUpdatedDate])  
   SELECT poi.[Id], @Now  
   FROM [dbo].[PointOfInterest] AS poi WITH (NOLOCK)  
   WHERE POI.[Deleted] = 0  
     AND NOT EXISTS (SELECT 1 FROM [dbo].[ProductPointOfInterestChangeLog] AS prpoi WITH (NOLOCK)  
         WHERE prpoi.[IdPointOfInterest] = poi.[Id])  
  
  END  
 ELSE   
 BEGIN  
  SET @Result = 0  
  --IF @IdentifierDuplicated > 0  
  --BEGIN  
  -- SET @Result = @Result + 1  
  --END  
  IF @BarCodeDuplicated > 0  
  BEGIN  
   SET @Result = @Result + 2  
  END  
 END  
  
END
