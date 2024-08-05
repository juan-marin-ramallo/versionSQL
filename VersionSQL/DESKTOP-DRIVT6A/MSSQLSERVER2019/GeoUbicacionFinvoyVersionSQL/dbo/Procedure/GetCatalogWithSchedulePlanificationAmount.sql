/****** Object:  Procedure [dbo].[GetCatalogWithSchedulePlanificationAmount]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		jgil
-- Create date: 18/01/2024
-- Description:	Get amounts of catalog with schedule planification by point of interest
-- =============================================
CREATE PROCEDURE [dbo].[GetCatalogWithSchedulePlanificationAmount] 
	-- Add the parameters for the stored procedure here
	@IdPersonOfInterest [sys].[int],
	@IdPointOfInterest [sys].[int]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT COUNT(CPI.IdCatalog) Amount
	FROM CatalogPointOfInterest CPI
	INNER JOIN ScheduleProfileCatalog SPC ON CPI.IdCatalog = SPC.IdCatalog AND SPC.Deleted = 0
	INNER JOIN ScheduleProfileCatalogCron SPCC ON SPC.IdScheduleProfileCatalogCron = SPCC.Id
	INNER JOIN ScheduleProfile SP ON SPC.IdScheduleProfile = SP.Id AND SP.Deleted = 0
	LEFT JOIN ScheduleProfileAssignation SPA ON SP.Id = SPA.IdScheduleProfile
	WHERE CPI.IdPointOfInterest = @IdPointOfInterest
		  AND (SP.AllPersonOfInterest = 1 OR SPA.IdPersonOfInterest = @IdPersonOfInterest)
		  AND (SP.AllPointOfInterest = 1 OR SPA.IdPointOfInterest = @IdPointOfInterest)
		  AND SP.ToDate >= GETDATE()
END
