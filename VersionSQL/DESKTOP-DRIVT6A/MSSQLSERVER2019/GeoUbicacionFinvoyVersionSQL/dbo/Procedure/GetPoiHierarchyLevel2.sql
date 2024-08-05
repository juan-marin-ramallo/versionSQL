/****** Object:  Procedure [dbo].[GetPoiHierarchyLevel2]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================  
-- Author:  Diego Cáceres  
-- Create date: 23/08/2016  
-- Description: SP para obtener los Padres activos  
-- Modified By:  Juan Marin
-- Modified date: 01/04/2024
-- Description: Se agrega columna del nombre de la Jerarquia de nivel 1
-- =============================================  
CREATE PROCEDURE [dbo].[GetPoiHierarchyLevel2]  
  
AS  
BEGIN  
   
 SELECT  F.[Id], F.[Name], F.[SapId], F.[Society], F.[HierarchyLevel1Id], P.[Name] AS HierarchyLevel1Name
   
 FROM  [dbo].[POIHierarchyLevel2] F WITH (NOLOCK)
 
 LEFT JOIN

	   [dbo].[POIHierarchyLevel1] P WITH (NOLOCK) ON F.HierarchyLevel1Id = P.Id AND P.Deleted = 0   
   
 WHERE  F.[Deleted] = 0   
   
 GROUP BY F.[Id], F.[Name], F.[SapId], F.[Society], F.[HierarchyLevel1Id], P.[Name]  
   
 ORDER BY F.[Name]  
      
END
