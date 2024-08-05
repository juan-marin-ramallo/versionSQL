/****** Object:  Procedure [dbo].[GetMainBoards]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================  
-- Author:Juan Marin
-- Create date: 14/02/2024  
-- Description: SP para obtener la información de las funcionalidades mas usadas  
-- =============================================  
CREATE PROCEDURE [dbo].[GetMainBoards]  
 @IdUser [sys].[int]  
AS  
BEGIN  
 SELECT	DISTINCT
		MBT.[Name], 
		MBT.[IconUrl], 		
		MBT.[ActionUrl],
		MBT.[Order]
 FROM	[dbo].[MainBoardTranslated] MBT WITH (NOLOCK)  
 INNER JOIN 
		[dbo].[Permission] P WITH (NOLOCK) ON P.[Id] = MBT.[IdPermission]  
 INNER JOIN 
		[dbo].[UserPermission] UP WITH (NOLOCK) ON UP.[IdPermission] = P.[Id]  
 WHERE  P.[Enabled] = 1  
 AND	UP.[IdUser] = @IdUser
 ORDER BY 
		MBT.[Order]
END
