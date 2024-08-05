/****** Object:  Procedure [dbo].[GetScheduleProfCatalogProductsAndCron]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================  
-- Author:  jgil  
-- Create date: 16/01/2024  
-- Description: Get prouducts and cron expression from catalogs with schedule profiles  
-- =============================================  
CREATE PROCEDURE [dbo].[GetScheduleProfCatalogProductsAndCron]   
 -- Add the parameters for the stored procedure here  
 @IdPersonOfInterest [sys].[int],  
 @IdsPointOfInterest [dbo].[IdTableType] READONLY  
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  

    -- Insert statements for procedure here  
 SELECT P.Id, CPI.IdPointOfInterest, SPCC.CronExpression  
 FROM Product P  
 INNER JOIN CatalogProduct CP ON P.Id = CP.IdProduct  
 INNER JOIN Catalog ON CP.IdCatalog = Catalog.Id AND Catalog.Deleted = 0  
 INNER JOIN CatalogPointOfInterest CPI ON CP.IdCatalog = CPI.IdCatalog  
 INNER JOIN ScheduleProfileCatalog SPC ON CP.IdCatalog = SPC.IdCatalog AND SPC.Deleted = 0  
 INNER JOIN ScheduleProfileCatalogCron SPCC ON SPC.IdScheduleProfileCatalogCron = SPCC.Id  
 INNER JOIN ScheduleProfile SP ON SPC.IdScheduleProfile = SP.Id AND SP.Deleted = 0  
 LEFT JOIN ScheduleProfileAssignation SPA ON SP.Id = SPA.IdScheduleProfile  
 WHERE CPI.IdPointOfInterest IN (SELECT Id FROM @IdsPointOfInterest)  
    AND (SP.AllPersonOfInterest = 1 OR SPA.IdPersonOfInterest = @IdPersonOfInterest)  
    AND (SP.AllPointOfInterest = 1 OR SPA.IdPointOfInterest IN (SELECT Id FROM @IdsPointOfInterest))  
    AND SP.ToDate >= GETDATE()  
 ORDER BY SPCC.CronExpression  
END
