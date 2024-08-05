/****** Object:  Procedure [dbo].[GetProviders]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Gaston Legnani
-- Create date: 11/08/2016
-- Description:	SP para obtener los Proveedores activos
-- =============================================
CREATE PROCEDURE [dbo].[GetProviders]

AS
BEGIN
	
	SELECT		P.[Id], P.[Name], P.[SapId], P.[Society], P.[Deleted]
	
	FROM		[dbo].[Provider] P 
	
	WHERE		P.[Deleted] = 0
	
	GROUP BY	P.[Id], P.[Name], P.[SapId], P.[Society], P.[Deleted]
	
	ORDER BY	P.[Name]
    
END
