/****** Object:  TableFunction [dbo].[GetPointOfInterestVisitedTime]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 23/01/2017
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[GetPointOfInterestVisitedTime]
(	
	 @DateFrom [sys].[datetime]
	,@DateTo [sys].[datetime]
	,@IdDepartments [sys].[varchar](max) = NULL
	,@Types [sys].[varchar](max) = NULL
	,@IdPersonsOfInterest [sys].[varchar](max) = NULL
	,@IdPointsOfInterest [sys].[varchar](max) = NULL
	,@IncludeAutomaticVisits [sys].[bit] = 1
	,@IdUser [sys].[int] = NULL
)
RETURNS @t TABLE (PointOfInterestId [sys].[int], PointOfInterestName [sys].[varchar](100), 
					PointOfInterestIdentifier [sys].[varchar](50),ElapsedTimeInSeconds [sys].[int]
					,AutomaticValue [sys].[int])	
AS
BEGIN

	INSERT INTO @t 
	
	SELECT	P.[Id] AS PointOfInterestId, P.[Name] AS PointOfInterestName, 
			P.[Identifier] AS PointOfInterestIdentifier,  
			SUM(DATEDIFF(SECOND, '0:00:00', [POIV].[ElapsedTime])) AS ElapsedTimeInSeconds, 1 AS AutomaticValue
	
	FROM	[dbo].[PointOfInterestVisited] POIV WITH (NOLOCK)
			INNER JOIN [dbo].[PersonOfInterest] S WITH (NOLOCK) ON S.[Id] = POIV.[IdPersonOfInterest]
			INNER JOIN [dbo].[PointOfInterest] P WITH (NOLOCK) ON P.[Id] = POIV.[IdPointOfInterest]
	
	WHERE	@IncludeAutomaticVisits = 1 -- Only select something if @IncludeAutomaticVisits = 1
			AND POIV.DeletedByNotVisited = 0 AND ((POIV.[LocationOutDate] IS NULL
			AND Tzdb.IsGreaterOrSameSystemDate(POIV.[LocationInDate], @DateFrom) = 1 AND Tzdb.IsLowerOrSameSystemDate(POIV.[LocationInDate], @DateTo) = 1)
				OR (POIV.[LocationInDate] BETWEEN @DateFrom AND @DateTo)
				OR (POIV.[LocationOutDate] BETWEEN @DateFrom AND @DateTo)) AND
				--OR (CAST(Tzdb.FromUtc(POIV.[LocationInDate]) AS [sys].[date]) BETWEEN CAST(Tzdb.FromUtc(@DateFrom) AS [sys].[date]) AND CAST(Tzdb.FromUtc(@DateTo) AS [sys].[date])) 
				--OR (CAST(Tzdb.FromUtc(POIV.[LocationOutDate]) AS [sys].[date]) 
				--BETWEEN CAST(Tzdb.FromUtc(@DateFrom) AS [sys].[date]) AND CAST(Tzdb.FromUtc(@DateTo) AS [sys].[date]))) AND
			((@IdDepartments IS NULL) OR (S.[IdDepartment] IS NULL) OR (dbo.CheckValueInList(S.[IdDepartment], @IdDepartments) = 1)) AND
			((@Types IS NULL) OR (dbo.CheckCharValueInList(S.[Type], @Types) = 1)) AND
			((@IdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(S.[Id], @IdPersonsOfInterest) = 1)) AND
			((@IdPointsOfInterest IS NULL) OR (dbo.CheckValueInList(P.[Id], @IdPointsOfInterest) = 1)) AND			
			((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1)) AND
			((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1)) AND
			((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1)) AND
			((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1)) AND
			[dbo].IsVisitedLocationInPointHourWindow(POIV.[IdPointOfInterest], POIV.[LocationInDate], POIV.[LocationOutDate]) = 1
	
	GROUP BY  P.[Id], P.[Name], P.[Identifier]	 


	UNION

	-- Marcas Manuales
	SELECT	P.[Id] AS PointOfInterestId, P.[Name] AS PointOfInterestName, 
			P.[Identifier] AS PointOfInterestIdentifier,  
			SUM(DATEDIFF(SECOND, '0:00:00', [POIV].[ElapsedTime])) AS ElapsedTimeInSeconds, 2 AS AutomaticValue
	
	FROM	[dbo].[PointOfInterestManualVisited] POIV
			INNER JOIN [dbo].[PointOfInterest] P ON P.[Id] = POIV.[IdPointOfInterest]
			INNER JOIN [dbo].[PersonOfInterest] S ON S.[Id] = POIV.[IdPersonOfInterest]
	
	WHERE	POIV.DeletedByNotVisited = 0 AND ((POIV.[CheckOutDate] IS NULL 
			AND Tzdb.IsGreaterOrSameSystemDate(POIV.[CheckInDate], @DateFrom) = 1 AND Tzdb.IsLowerOrSameSystemDate(POIV.[CheckInDate], @DateTo) = 1)
				OR (POIV.[CheckInDate] BETWEEN @DateFrom AND @DateTo)
				OR (POIV.[CheckOutDate] BETWEEN @DateFrom AND @DateTo)) AND
				--OR (CAST(Tzdb.FromUtc(POIV.[CheckInDate]) AS [sys].[date]) BETWEEN CAST(Tzdb.FromUtc(@DateFrom) AS [sys].[date]) AND CAST(Tzdb.FromUtc(@DateTo) AS [sys].[date])) 
				--OR (CAST(Tzdb.FromUtc(POIV.[CheckOutDate]) AS [sys].[date]) 
				--BETWEEN CAST(Tzdb.FromUtc(@DateFrom) AS [sys].[date]) AND CAST(Tzdb.FromUtc(@DateTo) AS [sys].[date]))) AND
			((@IdDepartments IS NULL) OR (S.[IdDepartment] IS NULL) OR (dbo.CheckValueInList(S.[IdDepartment], @IdDepartments) = 1)) AND
			((@Types IS NULL) OR (dbo.CheckCharValueInList(S.[Type], @Types) = 1)) AND
			((@IdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(S.[Id], @IdPersonsOfInterest) = 1)) AND
			((@IdPointsOfInterest IS NULL) OR (dbo.CheckValueInList(P.[Id], @IdPointsOfInterest) = 1)) AND			
			((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1)) AND
			((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1)) AND
			((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1)) AND
			((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1)) 

	GROUP BY  P.[Id], P.[Name], P.[Identifier]

	UNION

	-- Marcas NFC
	SELECT	P.[Id] AS PointOfInterestId, P.[Name] AS PointOfInterestName, 
			P.[Identifier] AS PointOfInterestIdentifier,  
			SUM(DATEDIFF(SECOND, '0:00:00', [POIV].[ElapsedTime])) AS ElapsedTimeInSeconds, 3 AS AutomaticValue
	
	FROM	[dbo].[PointOfInterestMark] POIV
			INNER JOIN [dbo].[PointOfInterest] P ON P.[Id] = POIV.[IdPointOfInterest]
			INNER JOIN [dbo].[PersonOfInterest] S ON S.[Id] = POIV.[IdPersonOfInterest]
	
	WHERE	POIV.DeletedByNotVisited = 0 AND ((POIV.[CheckOutDate] IS NULL 
			AND Tzdb.IsGreaterOrSameSystemDate(POIV.[CheckInDate], @DateFrom) = 1 AND Tzdb.IsLowerOrSameSystemDate(POIV.[CheckInDate], @DateTo) = 1)
				OR (POIV.[CheckInDate] BETWEEN @DateFrom AND @DateTo)
				OR (POIV.[CheckOutDate] BETWEEN @DateFrom AND @DateTo)) AND
				--OR (CAST(Tzdb.FromUtc(POIV.[CheckInDate]) AS [sys].[date]) BETWEEN CAST(Tzdb.FromUtc(@DateFrom) AS [sys].[date]) AND CAST(Tzdb.FromUtc(@DateTo) AS [sys].[date])) 
				--OR (CAST(Tzdb.FromUtc(POIV.[CheckOutDate]) AS [sys].[date]) 
				--BETWEEN CAST(Tzdb.FromUtc(@DateFrom) AS [sys].[date]) AND CAST(Tzdb.FromUtc(@DateTo) AS [sys].[date]))) AND
			((@IdDepartments IS NULL) OR (S.[IdDepartment] IS NULL) OR (dbo.CheckValueInList(S.[IdDepartment], @IdDepartments) = 1)) AND
			((@Types IS NULL) OR (dbo.CheckCharValueInList(S.[Type], @Types) = 1)) AND
			((@IdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(S.[Id], @IdPersonsOfInterest) = 1)) AND
			((@IdPointsOfInterest IS NULL) OR (dbo.CheckValueInList(P.[Id], @IdPointsOfInterest) = 1)) AND			
			((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1)) AND
			((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1)) AND
			((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1)) AND
			((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1)) 

	GROUP BY  P.[Id], P.[Name], P.[Identifier]


	RETURN 
END
