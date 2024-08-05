/****** Object:  Procedure [dbo].[SavePersonOfInterestSchedule]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 27/02/2013
-- Description:	SP para guardar un horario de trabajo para una persona de interés
-- =============================================
CREATE PROCEDURE [dbo].[SavePersonOfInterestSchedule]
(
	 @IdPersonOfInterest [sys].[int]
	,@IdDayOfWeek [sys].[smallint]
	,@WorkHours [sys].[time](7)	
	,@FromHour [sys].[time](7)
	,@ToHour [sys].[time](7)
	,@RestHours [sys].[time](7) = NULL
)
AS
BEGIN
	INSERT INTO [dbo].[PersonOfInterestSchedule]([IdPersonOfInterest], [IdDayOfWeek], 
				[WorkHours], [RestHours], [FromHour], [ToHour])
	VALUES (@IdPersonOfInterest, @IdDayOfWeek, @WorkHours, @RestHours, @FromHour, @ToHour)
END
