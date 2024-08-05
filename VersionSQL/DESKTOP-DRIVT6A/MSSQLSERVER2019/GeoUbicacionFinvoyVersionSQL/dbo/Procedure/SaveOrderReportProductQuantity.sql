/****** Object:  Procedure [dbo].[SaveOrderReportProductQuantity]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================    
-- Author:<Author,,Name>    
-- Create date: <Create Date,,>    
-- Description: <Description,,>    
-- =============================================    
CREATE PROCEDURE [dbo].[SaveOrderReportProductQuantity]    
 @IdOrderReport [sys].[int]    
 ,@Quantity [sys].[int]    
 ,@IdProduct [sys].[int]    
 ,@IsModification [sys].[bit] = 0    
 ,@IdPersonOfInterest [sys].[int] = 0  
 ,@Price [sys].[decimal](18, 3) = 0  
AS    
BEGIN    
 IF NOT EXISTS(SELECT 1 FROM [dbo].[OrderReportProductQuantity] WITH (NOLOCK) WHERE [IdOrderReport] = @IdOrderReport AND [IdProduct] = @IdProduct)    
 BEGIN    
  INSERT INTO [dbo].[OrderReportProductQuantity] ([IdOrderReport], [IdProduct], [Quantity])    
  VALUES (@IdOrderReport,@IdProduct, @Quantity)    
 END    
 ELSE BEGIN    
  UPDATE [dbo].[OrderReportProductQuantity] SET [Quantity] = @Quantity WHERE [IdOrderReport] = @IdOrderReport AND [IdProduct] = @IdProduct    
 END    
    
 --Actualizo totales del pedido    
 UPDATE [dbo].[OrderReport]    
 SET[OrderTotalQuantity] = [OrderTotalQuantity] + @Quantity    
 WHERE [Id] = @IdOrderReport    
    
 DECLARE @ProductName VARCHAR(100), @ProductPrice DECIMAL(18, 3), @OrderDateTime DATETIME, @ReceivedDateTime DATETIME, @Status SMALLINT;    
 SELECT @ProductName = [Name], @ProductPrice = [TheoricalPrice] FROM [Product] WHERE Id = @IdProduct    
 SELECT @OrderDateTime = [OrderDateTime], @ReceivedDateTime = CASE WHEN @IsModification = 0 THEN [ReceivedDateTime] ELSE GETUTCDATE() END, @Status = [Status] FROM [dbo].[OrderReport] WHERE [Id] = @IdOrderReport    
    
 IF EXISTS(SELECT 1 FROM [dbo].[Configuration] WHERE [Description] = 'Seguimiento de Pedidos' AND [Value] = 1)    
 BEGIN    
  INSERT INTO [dbo].[OrderReportTrazability] ([IdOrderReport], [OrderDateTime], [ReceivedDateTime], [Status], [IdProduct], [ProductName], [ProductPrice], [Quantity], [IsModification], [IdPersonOfInterest])    
  VALUES(@IdOrderReport, @OrderDateTime, @ReceivedDateTime, @Status, @IdProduct, @ProductName, CASE WHEN @Price > 0 THEN @Price ELSE @ProductPrice END, @Quantity, @IsModification, @IdPersonOfInterest)    
 END    
END
