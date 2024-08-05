/****** Object:  Procedure [dbo].[GetPoiHierarchyLevel1]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Diego Cáceres
-- Create date: 23/08/2016
-- Description:	SP para obtener los Abuelos activos
-- =============================================
CREATE PROCEDURE [dbo].[GetPoiHierarchyLevel1]

AS
BEGIN
	
	SELECT		G.[Id], G.[Name], G.[SapId], G.[Society]	
	
	FROM		[dbo].[POIHierarchyLevel1] G 	
	
	WHERE		G.[Deleted] = 0	
	
	GROUP BY	G.[Id], G.[Name], G.[SapId], G.[Society]	
	ORDER BY	G.[Name]
    
END
