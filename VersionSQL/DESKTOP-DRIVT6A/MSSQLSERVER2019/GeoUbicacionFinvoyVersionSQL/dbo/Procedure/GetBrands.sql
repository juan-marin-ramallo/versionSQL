/****** Object:  Procedure [dbo].[GetBrands]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Gaston Legnani
-- Create date: 11/08/2016
-- Description:	SP para obtener las MARCAS activas
-- =============================================
CREATE PROCEDURE [dbo].[GetBrands]

AS
BEGIN
	
	SELECT		B.[Id], B.[Name], B.[SapId], B.[Society], B.[Deleted], P.[Id] AS ProviderId, 
				P.[Name] AS ProviderName
	
	FROM		[dbo].[Brand] B
				LEFT JOIN [dbo].[Provider] P ON P.[Id] = B.[ProviderId]
	
	WHERE		B.[Deleted] = 0
	
	GROUP BY	B.[Id], B.[Name], B.[SapId], B.[Society], P.[Id], P.[Name], B.[Deleted]
	
	ORDER BY	B.[Name]
    
END
