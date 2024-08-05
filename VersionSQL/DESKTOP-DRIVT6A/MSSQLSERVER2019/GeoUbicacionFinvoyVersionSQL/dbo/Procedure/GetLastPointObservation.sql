/****** Object:  Procedure [dbo].[GetLastPointObservation]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetLastPointObservation]
	 @IdPersonOfInterest int
	,@IdVisit int
	,@IdPointOfInterest int
AS
BEGIN
	
	DECLARE @Visit TABLE
	(
		LocationInDate datetime,
		LocationOutDate datetime
	)

	INSERT INTO @Visit (LocationInDate, LocationOutDate)
	SELECT TOP 1 [LocationInDate], [LocationOutDate]
	FROM PointOfInterestVisited
	WHERE [Id] = @IdVisit 
	  AND [IdPointOfInterest] = @IdPointOfInterest
	  AND [IdPersonOfInterest] = @IdPersonOfInterest

	INSERT INTO @Visit (LocationInDate, LocationOutDate)
	SELECT TOP 1 [CheckInDate], [CheckOutDate]
	FROM PointOfInterestManualVisited
	WHERE [Id] = @IdVisit 
	  AND [IdPointOfInterest] = @IdPointOfInterest
	  AND [IdPersonOfInterest] = @IdPersonOfInterest

	INSERT INTO @Visit (LocationInDate, LocationOutDate)
	SELECT TOP 1 [CheckInDate], [CheckOutDate]
	FROM PointOfInterestMark
	WHERE [Id] = @IdVisit 
	  AND [IdPointOfInterest] = @IdPointOfInterest
	  AND [IdPersonOfInterest] = @IdPersonOfInterest

	DECLARE @LocationInDate datetime = (SELECT TOP 1 LocationInDate FROM @Visit)
	DECLARE @LocationOutDate datetime = (SELECT TOP 1 LocationOutDate FROM @Visit)

	SELECT I.[Id], I.[Description], I.[CreatedDate],
		   I.[ImageEncoded], I.[ImageEncoded2], I.[ImageEncoded3]
	FROM Incident I
	JOIN IncidentType T ON T.[Id] = I.[IdIncidentType]
	WHERE I.[CreatedDate] >= @LocationInDate
	  AND (@LocationOutDate IS NULL OR I.[CreatedDate] <= @LocationOutDate)
	  AND T.[Name] = 'Resumen de visita' -- No se traduce porque solo lo usaba Ceibal

END
