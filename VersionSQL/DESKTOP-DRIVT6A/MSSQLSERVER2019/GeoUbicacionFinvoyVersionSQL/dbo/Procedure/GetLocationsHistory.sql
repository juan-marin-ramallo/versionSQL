/****** Object:  Procedure [dbo].[GetLocationsHistory]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 12/10/2012
-- Description:	SP para obtener el historial de ubicaciones de un repositor dado
-- =============================================
CREATE PROCEDURE [dbo].[GetLocationsHistory]
(
	 @DateFrom [sys].[datetime]
	,@DateTo [sys].[datetime]
	,@IdDepartments [sys].[varchar](1000) = NULL
	,@Types [sys].[varchar](1000) = NULL
	,@IdPersonsOfInterest [sys].[varchar](max) = NULL
	,@IdPointsOfInterest [sys].[varchar](max) = NULL	
	,@IdUser [sys].[int] = NULL
)
AS
BEGIN
	DECLARE @LocDateFrom [sys].[datetime]
	DECLARE @LocDateTo [sys].[datetime]
	DECLARE @LocIdDepartments [sys].[varchar](1000)
	DECLARE @LocTypes [sys].[varchar](1000)
	DECLARE @LocIdPersonsOfInterest [sys].[varchar](1000)
	DECLARE @LocIdPointsOfInterest [sys].[varchar](1000)
	DECLARE @LocIdUser [sys].[int]

	SET @LocDateFrom = @DateFrom
	SET @LocDateTo = @DateTo
	SET @LocIdDepartments = @IdDepartments
	SET @LocTypes = @Types
	SET @LocIdPersonsOfInterest = @IdPersonsOfInterest
	SET @LocIdPointsOfInterest = @IdPointsOfInterest
	SET @LocIdUser = @IdUser

	
	DECLARE @FilteredLocations TABLE (
		[Id] int not null, [PersonOfInterestId] int not null, [Date] datetime not null, [Latitude] decimal (25,20), [Longitude] decimal (25,20), [Processed] bit not null, [BatteryLevel] decimal(5,2), [PersonOfInterestName] varchar(50), [PersonOfInterestLastName] varchar(50), [PersonOfInterestMobilePhoneNumber] varchar(50)
	);
	INSERT INTO @FilteredLocations([Id], [PersonOfInterestId], [Date], [Latitude], [Longitude], [Processed], [BatteryLevel], [PersonOfInterestName], [PersonOfInterestLastName], [PersonOfInterestMobilePhoneNumber]) 
	SELECT 	LR.[Id], LR.[IdPersonOfInterest] AS PersonOfInterestId, LR.[Date], LR.Latitude, LR.Longitude, LR.[Processed], LR.[BatteryLevel],
					LR.[PersonOfInterestName], LR.[PersonOfInterestLastName], LR.[PersonOfInterestMobilePhoneNumber]
		FROM		[dbo].[LocationReport] LR WITH (NOLOCK) 
		WHERE		LR.[Date] BETWEEN @LocDateFrom AND @LocDateTo AND
					((@LocIdDepartments IS NULL) OR (LR.[PersonOfInterestIdDepartment] IS NULL) OR (dbo.CheckValueInList(LR.[PersonOfInterestIdDepartment], @LocIdDepartments) = 1)) AND
					((@LocTypes IS NULL) OR (dbo.CheckCharValueInList(LR.[Type], @LocTypes) = 1)) AND
					((@LocIdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(LR.[IdPersonOfInterest], @LocIdPersonsOfInterest) = 1)) AND
					((@LocIdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(LR.[PersonOfInterestIdDepartment], @LocIdUser) = 1)) AND				
					((@LocIdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(LR.[IdPersonOfInterest], @LocIdUser) = 1))
	GROUP BY	LR.[Id], LR.[IdPersonOfInterest], LR.[Date], LR.Latitude, LR.Longitude, LR.[Processed], LR.[BatteryLevel],
					LR.[PersonOfInterestName], LR.[PersonOfInterestLastName], LR.[PersonOfInterestMobilePhoneNumber]

	;WITH LHView ([Id], [PersonOfInterestId], [Date], [Latitude], [Longitude], [Processed], [BatteryLevel], [PersonOfInterestName], [PersonOfInterestLastName], [PersonOfInterestMobilePhoneNumber]) AS
	(
		SELECT		LR.[Id], LR.PersonOfInterestId, LR.[Date], ISNULL(POIVR.[LatitudeIn], LR.[Latitude]) AS Latitude, ISNULL(POIVR.[LongitudeIn], LR.[Longitude]) AS Longitude, LR.[Processed], LR.[BatteryLevel],
					LR.[PersonOfInterestName], LR.[PersonOfInterestLastName], LR.[PersonOfInterestMobilePhoneNumber]
		FROM		@FilteredLocations LR LEFT OUTER JOIN
					[dbo].[PointOfInterestVisited] POIVR WITH (NOLOCK) ON LR.[Id] >= POIVR.[IdLocationIn] AND (POIVR.[IdLocationOut] IS NULL OR LR.[Id] < POIVR.[IdLocationOut]) AND POIVR.[IdPersonOfInterest] = LR.[PersonOfInterestId]				
		WHERE		(@LocIdPointsOfInterest IS NULL) OR (dbo.CheckValueInList(POIVR.[IdPointOfInterest], @LocIdPointsOfInterest) = 1)
		GROUP BY	LR.[Id], LR.[PersonOfInterestId], LR.[Date], ISNULL(POIVR.[LatitudeIn], LR.[Latitude]), ISNULL(POIVR.[LongitudeIn], LR.[Longitude]), LR.[Processed], LR.[BatteryLevel],
					LR.[PersonOfInterestName], LR.[PersonOfInterestLastName], LR.[PersonOfInterestMobilePhoneNumber]
	)

	SELECT		MIN(LH.[Id]) AS Id, LH.[PersonOfInterestId], MIN(LH.[Date]) AS [Date], MAX(LH.[Date]) AS DateMax, LH.[Latitude], LH.[Longitude], LH.[Processed], MIN(LH.[BatteryLevel]) AS BatteryLevel, LH.[PersonOfInterestName], LH.[PersonOfInterestLastName], LH.[PersonOfInterestMobilePhoneNumber]
	FROM		(
					SELECT	[Id], [PersonOfInterestId], [Date], [Latitude], [Longitude], [Processed], [BatteryLevel], [PersonOfInterestName], [PersonOfInterestLastName], [PersonOfInterestMobilePhoneNumber],
							(row_number() over (partition by [PersonOfInterestId] order by [Date]) -
							 row_number() over (partition by [PersonOfInterestId], [Latitude], [Longitude] order by [Date])
							) as GroupNumber
					FROM	LHView
				) LH
	GROUP BY	LH.[PersonOfInterestId], LH.[Latitude], LH.[Longitude], LH.[Processed], LH.[PersonOfInterestName], LH.[PersonOfInterestLastName], LH.[PersonOfInterestMobilePhoneNumber], LH.GroupNumber
	ORDER BY	LH.[PersonOfInterestId], MIN(LH.[Date])

	
	--old, pre usar temporal table y modificar POIV
	--;WITH LHView ([Id], [PersonOfInterestId], [Date], [Latitude], [Longitude], [Processed], [BatteryLevel], [PersonOfInterestName], [PersonOfInterestLastName], [PersonOfInterestMobilePhoneNumber]) AS
	--(
	--	SELECT		LR.[Id], LR.[IdPersonOfInterest] AS PersonOfInterestId, LR.[Date], ISNULL(POIVR.[Latitude], LR.[Latitude]) AS Latitude, ISNULL(POIVR.[Longitude], LR.[Longitude]) AS Longitude, LR.[Processed], LR.[BatteryLevel],
	--				LR.[PersonOfInterestName], LR.[PersonOfInterestLastName], LR.[PersonOfInterestMobilePhoneNumber]
	--	FROM		[dbo].[LocationReport] LR WITH (NOLOCK) LEFT OUTER JOIN
	--				[dbo].[PointOfInterestVisitedReport] POIVR WITH (NOLOCK) ON LR.[Id] >= POIVR.[IdLocationIn] AND (POIVR.[IdLocationOut] IS NULL OR LR.[Id] < POIVR.[IdLocationOut]) AND POIVR.[IdPersonOfInterest] = LR.[IdPersonOfInterest]				
	--	WHERE		LR.[Date] BETWEEN @LocDateFrom AND @LocDateTo AND
	--				((@LocIdDepartments IS NULL) OR (LR.[PersonOfInterestIdDepartment] IS NULL) OR (dbo.CheckValueInList(LR.[PersonOfInterestIdDepartment], @LocIdDepartments) = 1)) AND
	--				((@LocTypes IS NULL) OR (dbo.CheckCharValueInList(LR.[Type], @LocTypes) = 1)) AND
	--				((@LocIdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(LR.[IdPersonOfInterest], @LocIdPersonsOfInterest) = 1)) AND
	--				((@LocIdPointsOfInterest IS NULL) OR (dbo.CheckValueInList(POIVR.[IdPointOfInterest], @LocIdPointsOfInterest) = 1)) AND
	--				((@LocIdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(LR.[PersonOfInterestIdDepartment], @LocIdUser) = 1)) AND				
	--				((@LocIdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(LR.[IdPersonOfInterest], @LocIdUser) = 1))
	--	GROUP BY	LR.[Id], LR.[IdPersonOfInterest], LR.[Date], ISNULL(POIVR.[Latitude], LR.[Latitude]), ISNULL(POIVR.[Longitude], LR.[Longitude]), LR.[Processed], LR.[BatteryLevel],
	--				LR.[PersonOfInterestName], LR.[PersonOfInterestLastName], LR.[PersonOfInterestMobilePhoneNumber]
	--)

	-- OLD Versión Sobri)
	--SELECT		MIN(LR.[Id]) AS [Id], LR.[IdPersonOfInterest] AS PersonOfInterestId, min(LR.[Date]) as [Date], max(LR.[Date]) as DateMax , ISNULL(POIVR.[Latitude], LR.[Latitude]) AS Latitude, ISNULL(POIVR.[Longitude], LR.[Longitude]) AS Longitude, LR.[Processed], min(LR.[BatteryLevel]) AS [BatteryLevel],
	--			LR.[PersonOfInterestName], LR.[PersonOfInterestLastName], LR.[PersonOfInterestMobilePhoneNumber]
	--FROM		[dbo].[LocationReport] LR LEFT OUTER JOIN
	--			[dbo].[PointOfInterestVisitedReport] POIVR ON LR.[Id] >= POIVR.[IdLocationIn] AND (POIVR.[IdLocationOut] IS NULL OR LR.[Id] < POIVR.[IdLocationOut]) AND POIVR.[IdPersonOfInterest] = LR.[IdPersonOfInterest]				
	--WHERE		LR.[Date] BETWEEN @LocDateFrom AND @LocDateTo AND
	--			((@LocIdDepartments IS NULL) OR (LR.[PersonOfInterestIdDepartment] IS NULL) OR (dbo.CheckValueInList(LR.[PersonOfInterestIdDepartment], @LocIdDepartments) = 1)) AND
	--			((@LocTypes IS NULL) OR (dbo.CheckCharValueInList(LR.[Type], @LocTypes) = 1)) AND
	--			((@LocIdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(LR.[IdPersonOfInterest], @LocIdPersonsOfInterest) = 1)) AND
	--			((@LocIdPointsOfInterest IS NULL) OR (dbo.CheckValueInList(POIVR.[IdPointOfInterest], @LocIdPointsOfInterest) = 1)) AND
	--			((@LocIdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(LR.[PersonOfInterestIdDepartment], @LocIdUser) = 1)) AND				
	--			((@LocIdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(LR.[IdPersonOfInterest], @LocIdUser) = 1))
	--GROUP BY	ISNULL(POIVR.[Id], LR.[BatteryLevel]), LR.[IdPersonOfInterest], ISNULL(POIVR.[Latitude], LR.[Latitude]), ISNULL(POIVR.[Longitude], LR.[Longitude]), LR.[Processed], --LR.[BatteryLevel],
	--			LR.[PersonOfInterestName], LR.[PersonOfInterestLastName], LR.[PersonOfInterestMobilePhoneNumber]
	--ORDER BY	LR.[IdPersonOfInterest], min(LR.[Date]) ASC




	-- OLD)
	--SELECT		LR.[Id], LR.[IdPersonOfInterest] AS PersonOfInterestId, LR.[Date], ISNULL(POIVR.[Latitude], LR.[Latitude]) AS Latitude, ISNULL(POIVR.[Longitude], LR.[Longitude]) AS Longitude, LR.[Processed], LR.[BatteryLevel],
	--			LR.[PersonOfInterestName], LR.[PersonOfInterestLastName], LR.[PersonOfInterestMobilePhoneNumber]
	--FROM		[dbo].[LocationReport] LR LEFT OUTER JOIN
	--			[dbo].[PointOfInterestVisitedReport] POIVR ON LR.[Id] >= POIVR.[IdLocationIn] AND (POIVR.[IdLocationOut] IS NULL OR LR.[Id] < POIVR.[IdLocationOut]) AND POIVR.[IdPersonOfInterest] = LR.[IdPersonOfInterest]				
	--WHERE		LR.[Date] BETWEEN @LocDateFrom AND @LocDateTo AND
	--			((@LocIdDepartments IS NULL) OR (LR.[PersonOfInterestIdDepartment] IS NULL) OR (dbo.CheckValueInList(LR.[PersonOfInterestIdDepartment], @LocIdDepartments) = 1)) AND
	--			((@LocTypes IS NULL) OR (dbo.CheckCharValueInList(LR.[Type], @LocTypes) = 1)) AND
	--			((@LocIdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(LR.[IdPersonOfInterest], @LocIdPersonsOfInterest) = 1)) AND
	--			((@LocIdPointsOfInterest IS NULL) OR (dbo.CheckValueInList(POIVR.[IdPointOfInterest], @LocIdPointsOfInterest) = 1)) AND
	--			((@LocIdDepartments IS NOT NULL) OR (@LocIdUser IS NOT NULL AND dbo.CheckDepartmentInUserDepartments(LR.[PersonOfInterestIdDepartment], @LocIdUser) = 1)) AND				
	--			((@LocIdUser IS NULL) OR (dbo.CheckZoneInUserZones(LR.[PersonOfInterestIdZone], @LocIdUser) = 1))
	--GROUP BY	LR.[Id], LR.[IdPersonOfInterest], LR.[Date], ISNULL(POIVR.[Latitude], LR.[Latitude]), ISNULL(POIVR.[Longitude], LR.[Longitude]), LR.[Processed], LR.[BatteryLevel],
	--			LR.[PersonOfInterestName], LR.[PersonOfInterestLastName], LR.[PersonOfInterestMobilePhoneNumber]
	--ORDER BY	LR.[IdPersonOfInterest], LR.[Date] ASC
END
