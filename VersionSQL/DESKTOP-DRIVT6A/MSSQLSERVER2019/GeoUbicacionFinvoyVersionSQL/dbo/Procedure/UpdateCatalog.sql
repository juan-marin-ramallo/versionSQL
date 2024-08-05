/****** Object:  Procedure [dbo].[UpdateCatalog]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================  
-- Author:  <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
-- =============================================  
CREATE PROCEDURE [dbo].[UpdateCatalog]  
    @Result [sys].[int] OUTPUT,  
 @Id [sys].[int],  
 @Name [sys].[varchar](100),  
 @IdProducts [sys].[varchar](MAX) = NULL,  
 @IdActions [sys].[varchar](MAX) = NULL,  
 @IdSections [sys].[varchar](MAX) = NULL  -- GU-900 / Cbarbarini
AS   
BEGIN  
    SET NOCOUNT ON;  
 DECLARE @Now [sys].[datetime]  
 SET @Now = GETUTCDATE()  
   
 IF NOT EXISTS (SELECT 1 FROM [dbo].[Catalog] WHERE [Name] = @Name AND [Deleted] = 0 AND [Id] <> @Id)  
  BEGIN  
   UPDATE [dbo].[Catalog]      
   SET  [Name] = @Name  
   WHERE [Id] = @Id  
  
   SELECT @Result = @Id  
  
   EXEC [dbo].UpdateCatalogProducts @IdCatalog = @Id, @IdProducts = @IdProducts;  
   EXEC [dbo].UpdateCatalogActions @IdCatalog = @Id, @IdActions = @IdActions;  
   EXEC [dbo].UpdateCatalogSections @IdCatalog = @Id, @IdSections = @IdSections;  -- GU-900 / Cbarbarini
  
   -- Productos en punto  
   -- Elimino si tiene acción y no existe más la relación catalogo acción   
   DELETE PP  
   FROM dbo.[ProductPointOfInterest] PP  
    LEFT OUTER JOIN dbo.[CatalogPersonOfInterestPermission] CP ON PP.IdCatalog = CP.IdCatalog  
    LEFT OUTER JOIN dbo.CatalogProduct CPR WITH(NOLOCK) ON PP.IdCatalog = CPR.IdCatalog AND PP.IdProduct = cpr.IdProduct  
   WHERE PP.IdCatalog = @Id AND (CP.Id IS NULL OR CPR.IdCatalog IS NULL)  
  
   -- Inserto Si ya se esta asignado a punto y no existe   
   INSERT INTO dbo.[ProductPointOfInterest]  
   (  
       [IdProduct],  
       [IdPointOfInterest],  
       [TheoricalStock],  
       [TheoricalPrice],  
       [IdCatalog]  
   )  
   SELECT CPR.IdProduct,  CP.IdPointOfInterest, NULL, NULL, CP.IdCatalog  
   FROM dbo.CatalogPointOfInterest CP WITH(NOLOCK)  
    INNER JOIN dbo.CatalogProduct CPR WITH(NOLOCK) ON CP.IdCatalog = CPR.IdCatalog  
    LEFT OUTER JOIN dbo.ProductPointOfInterest PP WITH(NOLOCK) ON CP.IdCatalog = PP.IdCatalog AND CP.IdPointOfInterest = PP.IdPointOfInterest AND CPR.IdProduct = PP.IdProduct  
   WHERE CP.IdCatalog = @Id AND PP.Id IS NULL  
   GROUP BY CPR.IdProduct,  CP.IdPointOfInterest, CP.IdCatalog      
     
   UPDATE pcl  
   SET  pcl.[LastUpdatedDate] = @Now  
   from [dbo].[ProductPointOfInterestChangeLog] pcl  
    INNER JOIN dbo.ProductPointOfInterest ppp ON pcl.IdPointOfInterest = ppp.IdPointOfInterest  
   WHERE ppp.IdCatalog = @Id  
  
   INSERT INTO [dbo].[ProductPointOfInterestChangeLog]  ([IdPointOfInterest], [LastUpdatedDate])  
   SELECT poi.[Id], @Now  
   FROM [dbo].[PointOfInterest] AS poi  
     INNER JOIN dbo.ProductPointOfInterest ppp ON poi.id = ppp.IdPointOfInterest  
   WHERE POI.[Deleted] = 0 AND ppp.IdCatalog = @Id  
     AND NOT EXISTS (SELECT 1 FROM [dbo].[ProductPointOfInterestChangeLog] AS prpoi   
         WHERE prpoi.[IdPointOfInterest] = poi.[Id])  
  END  
 ELSE   
  SELECT @Result = -1  
  
END
