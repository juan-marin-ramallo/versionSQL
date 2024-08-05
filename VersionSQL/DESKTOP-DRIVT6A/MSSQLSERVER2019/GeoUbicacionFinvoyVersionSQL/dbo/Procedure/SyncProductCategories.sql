/****** Object:  Procedure [dbo].[SyncProductCategories]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================  
-- Author:  Juan Marin  
-- Create date: 08/02/2024  
-- Description: SP para sincronizar las Categorias de Productos  
-- =============================================  
CREATE PROCEDURE [dbo].[SyncProductCategories]  
(  
  @SyncType [INT]  
 ,@Data [ProductCategoryTableType] READONLY  
)  
AS  
BEGIN  
 SET ANSI_WARNINGS  OFF;  
  
 DECLARE @Now [sys].[datetime]  
 SET @Now = GETUTCDATE()  
  
 DECLARE @Add [int] = 0  
 DECLARE @AddUpdate [int] = 1  
 DECLARE @AddUpdateDelete [int] = 2
 
 DECLARE @OrderByName AS [sys].[bit]    
 SET @OrderByName = (SELECT [Value] FROM dbo.[Configuration] WITH (NOLOCK) WHERE IdConfigurationGroup = 2 and [Name] = 'OrderProductCategory')

 DECLARE @numberProductCategoriesUpdated [int] = 0  
  
 -- Update ingresados  
 IF @AddUpdate <= @SyncType  
 BEGIN  
  UPDATE PR  
  SET  
		PR.[Name] = P.[Name]  
		,PR.[Description] = P.[Description]  
		,PR.[EditedDate] = @Now
		,PR.[Order] = IIF(@OrderByName = 1, PR.[Order], IIF(P.[Order] IS NULL, PR.[Order], P.[Order])) --Valido que si es la configuracion encendida, se mantenga el valor que tiene, si no esta prendida y la del template es vacia tambien se mantiene el valor. Sino agarro el del template
  FROM	[dbo].[ProductCategory] PR
  INNER JOIN 
		@Data AS P ON PR.[Name] = P.[Name] AND PR.[IdUser] = P.[IdUser]
  WHERE PR.[Deleted] = 0  

  SELECT @numberProductCategoriesUpdated = @@ROWCOUNT
END 
  
 -- Delete faltantes  
 IF @AddUpdateDelete <= @SyncType  
 BEGIN   
  UPDATE PR  
  SET	PR.[Deleted] = 1  
  FROM	[dbo].[ProductCategory] PR
  LEFT OUTER JOIN 
		@Data AS P ON PR.[Name] = P.[Name] AND PR.[IdUser] = P.[IdUser]  

  SELECT @numberProductCategoriesUpdated = @@ROWCOUNT
		
  DELETE	PCL 
  FROM	[dbo].[ProductCategoryList] PCL 
  INNER JOIN
		[dbo].[ProductCategory] PR ON PR.Id = PCL.IdProductCategory
  LEFT OUTER JOIN 
		@Data AS P ON PR.[Name] = P.[Name] AND PR.[IdUser] = P.[IdUser]
		
  DELETE PBPC 
  FROM	[dbo].[ProductBrandProductCategory] PBPC 
  INNER JOIN
		[dbo].[ProductCategory] PR ON PR.Id = PBPC.IdProductCategory
  LEFT OUTER JOIN 
		@Data AS P ON PR.[Name] = P.[Name] AND PR.[IdUser] = P.[IdUser]
 END  


 -- Obtengo los repetidos antes de agregar los nuevos  
 -- de lo contrario siempre van a existir   
 SELECT P.[Name],P.[Description],IIF(@OrderByName = 1, NULL, P.[Order]) 
 FROM @Data P  
   LEFT OUTER JOIN [dbo].[ProductCategory] PR WITH (NOLOCK) ON PR.[Name] = P.[Name] AND PR.[IdUser] = P.[IdUser] AND PR.[Deleted] = 0
 WHERE   (@Add = @SyncType AND (PR.[Id] IS NOT NULL))  
  
 -- Insert nuevos  
 IF @Add <= @SyncType  
 BEGIN   
	  INSERT INTO [dbo].[ProductCategory]([Name], [Description], [Deleted], [CreatedDate], [EditedDate], [IdUser],[Order])
	  SELECT  P.[Name], P.[Description], 0, @Now, @Now, P.[IdUser], P.[Order]
	  FROM    @Data P  
		LEFT OUTER JOIN [dbo].[ProductCategory] PR WITH (NOLOCK) ON PR.[Name] = P.[Name] AND PR.[IdUser] = P.[IdUser] AND PR.[Deleted] = 0
	  WHERE   PR.[Id] IS NULL    

	  UPDATE PR  
	  SET	 PR.[Order] = PR.[Id]  			
	  FROM	[dbo].[ProductCategory] PR
	  INNER JOIN 
			@Data AS P ON PR.[Name] = P.[Name] AND PR.[IdUser] = P.[IdUser]
	  WHERE PR.[Deleted] = 0  AND PR.[Order] IS NULL
 END  

 IF @numberProductCategoriesUpdated > 0
 BEGIN   
	 --Tengo que actualizar el change log para que se vea reflejado en los disposiivos  
	 UPDATE [dbo].[ProductPointOfInterestChangeLog]   
	 SET  [LastUpdatedDate] = @Now  
 END 

 SET ANSI_WARNINGS  ON;  
  
END
