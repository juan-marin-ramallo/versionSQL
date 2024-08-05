/****** Object:  Procedure [dbo].[SaveCatalog]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================  
-- Author:  <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
-- =============================================  
CREATE PROCEDURE [dbo].[SaveCatalog]  
    @Id [sys].[int] OUTPUT,  
 @Name [sys].[varchar](100) = NULL,   
 @IdProducts [sys].[varchar](MAX) = NULL,  
 @IdActions [sys].[varchar](MAX) = NULL,  
 @IdSections [sys].[varchar](MAX) = NULL  -- GU-900 / Cbarbarini
AS  
BEGIN  
  
    SET NOCOUNT ON;  
  
 DECLARE @Exist AS INT  
   
    SELECT @Exist = COUNT(1)  
    FROM dbo.[Catalog]  
    WHERE [Name] = @Name AND Deleted = 0  
  
 IF @Exist = 0  
  BEGIN  
   INSERT INTO dbo.[Catalog] ([Name], Deleted)  
   VALUES (@Name, 0)  
   SELECT @Id = SCOPE_IDENTITY()  
  
   EXEC [dbo].UpdateCatalogProducts @IdCatalog = @Id, @IdProducts = @IdProducts;  
   EXEC [dbo].UpdateCatalogActions @IdCatalog = @Id, @IdActions = @IdActions;  
   EXEC [dbo].UpdateCatalogSections @IdCatalog = @Id, @IdSections = @IdSections;  -- GU-900 / Cbarbarini
  END  
 ELSE   
  SELECT @Id = -1  
  
END
