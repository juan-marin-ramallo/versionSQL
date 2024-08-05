/****** Object:  TableFunction [dbo].[PointsOfInterestVisitedDailyReport]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		G
-- Create date: 23/01/2017
-- Description:	devuelve visitas realizadas segun marcas automatica, manuales o NFC
-- =============================================
CREATE FUNCTION [dbo].[PointsOfInterestVisitedDailyReport]
(	
	 @DateFrom [sys].[datetime] 
	,@DateTo [sys].[datetime]
	,@IdPersonsOfInterest [sys].[varchar](max) = NULL
	,@IdPointsOfInterest [sys].[varchar](max) = NULL
	,@IncludeAutomaticVisits [sys].[bit] = 1
	,@IdUser [sys].[int] = NULL
)
RETURNS @t TABLE (IdPointOfInterestVisited [sys].[int], IdPersonOfInterest [sys].[int], PersonOfInterestName [sys].[varchar](50), 
			PersonOfInterestLastName [sys].[varchar](50), PersonOfInterestIdentifier [sys].[varchar](50), 
			[ActionDate] [sys].[datetime],[Radius] [sys].[int], [MinElapsedTimeForVisit] [sys].[int], [IdDepartment] [sys].[INT], [Latitude] [sys].[decimal](25,20), 
			[Longitude] [sys].[decimal](25,20),[Address] [sys].[varchar](250),
			LocationInDate [sys].[datetime], LocationOutDate [sys].[datetime], [IdPointOfInterest] [sys].[int], 
			[PointOfInterestName] [sys].[varchar](100), [ElapsedTime] [sys].[time], 
			PointOfInterestIdentifier [sys].[varchar](50), AutomaticValue [sys].[int], Reason [sys].[varchar](100))	
AS
BEGIN
	DECLARE @MarkedVisitedAutomaticCheckInOutText [sys].[varchar](5000)
	SET @MarkedVisitedAutomaticCheckInOutText = dbo.GetCommonTextTranslated('MarkedVisited_AutomaticCheckInOut')

	DECLARE @MarkedVisitedManualCheckInOutText [sys].[varchar](5000)
	SET @MarkedVisitedManualCheckInOutText = dbo.GetCommonTextTranslated('MarkedVisited_ManualCheckInOut')

	DECLARE @MarkedVisitedNfcCheckInOutText [sys].[varchar](5000)
	SET @MarkedVisitedNfcCheckInOutText = dbo.GetCommonTextTranslated('MarkedVisited_NfcCheckInOut')

	INSERT INTO @t 
	
	SELECT	POIV.[Id] as IdPointOfInterestVisited, S.[Id] AS IdPersonOfInterest, S.[Name] AS PersonOfInterestName, 
			S.[LastName] AS PersonOfInterestLastName, S.[Identifier] AS PersonOfInterestIdentifier, POIV.[LocationInDate] as ActionDate,
			P.[Radius], P.[MinElapsedTimeForVisit], P.[IdDepartment], P.[Latitude], P.[Longitude], P.[Address],
			POIV.[LocationInDate] as LocationInDate, POIV.[LocationOutDate] as LocationOutDate,
			[IdPointOfInterest], P.[Name] AS PointOfInterestName, POIV.[ElapsedTime], 
			P.[Identifier] AS PointOfInterestIdentifier, 1 AS AutomaticValue, @MarkedVisitedAutomaticCheckInOutText as Reason	
	
	FROM	[dbo].[PointOfInterestVisited] POIV WITH (NOLOCK)
			INNER JOIN [dbo].[PointOfInterest] P WITH (NOLOCK) ON P.[Id] = POIV.[IdPointOfInterest]
			LEFT OUTER JOIN [dbo].[PersonOfInterest] S WITH (NOLOCK) ON S.[Id] = POIV.[IdPersonOfInterest]
	
	WHERE	@IncludeAutomaticVisits = 1 -- Only select something if @IncludeAutomaticVisits = 1
			AND 
			POIV.DeletedByNotVisited = 0 AND ((POIV.[LocationOutDate] IS NULL AND POIV.[LocationInDate] >= @DateFrom AND POIV.[LocationInDate] <= @DateTo) 
				OR (POIV.[LocationInDate] BETWEEN @DateFrom AND @DateTo) 
				OR (POIV.[LocationOutDate] BETWEEN @DateFrom AND @DateTo)) AND
			((@IdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(S.[Id], @IdPersonsOfInterest) = 1)) AND
			((@IdPointsOfInterest IS NULL) OR (dbo.CheckValueInList(P.[Id], @IdPointsOfInterest) = 1)) AND			
			((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1)) AND
			((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1)) AND
			((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1)) AND
			((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1)) AND
			[dbo].IsVisitedLocationInPointHourWindow(POIV.[IdPointOfInterest], POIV.[LocationInDate], POIV.[LocationOutDate]) = 1 

	GROUP BY POIV.[Id], S.[Id], S.[Name], S.[LastName], S.[Identifier], POIV.[LocationInDate], P.[Radius], p.[MinElapsedTimeForVisit], 
			 P.[IdDepartment], P.[Latitude], P.[Longitude], P.[Address],
	         [IdPointOfInterest], P.[Name], P.[Identifier], POIV.[ElapsedTime], POIV.[LocationInDate],POIV.[LocationOutDate]

	UNION

	-- Marcas Manuales
	SELECT	POIV.[Id] as IdPointOfInterestVisited, S.[Id] AS IdPersonOfInterest, S.[Name] AS PersonOfInterestName, 
			S.[LastName] AS PersonOfInterestLastName, S.[Identifier] AS PersonOfInterestIdentifier, POIV.[CheckInDate] as ActionDate, 
			P.[Radius], P.[MinElapsedTimeForVisit], P.[IdDepartment], P.[Latitude], P.[Longitude], P.[Address],
			POIV.[CheckInDate] AS LocationInDate, POIV.[CheckOutDate] as LocationOutDate,
			[IdPointOfInterest], P.[Name] AS PointOfInterestName, POIV.[ElapsedTime] AS ElapsedTime, 
			P.[Identifier] AS PointOfInterestIdentifier, 2 AS AutomaticValue, @MarkedVisitedManualCheckInOutText as Reason	
	
	FROM	[dbo].[PointOfInterestManualVisited] POIV WITH (NOLOCK) 
			INNER JOIN [dbo].[PointOfInterest] P WITH (NOLOCK) ON P.[Id] = POIV.[IdPointOfInterest]
			LEFT OUTER JOIN [dbo].[PersonOfInterest] S WITH (NOLOCK) ON S.[Id] = POIV.[IdPersonOfInterest]
	
	WHERE	@IncludeAutomaticVisits = 0 
	
	AND POIV.DeletedByNotVisited = 0 AND ((POIV.[CheckOutDate] IS NULL AND POIV.[CheckInDate] >= @DateFrom AND POIV.[CheckInDate] <= @DateTo) 
				OR (POIV.[CheckInDate] BETWEEN @DateFrom AND @DateTo) 
				OR (POIV.[CheckOutDate] BETWEEN @DateFrom AND @DateTo)) AND
			((@IdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(S.[Id], @IdPersonsOfInterest) = 1)) AND
			((@IdPointsOfInterest IS NULL) OR (dbo.CheckValueInList(P.[Id], @IdPointsOfInterest) = 1)) AND			
			((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1)) AND
			((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1)) AND
			((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1)) AND
			((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1)) AND
			[dbo].IsVisitedLocationInPointHourWindow(POIV.[IdPointOfInterest], POIV.[CheckInDate], POIV.[CheckOutDate]) = 1 	 

	GROUP BY  POIV.[Id], S.[Id], S.[Name], S.[LastName], S.[Identifier], POIV.[CheckInDate], P.[Radius], p.[MinElapsedTimeForVisit], P.[IdDepartment], P.[Latitude], P.[Longitude], P.[Address],
	          [IdPointOfInterest], P.[Name], P.[Identifier], POIV.[ElapsedTime], POIV.[CheckOutDate]

	UNION

	-- Marcas Manuales NFC
	SELECT	POIV.[Id] as IdPointOfInterestVisited, S.[Id] AS IdPersonOfInterest, S.[Name] AS PersonOfInterestName, 
			S.[LastName] AS PersonOfInterestLastName, S.[Identifier] AS PersonOfInterestIdentifier, POIV.[CheckInDate] as ActionDate, 
			P.[Radius], P.[MinElapsedTimeForVisit], P.[IdDepartment], P.[Latitude], P.[Longitude], P.[Address],
			POIV.[CheckInDate] AS LocationInDate, POIV.[CheckOutDate] as LocationOutDate,
			[IdPointOfInterest], P.[Name] AS PointOfInterestName, POIV.[ElapsedTime] AS ElapsedTime, 
			P.[Identifier] AS PointOfInterestIdentifier, 2 AS AutomaticValue, @MarkedVisitedNfcCheckInOutText as Reason	
	
	FROM	[dbo].[PointOfInterestMark] POIV WITH (NOLOCK) 
			INNER JOIN [dbo].[PointOfInterest] P WITH (NOLOCK) ON P.[Id] = POIV.[IdPointOfInterest]
			LEFT OUTER JOIN [dbo].[PersonOfInterest] S WITH (NOLOCK) ON S.[Id] = POIV.[IdPersonOfInterest]
	
	WHERE	POIV.DeletedByNotVisited = 0 AND ((POIV.[CheckOutDate] IS NULL AND POIV.[CheckInDate] >= @DateFrom AND POIV.[CheckInDate] <= @DateTo) 
				OR (POIV.[CheckInDate] BETWEEN @DateFrom AND @DateTo) 
				OR (POIV.[CheckOutDate] BETWEEN @DateFrom AND @DateTo)) AND
			((@IdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(S.[Id], @IdPersonsOfInterest) = 1)) AND
			((@IdPointsOfInterest IS NULL) OR (dbo.CheckValueInList(P.[Id], @IdPointsOfInterest) = 1)) AND			
			((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1)) AND
			((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1)) AND
			((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1)) AND
			((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1)) AND
			[dbo].IsVisitedLocationInPointHourWindow(POIV.[IdPointOfInterest], POIV.[CheckInDate], POIV.[CheckOutDate]) = 1 	 

	GROUP BY  POIV.[Id], S.[Id], S.[Name], S.[LastName], S.[Identifier], POIV.[CheckInDate], P.[Radius], p.[MinElapsedTimeForVisit], P.[IdDepartment], P.[Latitude], P.[Longitude], P.[Address],
	          [IdPointOfInterest], P.[Name], P.[Identifier], POIV.[ElapsedTime], POIV.[CheckOutDate]

	RETURN 
END
