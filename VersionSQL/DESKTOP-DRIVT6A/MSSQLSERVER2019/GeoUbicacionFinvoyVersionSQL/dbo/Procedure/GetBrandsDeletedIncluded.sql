/****** Object:  Procedure [dbo].[GetBrandsDeletedIncluded]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Gaston Legnani
-- Create date: 11/08/2016
-- Description:	SP para obtener las MARCAS incluido las elimiandas
-- =============================================
CREATE PROCEDURE [dbo].[GetBrandsDeletedIncluded]

AS
BEGIN
	
	SELECT		B.[Id], B.[Name], B.[SapId], B.[Society], P.[Id] AS ProviderId, P.[Name] AS ProviderName, B.[Deleted]
	
	FROM		[dbo].[Brand] B
				LEFT JOIN [dbo].[Provider] P ON P.[Id] = B.[ProviderId]
	
	GROUP BY	B.[Id], B.[Name], B.[SapId], B.[Society], P.[Id], P.[Name], B.[Deleted]
	
	ORDER BY	B.[Deleted], B.[Name]
    
END
