/****** Object:  Procedure [dbo].[GetLocationsForHeatMap]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 12/10/2012
-- Description:	SP para obtener el historial de ubicaciones de un repositor dado
-- =============================================
CREATE PROCEDURE [dbo].[GetLocationsForHeatMap]
(
	 @DateFrom [sys].[datetime]
	,@DateTo [sys].[datetime]
	,@IdDepartments [sys].[varchar](1000) = NULL
	,@Types [sys].[varchar](1000) = NULL
	,@IdPersonsOfInterest [sys].[varchar](max) = NULL
	,@Interval [sys].[int] = 10
	,@IdUser [sys].[int] = NULL
)
AS
BEGIN
	DECLARE @LocDateFrom [sys].[datetime]
	DECLARE @LocDateTo [sys].[datetime]
	DECLARE @LocIdDepartments [sys].[varchar](1000)
	DECLARE @LocTypes [sys].[varchar](1000)
	DECLARE @LocIdPersonsOfInterest [sys].[varchar](1000)
	DECLARE @LocInterval [sys].[int]
	DECLARE @LocIdUser [sys].[int]

	SET @LocDateFrom = @DateFrom
	SET @LocDateTo = @DateTo
	SET @LocIdDepartments = @IdDepartments
	SET @LocTypes = @Types
	SET @LocIdPersonsOfInterest = @IdPersonsOfInterest
	SET @LocInterval = @Interval;
	SET @LocIdUser = @IdUser;

;WITH TrimedLocs AS 
	(SELECT		LR.[Id], LR.[IdPersonOfInterest] AS PersonOfInterestId, LR.[Date], LR.[Latitude], LR.[Longitude], LR.[Processed], LR.[BatteryLevel],
					LR.[PersonOfInterestName], LR.[PersonOfInterestLastName], LR.[PersonOfInterestMobilePhoneNumber], RowNum = ROW_NUMBER() OVER (ORDER BY LR.[IdPersonOfInterest], LR.[Date] ASC)
	FROM		[dbo].[LocationReport] LR 
	WHERE		LR.[Date] BETWEEN @LocDateFrom AND @LocDateTo AND
				((@LocIdDepartments IS NULL) OR (LR.[PersonOfInterestIdDepartment] IS NULL) OR (dbo.CheckValueInList(LR.[PersonOfInterestIdDepartment], @LocIdDepartments) = 1)) AND
				((@LocTypes IS NULL) OR (dbo.CheckCharValueInList(LR.[Type], @LocTypes) = 1)) AND
				((@LocIdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(LR.[IdPersonOfInterest], @LocIdPersonsOfInterest) = 1)) AND
				((@LocIdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(LR.[PersonOfInterestIdDepartment], @LocIdUser) = 1)) AND				
				((@LocIdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(LR.[IdPersonOfInterest], @LocIdUser) = 1)) 
)
SELECT	L.[Id], L.PersonOfInterestId, L.[Date], ISNULL(POIVR.[Latitude], L.[Latitude]) as Latitude,  ISNULL(POIVR.[Longitude], L.[Longitude]) as Longitude, L.[Processed], L.[BatteryLevel],
				L.[PersonOfInterestName], L.[PersonOfInterestLastName], L.[PersonOfInterestMobilePhoneNumber]
FROM	TrimedLocs AS L
		LEFT OUTER JOIN [dbo].[PointOfInterestVisitedReport] POIVR ON L.[Id] >= POIVR.[IdLocationIn] AND (POIVR.[IdLocationOut] IS NULL OR L.[Id] < POIVR.[IdLocationOut]) AND POIVR.[IdPersonOfInterest] = L.[PersonOfInterestId]				
		AND (POIVR.[IdLocationIn] IS NULL OR POIVR.[IdLocationIn] = L.[Id]) 
WHERE	L.RowNum % @LocInterval = 0
GROUP BY	L.[Id], L.[PersonOfInterestId], L.[Date], ISNULL(POIVR.[Latitude], L.[Latitude]), ISNULL(POIVR.[Longitude], L.[Longitude]), L.[Processed], L.[BatteryLevel],
			L.[PersonOfInterestName], L.[PersonOfInterestLastName], L.[PersonOfInterestMobilePhoneNumber]
ORDER BY L.[PersonOfInterestId], L.[Date] ASC

END
