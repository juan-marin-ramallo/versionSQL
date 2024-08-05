/****** Object:  Procedure [dbo].[GetSons]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Diego Cáceres
-- Create date: 23/08/2016
-- Description:	SP para obtener los Padres activos
-- =============================================
CREATE PROCEDURE [dbo].[GetSons]

AS
BEGIN
	
	SELECT		S.[Id], S.[Name], S.[SapId], S.[Society]	
	FROM		[dbo].[Son] S 	
	WHERE		S.[Deleted] = 0	
	GROUP BY	S.[Id], S.[Name], S.[SapId], S.[Society]	
	ORDER BY	S.[Name]
    
END
