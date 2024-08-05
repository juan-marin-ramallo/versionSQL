/****** Object:  Procedure [dbo].[SavePointOfInterestHourWindow]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 11/08/2014
-- Description:	SP para guardar una ventana horaria para un punto de interés
-- =============================================
CREATE PROCEDURE [dbo].[SavePointOfInterestHourWindow]
(
	 @IdPointOfInterest [sys].[int]
	,@IdDayOfWeek [sys].[smallint]
	,@FromHour [sys].[time](7)
	,@ToHour [sys].[time](7)
)
AS
BEGIN
	INSERT INTO [dbo].[PointOfInterestHourWindow]([IdPointOfInterest], [IdDayOfWeek], [FromHour], [ToHour])
	VALUES (@IdPointOfInterest, @IdDayOfWeek, @FromHour, @ToHour)
END
