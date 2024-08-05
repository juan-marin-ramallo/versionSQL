/****** Object:  Procedure [dbo].[GetPlanObservationsByWorkPlanId]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetPlanObservationsByWorkPlanId] 
	@WorkPlanId [sys].[INT]
AS
BEGIN
	SELECT		[Id], [IdWorkPlan], [CreatedDate], [Observation]
	FROM		[dbo].[PlanObservation] PO
	WHERE		PO.IdWorkPlan = @WorkPlanId
	ORDER BY    PO.CreatedDate DESC
END
