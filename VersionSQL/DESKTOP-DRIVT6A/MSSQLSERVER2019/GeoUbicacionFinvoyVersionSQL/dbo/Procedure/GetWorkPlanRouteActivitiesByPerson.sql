/****** Object:  Procedure [dbo].[GetWorkPlanRouteActivitiesByPerson]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		NR
-- Create date: 21/08/2017
-- Description:	SP para obtener las WA de ruta para una persona
-- =============================================
CREATE PROCEDURE [dbo].[GetWorkPlanRouteActivitiesByPerson]
 ( @IdPerson [sys].[INT],
 @DateFrom [sys].Datetime,
 @DateTo [sys].Datetime,
  @TypeId [sys].[INT],
  @PlanId [sys].[INT] 
  
  )
AS
    BEGIN
	declare @RGId [sys].[INT] 
	select @RGId = wp.IdRouteGroup from dbo.WorkPlan wp where wp.Id=@PlanId

	select rd.RouteDate AS ActivityDate, rg.Name AS RouteGroupName, rg.Id AS RouteGroupId
	from dbo.RouteDetail rd
	inner join dbo.RoutePointOfInterest rpoi on rpoi.Id = rd.IdRoutePointOfInterest
	inner join dbo.RouteGroup rg on rpoi.IdRouteGroup = rg.Id
	where rg.Id != @RGId and rd.Disabled = 0 and rd.RouteDate between @DateFrom and @DateTo
	and rg.IdPersonOfInterest = @IdPerson

      
	
    END;
