/****** Object:  Procedure [dbo].[GetAllFormPlus]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================      
-- Author:  Juan Marin      
-- Create date: 02/11/2023      
-- Description: SP para obtener los formularios plus      
-- ==============================================      
-- Modified by: JUAN MARIN    
-- Modified date: 22/12/2023    
-- Description:  GT-516: Se corrige problema reportado de no poder usar los formularios creados por cualquier usuario
-- =============================================    
CREATE PROCEDURE [dbo].[GetAllFormPlus]       
 @IdUser [sys].[int] = NULL  
AS      
BEGIN      
 DECLARE @SystemToday [sys].[datetime]      
 SET @SystemToday = DATEADD(DAY, DATEDIFF(DAY, 0, Tzdb.FromUtc(GETUTCDATE())), 0)      
      
 SELECT [Id] AS FormId,[Name],[Description],[StartDate],[EndDate]       
 FROM dbo.Form       
 WHERE ((@IdUser IS NULL) OR (dbo.CheckUserInFormCompanies(IdCompany, @IdUser) = 1))  
 AND  IsFormPlus = 1       
 AND  Deleted = 0       
 AND  DATEADD(DAY, DATEDIFF(DAY, 0, Tzdb.FromUtc([EndDate])), 0)  >= @SystemToday --ACTIVOS      
 ORDER BY Id      
END
