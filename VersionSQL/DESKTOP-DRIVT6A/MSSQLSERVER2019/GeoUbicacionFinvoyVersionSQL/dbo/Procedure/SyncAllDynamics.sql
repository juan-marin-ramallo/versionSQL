/****** Object:  Procedure [dbo].[SyncAllDynamics]    Committed by VersionSQL https://www.versionsql.com ******/

-- ============================================        
-- Author:  JUAN MARIN        
-- Create date: 07/11/2023        
-- Description: SP para sincronizar las Dinamicas        
-- ==============================================        
-- Modified by: JUAN MARIN      
-- Modified date: 15/12/2023      
-- Description: Optimizar carga del template de dinamicas reportado en GT-502      
-- ==============================================        
-- Modified by: JUAN MARIN      
-- Modified date: 22/12/2023      
-- Description:  GT-516: Se quita el LoggedUserId debido a que un usuario puede crear Dinamicas con formularios de otros usuarios  
-- ==============================================  
CREATE PROCEDURE [dbo].[SyncAllDynamics]            
(            
  @SyncType [int]            
 ,@DataDynamic [DynamicTableType] READONLY            
 ,@DataDynamicProductPointOfInterest [DynamicProductPointOfInterestTableType] READONLY            
 ,@DataDynamicReference [DynamicReferenceTableType] READONLY            
 ,@DataDynamicReferenceValue [DynamicReferenceValueTableType] READONLY            
 ,@DataDynamicPersonOfInterest [DynamicPersonOfInterestTableType] READONLY            
 ,@LoggedUserId [INT]            
)            
AS            
BEGIN            
 SET ANSI_WARNINGS  OFF;             
 DECLARE @Add [int] = 0            
             
 -- Insert nuevos            
 IF @Add <= @SyncType            
 BEGIN             
  DECLARE @IdDynamicAux INT            
  DECLARE @DynamicAux VARCHAR(100)            
  DECLARE @FormAux VARCHAR(100)            
  DECLARE @StartDate DATETIME            
  DECLARE @EndDate DATETIME       
            
  CREATE TABLE #Dynamic             
  (            
   [DynamicId] [int] NULL,            
   [Dynamic] [varchar](100) NULL,            
   [FormPlusId] [int]  NULL,            
   [FormId] [int]  NULL,            
   [Form] [varchar](100) NULL,            
   [StartDate] datetime NOT NULL,            
   [EndDate] datetime NULL,            
   [IdUser] int NOT NULL
  )            
              
  CREATE TABLE #DynamicPersonOfInterest             
  (            
   [DynamicPersonOfInterestId] [int],             
   [PersonOfInterestId] [int]  NULL,            
   [PersonOfInterestIdentifier] [varchar](20) NOT NULL,            
   [DynamicId] [int] NULL,            
   [Dynamic] [varchar](100) NULL            
  )            
                
              
  --Dynamic            
  INSERT dbo.[Dynamic]([Name],[IdFormPlus],[StartDate],[EndDate],[Disabled],[Deleted],[IdUser])            
  OUTPUT inserted.Id, inserted.[Name], inserted.IdFormPlus, NULL, NULL,inserted.StartDate,inserted.EndDate,@LoggedUserId INTO #Dynamic            
  SELECT  DISTINCT D.[Dynamic], FP.Id, D.StartDate, D.EndDate, 0, 0,@LoggedUserId            
  FROM  @DataDynamic D            
  INNER JOIN [dbo].[Form] F WITH (NOLOCK) ON F.[Name] = D.[Form] AND F.[Deleted] = 0 --AND F.IdUser = @LoggedUserId            
  INNER JOIN [dbo].[FormPlus] FP WITH (NOLOCK) ON FP.[IdForm] = F.[Id] AND FP.[Deleted] = 0            
            
  UPDATE D             
  SET  D.FormId = F.Id,            
    D.Form = F.[Name]            
  FROM #Dynamic D               
   INNER JOIN [dbo].[FormPlus] FP WITH (NOLOCK) ON FP.[Id] = D.[FormPlusId] AND FP.[Deleted] = 0             
   INNER JOIN [dbo].[Form] F WITH (NOLOCK) ON F.[Id] = FP.[IdForm] AND F.[Deleted] = 0 --AND F.IdUser = @LoggedUserId            
            
  --SELECT * FROM #Dynamic      
        
  DECLARE @i INT      
  DECLARE @count INT      
        
  SELECT @i = MIN([DynamicId]) FROM #Dynamic       
  SELECT @count = MAX([DynamicId]) FROM #Dynamic       
                   
  WHILE (@i <= @count)       
  BEGIN       
 SELECT @IdDynamicAux = @i, @DynamicAux = [Dynamic], @FormAux = Form, @StartDate = StartDate, @EndDate = EndDate FROM #Dynamic WHERE DynamicId = @i      
      
 --DynamicProductPointOfInterest        
    CREATE TABLE #DynamicProductPointOfInterest         
    (        
     [DynamicProductPointOfInterestId] [int] NULL,        
     [ProductId] [int] NULL,        
     [ProductBarCode] [varchar](100) NULL,        
     [PointOfInterestId] [int]  NULL,        
     [PointOfInterestIdentifier] [varchar](50) NULL,        
     [DynamicId] [int] NULL,        
     [Dynamic] [varchar](100) NULL,        
     [FormPlusId] [int] NULL,        
     [FormId] [int] NULL,        
     [Form] [varchar](100) NULL,        
     [StartDate] datetime NOT NULL,        
     [EndDate] datetime NULL        
    )        
         
    INSERT INTO #DynamicProductPointOfInterest        
    SELECT  DISTINCT NULL,P.Id, DDPPOI.ProductBarCode, POI.Id, DDPPOI.PointOfInterestIdentifier, @IdDynamicAux DynamicId, DDPPOI.[Dynamic], FP.Id, F.Id, DDPPOI.Form, @StartDate, @EndDate        
    FROM  @DataDynamicProductPointOfInterest DDPPOI        
    INNER JOIN [dbo].[Product]    P WITH (NOLOCK) ON P.[BarCode] = DDPPOI.[ProductBarCode] AND P.[Deleted] = 0        
    INNER JOIN [dbo].[PointOfInterest]  POI WITH (NOLOCK) ON POI.[Identifier] = DDPPOI.[PointOfInterestIdentifier] AND POI.[Deleted] = 0        
    INNER JOIN [dbo].[Form] F WITH (NOLOCK) ON F.[Name] = DDPPOI.[Form] AND F.[Deleted] = 0 --AND F.IdUser = @LoggedUserId        
    INNER JOIN [dbo].[FormPlus] FP WITH (NOLOCK) ON FP.[IdForm] = F.[Id] AND FP.[Deleted] = 0 --AND F.IdUser = @LoggedUserId        
    WHERE DDPPOI.[Dynamic] = @DynamicAux AND DDPPOI.[Form] = @FormAux AND DDPPOI.[StartDate] = @StartDate AND DDPPOI.[EndDate] = @EndDate        
          
    INSERT dbo.[DynamicProductPointOfInterest]        
    SELECT DISTINCT DynamicId, ProductId, PointOfInterestId        
    FROM #DynamicProductPointOfInterest DS           
         
         
    --DynamicReference        
    CREATE TABLE #DynamicReference         
    (        
     [DynamicReferenceId] [int] NULL,        
     [DynamicReferenceName] [varchar](100) NULL,        
     [DynamicId] [int] NULL,        
     [Dynamic] [varchar](100) NULL,        
     [FormPlusId] [int]  NULL,        
     [FormId] [int]  NULL,        
     [Form] [varchar](100) NULL,        
     [StartDate] datetime NOT NULL,        
     [EndDate] datetime NULL        
    )        
              
    INSERT INTO #DynamicReference        
    SELECT  DISTINCT NULL,DR.[ReferenceName], @IdDynamicAux, DR.[Dynamic], FP.Id, F.ID, F.[Name], @StartDate, @EndDate        
    FROM  @DataDynamicReference DR        
    INNER JOIN [dbo].[Form] F WITH (NOLOCK) ON F.[Name] = DR.[Form] AND F.[Deleted] = 0 --AND F.IdUser = @LoggedUserId        
    INNER JOIN [dbo].[FormPlus] FP WITH (NOLOCK) ON FP.[IdForm] = F.[Id] AND FP.[Deleted] = 0 --AND F.IdUser = @LoggedUserId        
    WHERE  DR.[Dynamic] = @DynamicAux AND DR.[Form] = @FormAux AND DR.[StartDate] = @StartDate AND DR.[EndDate] = @EndDate        
                    
    INSERT dbo.[DynamicReference]        
    SELECT DISTINCT [DynamicId], [DynamicReferenceName], 0        
    FROM #DynamicReference DS        
        
        
    --DynamicReferenceValue           
    CREATE TABLE #DynamicReferenceValue        
    (        
     [DynamicReferenceId] [int] NULL,        
     [ReferenceName] [varchar](100) NOT NULL,        
     [DynamicReferenceValueId] [int] NULL,        
     [ReferenceValue] [varchar](1000) NOT NULL,        
     [DynamicProductPointOfInterestId] [int] NULL,        
     [ProductId] [int] NULL,        
     [ProductBarCode] [varchar](100) NULL,        
     [PointOfInterestId] [int]  NULL,        
     [PointOfInterestIdentifier] [varchar](50) NULL,        
     [DynamicId] [int] NULL,        
     [Dynamic] [varchar](100) NULL,        
     [FormPlusId] [int] NULL,        
     [FormId] [int] NULL,        
     [Form] [varchar](100) NULL,        
     [StartDate] datetime NOT NULL,        
     [EndDate] datetime NULL        
    )        
        
    INSERT INTO #DynamicReferenceValue        
    SELECT  DISTINCT DR.Id, DR.[Name] , NULL, DRV.ReferenceValue, DPPOI.Id, P.Id, DRV.ProductBarCode, POI.Id, DRV.PointOfInterestIdentifier, @IdDynamicAux, DRV.[Dynamic], FP.Id, F.Id, DRV.Form, @StartDate, @EndDate        
    FROM  @DataDynamicReferenceValue DRV   
    INNER JOIN [dbo].[Product] P WITH (NOLOCK) ON P.[BarCode] = DRV.[ProductBarCode] AND P.[Deleted] = 0        
    INNER JOIN [dbo].[PointOfInterest] POI WITH (NOLOCK) ON POI.[Identifier] = DRV.[PointOfInterestIdentifier] AND POI.[Deleted] = 0        
    INNER JOIN [dbo].[Form] F WITH (NOLOCK) ON F.[Name] = DRV.[Form] AND F.[Deleted] = 0 --AND F.IdUser = @LoggedUserId         
    INNER JOIN [dbo].[FormPlus] FP WITH (NOLOCK) ON FP.[IdForm] = F.[Id] AND FP.[Deleted] = 0 --AND F.IdUser = @LoggedUserId        
    INNER JOIN [dbo].[DynamicReference] DR WITH (NOLOCK) ON DR.[IdDynamic] = @IdDynamicAux AND DR.[Name] = DRV.ReferenceName AND DR.[Deleted] = 0        
    INNER JOIN [dbo].[DynamicProductPointOfInterest] DPPOI WITH (NOLOCK) ON DPPOI.IdDynamic = @IdDynamicAux AND DPPOI.IdProduct = P.Id AND DPPOI.IdPointOfInterest = POI.Id         
    WHERE DRV.[Dynamic] = @DynamicAux AND DRV.[Form] = @FormAux AND DRV.[StartDate] = @StartDate AND DRV.[EndDate] = @EndDate        
             
    INSERT dbo.[DynamicReferenceValue]        
    SELECT DISTINCT [DynamicReferenceId], [DynamicProductPointOfInterestId],[ReferenceValue], 0        
    FROM #DynamicReferenceValue DS        
               
    --SELECT * FROM #DynamicProductPointOfInterest        
    --SELECT * FROM #DynamicReference        
    --SELECT * FROM #DynamicReferenceValue        
            
    DROP TABLE #DynamicProductPointOfInterest        
    DROP TABLE #DynamicReference        
    DROP TABLE #DynamicReferenceValue        
      
 SELECT @i = @i + 1      
  END      
              
             
  --Get All Dynamics with PersonOfInterest related on the second sheet in the template            
  INSERT INTO #DynamicPersonOfInterest            
  SELECT  DISTINCT NULL,POI.Id, DDPOI.PersonOfInterestIdentifier, D.DynamicId, DDPOI.[Dynamic]            
  FROM  @DataDynamicPersonOfInterest DDPOI            
  INNER JOIN #Dynamic D ON D.[Dynamic] = DDPOI.[Dynamic]            
  INNER JOIN [dbo].[PersonOfInterest]  POI WITH (NOLOCK) ON POI.[Identifier] = DDPOI.[PersonOfInterestIdentifier] AND POI.[Deleted] = 0            
            
  --Get all dynamics from template that they are not related with person of interes            
  SELECT DISTINCT D.*            
  INTO #DynamicForAllPersonOfInterest            
  FROM @DataDynamic D            
  LEFT JOIN            
    @DataDynamicPersonOfInterest DPOI ON DPOI.[Dynamic] = D.[Dynamic]            
  WHERE DPOI.[Dynamic] IS NULL            
              
  UPDATE [dbo].[Dynamic]          
  SET [AllPersonOfInterest] = 1        
  FROM #DynamicForAllPersonOfInterest AS DFAPEOI          
  INNER JOIN #Dynamic D WITH (NOLOCK) ON DFAPEOI.[Dynamic] = D.[Dynamic]          
  WHERE [Dynamic].[Id] = D.[DynamicId]        
              
  INSERT dbo.[DynamicPersonOfInterest]            
  SELECT DISTINCT DynamicId, PersonOfInterestId            
  FROM #DynamicPersonOfInterest DS            
  WHERE DynamicId IS NOT NULL            
              
  --Validaciones POST INSERT            
            
  --Report Product, Point Of Interest, Form not valid            
  SELECT DPPOI.ProductBarCode, DPPOI.PointOfInterestIdentifier, DPPOI.[Dynamic], DPPOI.Form            
  FROM @DataDynamicProductPointOfInterest DPPOI            
  LEFT JOIN            
    dbo.Product P WITH (NOLOCK) ON P.BarCode = DPPOI.ProductBarCode AND P.Deleted = 0            
  LEFT JOIN            
    dbo.PointOfInterest POI WITH (NOLOCK) ON POI.Identifier = DPPOI.PointOfInterestIdentifier AND P.Deleted = 0            
  LEFT JOIN            
    dbo.Form F WITH (NOLOCK) ON F.[Name] = DPPOI.[Form] AND F.[Deleted] = 0 --AND F.IdUser = @LoggedUserId            
  LEFT JOIN             
    [dbo].[FormPlus] FP WITH (NOLOCK) ON FP.[IdForm] = F.[Id] AND FP.[Deleted] = 0 --AND F.IdUser = @LoggedUserId            
  WHERE P.Id IS NULL OR POI.Identifier IS NULL OR F.Id IS NULL            
            
  --Report Person Of Interest not valid            
  SELECT DPOI.PersonOfInterestIdentifier, DPOI.[Dynamic]            
 FROM @DataDynamicPersonOfInterest DPOI            
  LEFT JOIN            
    dbo.PersonOfInterest POI WITH (NOLOCK) ON POI.Identifier = DPOI.PersonOfInterestIdentifier AND POI.Deleted = 0            
  WHERE POI.Id IS NULL            
             
                
  --SELECT * FROM #DynamicPersonOfInterest            
              
  DROP TABLE #Dynamic              
  DROP TABLE #DynamicPersonOfInterest              
 END            
                 
 SET ANSI_WARNINGS  ON;            
END
