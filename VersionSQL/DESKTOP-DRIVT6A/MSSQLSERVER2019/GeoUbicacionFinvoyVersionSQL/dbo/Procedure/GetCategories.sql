/****** Object:  Procedure [dbo].[GetCategories]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Gaston Legnani
-- Create date: 11/08/2016
-- Description:	SP para obtener las categorias activas
-- =============================================
CREATE PROCEDURE [dbo].[GetCategories]

AS
BEGIN
	
	SELECT		C.[Id], C.[Name], C.[SapId], C.[Society], C.[Deleted],
				B.[Id] AS BrandId, B.[Name] AS BrandName
	
	FROM		[dbo].[Category] C
				LEFT JOIN [dbo].[Brand] B ON B.[Id] = C.[BrandId]
	
	WHERE		C.[Deleted] = 0
	
	GROUP BY	C.[Id], C.[Name], C.[SapId], C.[Society], B.[Id], B.[Name], C.[Deleted]
	
	ORDER BY	C.[Name]
    
END
