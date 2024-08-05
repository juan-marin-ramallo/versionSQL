/****** Object:  ScalarFunction [dbo].[GetLastVisitedPointOfInterestName]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[GetLastVisitedPointOfInterestName]
(
	 @IdPersonOfInterest [sys].[int]
	,@IncludeAutomaticVisits [sys].[bit]
)
RETURNS [sys].[varchar](100)
AS
BEGIN

	DECLARE @Visits TABLE
	(
		IdPointOfInterest int,
		LocationInDate datetime
	) 

	DECLARE @Now [sys].[datetime]
    SET @Now = GETUTCDATE()

	INSERT INTO @Visits (IdPointOfInterest, LocationInDate)
	SELECT TOP 1 [IdPointOfInterest], [LocationInDate]
	FROM PointOfInterestVisited
	WHERE [IdPersonOfInterest] = @IdPersonOfInterest
	  AND @IncludeAutomaticVisits = 1
	  AND Tzdb.AreSameSystemDates([LocationInDate], @Now) = 1
	ORDER BY [LocationInDate] DESC

	INSERT INTO @Visits (IdPointOfInterest, LocationInDate)
	SELECT TOP 1 [IdPointOfInterest], [CheckInDate]
	FROM PointOfInterestManualVisited
	WHERE [IdPersonOfInterest] = @IdPersonOfInterest
	  AND Tzdb.AreSameSystemDates([CheckInDate], @Now) = 1
	ORDER BY [CheckInDate] DESC

	INSERT INTO @Visits (IdPointOfInterest, LocationInDate)
	SELECT TOP 1 [IdPointOfInterest], [CheckInDate]
	FROM PointOfInterestMark
	WHERE [IdPersonOfInterest] = @IdPersonOfInterest
	  AND Tzdb.AreSameSystemDates([CheckInDate], @Now) = 1
	ORDER BY [CheckInDate] DESC

	DECLARE @lastVisitedPoint [sys].[int]
	SET @lastVisitedPoint =
	(
		SELECT Top 1 [IdPointOfInterest]
		FROM @Visits
		ORDER BY [LocationInDate] DESC
	)

	DECLARE @result varchar(100) =
	(
		SELECT [Name]
		FROM PointOfInterest
		WHERE [Id] = @lastVisitedPoint
	)

	RETURN @result

END
