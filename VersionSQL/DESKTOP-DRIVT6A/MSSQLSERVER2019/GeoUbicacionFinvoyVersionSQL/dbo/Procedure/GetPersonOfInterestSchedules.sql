/****** Object:  Procedure [dbo].[GetPersonOfInterestSchedules]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 27/02/2013
-- Description:	SP para obtener los horarios de trabajo de un reponedor
-- =============================================
CREATE PROCEDURE [dbo].[GetPersonOfInterestSchedules]
(
	@IdPersonOfInterest [sys].[int]
)
AS
BEGIN
	SELECT		[IdPersonOfInterest], [IdDayOfWeek], [WorkHours], [RestHours], [FromHour], [ToHour]
	FROM		[dbo].[PersonOfInterestSchedule] WITH (NOLOCK)
	WHERE		[IdPersonOfInterest] = @IdPersonOfInterest
END
