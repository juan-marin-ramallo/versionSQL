/****** Object:  Procedure [dbo].[SyncProductBrandProductCategory]    Committed by VersionSQL https://www.versionsql.com ******/

-- =========================================================================  
-- Author:  Federico Sobral  
-- Create date: 22/09/2023  
-- Description: SP para sincronizar las Marcas y Categorias  
-- Modified by: Juan Marin  
-- Create date: 11/12/2023  
-- Description: GT-498 Error en Categorias repetidas  
-- =========================================================================  
CREATE PROCEDURE [dbo].[SyncProductBrandProductCategory]  
(  
  @SyncType [INT]  
 ,@Data [ProductBrandProductCategoryTableType] READONLY  
 ,@LoggedUserId [INT]  
)  
AS  
BEGIN  
 SET ANSI_WARNINGS  OFF;  
 DECLARE @Add [int] = 0  
 DECLARE @AddUpdate [int] = 1  
 DECLARE @AddUpdateDelete [int] = 2  
  
 DECLARE @ProductBrandProductCategoryTemplate TABLE  
 (  
  [IdProductBrand] int,  
  [ProductBrandIdentifier] varchar(50) NOT NULL,  
  [IdProductCategory] int,  
  [NameCategory] varchar(50) NOT NULL  
 )  
  
 --Agrego los ProductCategory nuevos  
 INSERT INTO dbo.[ProductCategory]([Name],[Description],Deleted,CreatedDate,IdUser)  
 SELECT DISTINCT D.NameCategory,D.NameCategory,0,GETUTCDATE(),@LoggedUserId  
 FROM @Data D  
 LEFT JOIN  
   dbo.[ProductCategory] PC ON PC.[Name] = D.NameCategory AND PC.[Deleted] = 0  
 WHERE PC.[Name] IS NULL   
 
 --Actualizo la columna Order de la tabla ProductCategory para que pueda ser ordenado por orden de insercion GU-2921
DECLARE @LastProductCategoryId [int]
SELECT @LastProductCategoryId = SCOPE_IDENTITY();	
UPDATE	dbo.ProductCategory	SET	[Order] = @LastProductCategoryId WHERE	Id = @LastProductCategoryId
  
 --Agrego las marcas con sus categorias de acuerdo a lo recibido en el template.   
 --Si es categoria nueva el [IdProductCategory] será null  
 INSERT INTO @ProductBrandProductCategoryTemplate  
 SELECT PB.Id, D.ProductBrandIdentifier, PC.Id, D.NameCategory  
 FROM @Data D  
 LEFT OUTER JOIN   
   dbo.[ProductBrand] PB WITH (NOLOCK) ON PB.Identifier = D.ProductBrandIdentifier AND PB.Deleted = 0  
 LEFT OUTER JOIN   
   dbo.[ProductCategory] PC WITH (NOLOCK) ON PC.[Name] = D.NameCategory AND PC.Deleted = 0  
  
  
 -- Delete faltantes  
 IF @AddUpdateDelete <= @SyncType  
 BEGIN  
  DECLARE @ProductBrandProductCategoryNoMatches TABLE  
  (  
   [IdProductBrand] int,  
   [IdProductCategory] int  
  )  
  
  --Obtengo los id de Marca y ProductoCategoria que no fueron enviados en el template  
  INSERT INTO @ProductBrandProductCategoryNoMatches  
  SELECT PBPC.IdProductBrand, PBPC.IdProductCategory   
  FROM dbo.[ProductBrandProductCategory] PBPC WITH (NOLOCK)  
  LEFT OUTER JOIN   
    @ProductBrandProductCategoryTemplate TEMP ON TEMP.IdProductBrand = PBPC.IdProductBrand AND TEMP.IdProductCategory =  PBPC.IdProductCategory  
  WHERE TEMP.IdProductBrand IS NULL AND TEMP.IdProductCategory IS NULL  
    
  
  --Eliminado logico de la tabla [ProductBrand] aquellas Marcas que no se hayan asignado a una Categoria en el Template  
  /*UPDATE PB  
  SET  Deleted = 1  
  FROM dbo.[ProductBrand] PB  
  INNER JOIN  
    @ProductBrandProductCategoryNoMatches NOMATCH ON NOMATCH.IdProductBrand = PB.Id AND PB.Deleted = 0*/  
  
  --Eliminado logico de la tabla [ProductCategory] aquellos Categorias que no se hayan asignado a una Marca en el template   
  /*UPDATE PC  
  SET  Deleted = 1  
  FROM dbo.[ProductCategory] PC  
  INNER JOIN  
    @ProductBrandProductCategoryNoMatches NOMATCH ON NOMATCH.IdProductCategory = PC.Id AND PC.Deleted = 0*/  
      
    
  --Elimino de la tabla ProductBrandProductCategory aquellas marcas y categorias que no fueron enviadas en el template  
  DELETE PBPC  
  FROM ProductBrandProductCategory PBPC  
  INNER JOIN  
    @ProductBrandProductCategoryNoMatches NOMATCH ON NOMATCH.IdProductBrand = PBPC.IdProductBrand AND NOMATCH.IdProductCategory = PBPC.IdProductCategory  
 END  
    
 -- Update ingresados  
 --En base al review del 29-09-2023 el actualizar no haría nada a nivel de la relación entre marca y categoría debido a que no existe un identificador para la relación. Es decir no se tocan las relaciones ya existentes en la BD.   
 /*IF @AddUpdate <= @SyncType  
 BEGIN  
    
 END  
 */  
   
 -- Si solo agrego, Obtengo los repetidos antes de agregar los nuevos   
 -- de lo contrario siempre van a existir  
 -- Esto para mandar a [SynchronizationLogError]  
 SELECT D.ProductBrandIdentifier, D.NameCategory  
 FROM @Data D  
 INNER JOIN   
   @ProductBrandProductCategoryTemplate TEMP  ON TEMP.ProductBrandIdentifier = D.ProductBrandIdentifier AND TEMP.NameCategory = D.NameCategory  
 LEFT OUTER JOIN   
   dbo.ProductBrandProductCategory PBPC WITH (NOLOCK) ON PBPC.IdProductBrand = TEMP.IdProductBrand AND PBPC.IdProductCategory = TEMP.IdProductCategory  
 WHERE   @Add = @SyncType AND PBPC.IdProductBrand IS NOT NULL AND PBPC.IdProductCategory IS NOT NULL  
   
 -- Insert nuevos  
 IF @Add <= @SyncType  
 BEGIN   
  DECLARE @ProductBrandProductCategoryNew TABLE  
  (  
   [IdProductBrand] int,  
   [ProductBrandIdentifier] varchar(50) NOT NULL,  
   [IdProductCategory] int,  
   [NameCategory] varchar(50) NOT NULL  
  )  
      
  --ESCOJO LAS RELACIONES NUEVAS ENTRE MARCAS Y CATEGORIAS CON SUS RESPECTIVOS IDs  
  INSERT INTO @ProductBrandProductCategoryNew  
  SELECT TEMP.IdProductBrand,TEMP.ProductBrandIdentifier,TEMP.IdProductCategory,TEMP.NameCategory   
  FROM @ProductBrandProductCategoryTemplate TEMP  
  FULL OUTER JOIN  
    dbo.ProductBrandProductCategory PBPC WITH (NOLOCK) ON PBPC.IdProductBrand = TEMP.IdProductBrand AND PBPC.IdProductCategory = TEMP.IdProductCategory  
  WHERE PBPC.IdProductBrand IS NULL AND PBPC.IdProductBrand IS NULL AND TEMP.IdProductBrand IS NOT NULL  
  
  --Agrego en ProductBrandProductCategory las marcas y categorias nuevas  
  INSERT INTO dbo.ProductBrandProductCategory(IdProductBrand,IdProductCategory)  
  SELECT IdProductBrand,IdProductCategory   
  FROM @ProductBrandProductCategoryNew  
 END    
  
 -- obtener sin marca o sin categoria para mandar a [SynchronizationLogError]  
 SELECT TEMP.ProductBrandIdentifier, TEMP.NameCategory  
 FROM @ProductBrandProductCategoryTemplate TEMP  
 WHERE TEMP.IdProductBrand IS NULL OR TEMP.IdProductCategory IS NULL  
    
 SET ANSI_WARNINGS  ON;  
  
END
