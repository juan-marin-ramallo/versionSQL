/****** Object:  Procedure [dbo].[GetScheduleProfileCatalogs]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================  
-- Author:  Juan Marin  
-- Create date: 14/01/2024  
-- Description: SP para obtener la planificacion de catalogo.  
-- =============================================  
CREATE PROCEDURE [dbo].[GetScheduleProfileCatalogs] 
(  
  @IdScheduleProfile [sys].[int]  
)  
AS  
BEGIN  
  
 SELECT SPC.[Id], SPC.[RecurrenceCondition], SPC.[RecurrenceNumber],  SPC.Comment,
		C.Id AS IdCatalog, C.[Name] AS CatalogName,
		SPCC.Id AS IdScheduleProfileCatalogCron, SPCC.CronExpression CronExpression,
		SPCDW.[DayOfWeek]  
 FROM [dbo].[ScheduleProfileCatalog] SPC WITH (NOLOCK)  
 INNER JOIN [dbo].[Catalog] C WITH (NOLOCK) ON C.[Id] = SPC.[IdCatalog] 
 INNER JOIN [dbo].[ScheduleProfile] SP WITH (NOLOCK) ON SP.[Id] = SPC.[IdScheduleProfile] 
 INNER JOIN dbo.[ScheduleProfileCatalogCron] SPCC WITH (NOLOCK) ON SPCC.[Id] = SPC.[IdScheduleProfileCatalogCron]  
 INNER JOIN dbo.[ScheduleProfileCatalogDayOfWeek] SPCDW WITH (NOLOCK) ON SPCDW.[IdScheduleProfileCatalog] = SPC.[Id] 
 WHERE  SPC.[IdScheduleProfile] = @IdScheduleProfile AND SPC.[Deleted] = 0 
 ORDER BY SPC.[Id]  
END
