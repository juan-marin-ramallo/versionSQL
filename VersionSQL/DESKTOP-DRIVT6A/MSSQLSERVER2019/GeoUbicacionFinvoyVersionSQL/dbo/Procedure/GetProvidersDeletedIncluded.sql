/****** Object:  Procedure [dbo].[GetProvidersDeletedIncluded]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Gaston Legnani
-- Create date: 11/08/2016
-- Description:	SP para obtener los Proveedores incluido los eliminados
-- =============================================
CREATE PROCEDURE [dbo].[GetProvidersDeletedIncluded]

AS
BEGIN
	
	SELECT		P.[Id], P.[Name], P.[SapId], P.[Society], P.[Deleted]
	
	FROM		[dbo].[Provider] P 
	
	GROUP BY	P.[Id], P.[Name], P.[SapId], P.[Society], P.[Deleted]
	
	ORDER BY	P.[Deleted], P.[Name]
    
END
