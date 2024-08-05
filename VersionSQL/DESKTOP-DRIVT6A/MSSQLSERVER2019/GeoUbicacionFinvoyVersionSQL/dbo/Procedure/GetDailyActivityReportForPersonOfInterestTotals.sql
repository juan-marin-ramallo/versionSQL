/****** Object:  Procedure [dbo].[GetDailyActivityReportForPersonOfInterestTotals]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 20/06/2018
-- Description:	SP para obtener las visitas realizadas para utilizar en el reporte de actividad diaria (PARTE DE TOTALES)
-- =============================================
CREATE PROCEDURE [dbo].[GetDailyActivityReportForPersonOfInterestTotals]
(
	 @DateFrom [sys].[datetime]
	,@DateTo [sys].[datetime]
	,@IdPersonsOfInterest [sys].[varchar](max) = NULL	
	,@IdPointsOfInterest [sys].[varchar](max) = NULL
	,@IdUser [sys].[int] = NULL
	,@UseAutomaticMarks [sys].[bit] = 1
	,@IncludeDaysNoVisits [sys].[bit] = 1
)
AS
BEGIN

	SELECT A.[GroupedDate], A.[IdPointOfInterest] AS [IdPointOfInterest], A.[IdPersonOfInterest], A.[PersonOfInterestName], 
				A.[PersonOfInterestLastName], A.[PersonOfInterestIdentifier], A.[LocationInDate], 
				A.[LocationOutDate], A.[ActionDate], A.[ElapsedTime], A.RestEntryDate, A.RestExitDate, A.[RestHours], A.[WorkHours]
	FROM [dbo].[DailyActivityReportForPersonOfInterest](@DateFrom, @DateTo, @IdPersonsOfInterest, @IdPointsOfInterest, @IdUser, @UseAutomaticMarks, @IncludeDaysNoVisits) A
	GROUP BY A.[GroupedDate], A.[IdPersonOfInterest], A.[PersonOfInterestName], 
				A.[PersonOfInterestLastName], A.[PersonOfInterestIdentifier], A.[LocationInDate], 
				A.[LocationOutDate], A.[ActionDate], A.[ElapsedTime], A.RestEntryDate, A.RestExitDate, A.[RestHours], A.[WorkHours],A.[IdPointOfInterest]
	ORDER BY A.[IdPersonOfInterest], a.[GroupedDate], a.[ActionDate] ASC

		--DECLARE @DateFromAux [sys].[date] = Tzdb.FromUtc(@DateFrom)
		--DECLARE @DateToTruncated [sys].[date]
		--SET @DateToTruncated = Tzdb.FromUtc(@DateTo)

		--CREATE TABLE #AllPersonOfInterestDates
		--(
		--	GroupedDate [sys].[DATETIME], IdPersonOfInterest [sys].[int], PersonOfInterestName [sys].[varchar](50)
		--	, PersonOfInterestLastName [sys].[varchar](50), PersonOfInterestIdentifier [sys].[varchar](50)
		--)

		--WHILE @DateFromAux <= @DateToTruncated
		--BEGIN

		--	INSERT INTO #AllPersonOfInterestDates(GroupedDate, IdPersonOfInterest, PersonOfInterestName, PersonOfInterestLastName,
		--	  PersonOfInterestIdentifier)
		--	SELECT DISTINCT Tzdb.ToUtc(@DateFromAux), P.[Id], P.[Name], P.[LastName], P.[Identifier]
		--	FROM [dbo].[AvailablePersonOfInterest] P
		--	  JOIN PersonOfInterestSchedule S ON S.IdPersonOfInterest = P.Id
		--	WHERE S.IdDayOfWeek = DATEPART(WEEKDAY, @DateFromAux)
		--	  AND ((@IdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(P.[Id], @IdPersonsOfInterest) = 1))		

		--	SET @DateFromAux = DATEADD(DAY, 1, @DateFromAux)
		--END

		--CREATE TABLE #PointsOfInterestVisitedSomeWay
		--(
		--	[IdPointOfInterestVisited] [sys].[int], IdPersonOfInterest [sys].[int], PersonOfInterestName [sys].[varchar](50), 
		--	[PersonOfInterestLastName] [sys].[varchar](50), PersonOfInterestIdentifier [sys].[varchar](50), [ActionDate] [sys].[datetime], 
		--	[Radius] [sys].[int], [MinElapsedTimeForVisit] [sys].[int], [IdDepartment] [sys].[INT], [Latitude] [sys].[decimal](25,20), 
		--	[Longitude] [sys].[decimal](25,20), [Address] [sys].[varchar](250),
		--	[LocationInDate] [sys].[datetime], [LocationOutDate] [sys].[datetime], [IdPointOfInterest] [sys].[int], 
		--	[PointOfInterestName] [sys].[varchar](100), [ElapsedTime] [sys].[time], 
		--	PointOfInterestIdentifier [sys].[varchar](50), AutomaticValue [sys].[int], Reason [sys].[varchar](100), Number [sys].[int]
		--)

		--;WITH TablePartition AS 
		--( 
		--	SELECT	[IdPointOfInterestVisited], [IdPersonOfInterest], [PersonOfInterestName], 
		--			[PersonOfInterestLastName],[PersonOfInterestIdentifier], [ActionDate], [Radius], [MinElapsedTimeForVisit], [IdDepartment],
		--			[Latitude], [Longitude], [Address], [LocationInDate],[LocationOutDate],
		--			[IdPointOfInterest], [PointOfInterestName],[ElapsedTime], [PointOfInterestIdentifier],
		--			[AutomaticValue],[Reason],
		--			ROW_NUMBER() OVER 
		--			( 
		--				PARTITION BY IdPersonOfInterest, IdPointOfInterest, ActionDate 
		--				ORDER BY AutomaticValue 
		--			) AS Number 
		--	 FROM [dbo].PointsOfInterestVisitedDailyReport(@DateFrom, @DateTo, @IdPersonsOfInterest, 
		--		@IdPointsOfInterest, @UseAutomaticMarks, @IdUser) POIV
		--) 

		--INSERT INTO #PointsOfInterestVisitedSomeWay(IdPointOfInterestVisited , IdPersonOfInterest , PersonOfInterestName, 
		--		PersonOfInterestLastName,[PersonOfInterestIdentifier], [ActionDate], [Radius], [MinElapsedTimeForVisit], [IdDepartment],
		--		[Latitude], [Longitude], [Address], LocationInDate , LocationOutDate , [IdPointOfInterest], 
		--		[PointOfInterestName], [ElapsedTime] , PointOfInterestIdentifier , AutomaticValue , Reason, Number)
		--SELECT * FROM TablePartition WHERE Number = 1

		--IF @IncludeDaysNoVisits = 0 OR @UseAutomaticMarks = 0
		--BEGIN
		--	SELECT A.*, M1.[Date] AS RestEntryDate, M2.[Date] AS RestExitDate, PS.[RestHours], PS.[WorkHours]
		--	from(
		--	SELECT	COALESCE (AD.[GroupedDate], p.[ActionDate]) as GroupedDate, 
		--			P.[IdPointOfInterest], P.[PointOfInterestName], 
		--			COALESCE (AD.[IdPersonOfInterest], P.[IdPersonOfInterest]) as IdPersonOfInterest, 
		--			COALESCE (AD.[PersonOfInterestName], P.[PersonOfInterestName]) as PersonOfInterestName, 
		--			COALESCE (AD.[PersonOfInterestLastName], P.[PersonOfInterestLastName]) as PersonOfInterestLastName, 
		--			COALESCE (AD.[PersonOfInterestIdentifier], P.[PersonOfInterestIdentifier]) as PersonOfInterestIdentifier, 
		--			P.[Address], P.[Latitude], P.[Longitude], P.[IdDepartment], P.[LocationInDate], 
		--			P.[LocationOutDate], P.[ActionDate], P.[PointOfInterestIdentifier], P.[ElapsedTime]
	
		--	FROM	#AllPersonOfInterestDates AD
		--			FULL OUTER JOIN #PointsOfInterestVisitedSomeWay P ON AD.[IdPersonOfInterest] = P.[IdPersonOfInterest]
		--			AND Tzdb.AreSameSystemDates(AD.[GroupedDate], P.[ActionDate]) = 1
	
		--	GROUP
		--	BY		COALESCE (AD.[GroupedDate], p.[ActionDate]), 
		--			P.[IdPointOfInterest], P.[PointOfInterestName], 
		--			COALESCE (AD.[IdPersonOfInterest], P.[IdPersonOfInterest]), 
		--			COALESCE (AD.[PersonOfInterestName], P.[PersonOfInterestName]), 
		--			COALESCE (AD.[PersonOfInterestLastName], P.[PersonOfInterestLastName]), 
		--			COALESCE (AD.[PersonOfInterestIdentifier], P.[PersonOfInterestIdentifier]), 
		--			P.[Address], P.[Latitude], P.[Longitude], P.[IdDepartment], P.[LocationInDate], 
		--			P.[LocationOutDate], P.[ActionDate], P.[PointOfInterestIdentifier], P.[ElapsedTime])A

		--	LEFT JOIN dbo.[Mark] M1 WITH(NOLOCK) ON M1.[IdPersonOfInterest] = A.[IdPersonOfInterest] AND M1.[Type] = 'ED'
		--										AND Tzdb.AreSameSystemDates(M1.[Date], A.[ActionDate]) = 1
		--	LEFT JOIN dbo.[Mark] M2 WITH(NOLOCK) ON M2.[IdPersonOfInterest] = A.[IdPersonOfInterest] AND M2.[Type] = 'SD'
		--										AND Tzdb.AreSameSystemDates(M2.[Date], A.[ActionDate]) = 1
		--	LEFT JOIN dbo.[PersonOfInterestSchedule] PS WITH(NOLOCK) ON PS.[IdPersonOfInterest] = A.[IdPersonOfInterest]
		--										AND DATEPART(WEEKDAY, Tzdb.FromUtc(A.[GroupedDate])) = PS.[IdDayOfWeek]

		--	ORDER BY		a.[IdPersonOfInterest], a.[GroupedDate], a.[ActionDate] ASC 
		--END
		--ELSE
		--BEGIN
		--	SELECT A.*, M1.[Date] AS RestEntryDate, M2.[Date] AS RestExitDate, PS.[RestHours], PS.[WorkHours]
		--	from(
		--		SELECT	AD.[GroupedDate], P.[IdPointOfInterest], P.[PointOfInterestName], AD.[IdPersonOfInterest], 
		--				AD.[PersonOfInterestName], AD.[PersonOfInterestLastName], AD.[PersonOfInterestIdentifier], 
		--				P.[Address], P.[Latitude], P.[Longitude], P.[IdDepartment], P.[LocationInDate], 
		--				P.[LocationOutDate], P.[ActionDate], P.[PointOfInterestIdentifier], P.[ElapsedTime]
	
		--		FROM	#AllPersonOfInterestDates AD
		--				LEFT JOIN #PointsOfInterestVisitedSomeWay P ON AD.[IdPersonOfInterest] = P.[IdPersonOfInterest]
		--				AND Tzdb.AreSameSystemDates(AD.[GroupedDate], P.[ActionDate]) = 1
	
		--		GROUP
		--		BY		AD.[GroupedDate], P.[IdPointOfInterest], P.[PointOfInterestName], AD.[IdPersonOfInterest], 
		--				AD.[PersonOfInterestName], AD.[PersonOfInterestLastName], AD.[PersonOfInterestIdentifier], 
		--				P.[Address], P.[Latitude], P.[Longitude], P.[IdDepartment], P.[LocationInDate], P.[LocationOutDate],
		--				P.[ActionDate], P.[PointOfInterestIdentifier], P.[ElapsedTime])A

		--		LEFT JOIN dbo.[Mark] M1 WITH(NOLOCK) ON M1.[IdPersonOfInterest] = A.[IdPersonOfInterest] AND M1.[Type] = 'ED'
		--											AND Tzdb.AreSameSystemDates(M1.[Date], A.[ActionDate]) = 1
		--		LEFT JOIN dbo.[Mark] M2 WITH(NOLOCK) ON M2.[IdPersonOfInterest] = A.[IdPersonOfInterest] AND M2.[Type] = 'SD'
		--											AND Tzdb.AreSameSystemDates(M2.[Date], A.[ActionDate]) = 1
		--		LEFT JOIN dbo.[PersonOfInterestSchedule] PS WITH(NOLOCK) ON PS.[IdPersonOfInterest] = A.[IdPersonOfInterest]
		--											AND DATEPART(WEEKDAY, Tzdb.FromUtc(A.[GroupedDate])) = PS.[IdDayOfWeek]

		--		ORDER BY		a.[IdPersonOfInterest], a.[GroupedDate], a.[ActionDate] ASC 	
		--END

		--DROP TABLE #PointsOfInterestVisitedSomeWay
		--DROP TABLE #AllPersonOfInterestDates
END
