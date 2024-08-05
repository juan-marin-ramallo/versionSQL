/****** Object:  TableFunction [dbo].[DailyActivityReportForPersonOfInterest]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 20/06/2018
-- Description:	SP para obtener las visitas realizadas para utilizar en el reporte de actividad diaria *
-- =============================================
CREATE FUNCTION [dbo].[DailyActivityReportForPersonOfInterest]
(
	 @DateFrom [sys].[datetime]
	,@DateTo [sys].[datetime]
	,@IdPersonsOfInterest [sys].[varchar](max) = NULL	
	,@IdPointsOfInterest [sys].[varchar](max) = NULL
	,@IdUser [sys].[int] = NULL
	,@UseAutomaticMarks [sys].[bit] = 1
	,@IncludeDaysNoVisits [sys].[bit] = 1
)
RETURNS @t TABLE (IdPointOfInterest [sys].[INT], [PointOfInterestName] [sys].[varchar](100)
			, IdPersonOfInterest [sys].[int], PersonOfInterestName [sys].[varchar](50), PersonOfInterestLastName [sys].[varchar](50), PersonOfInterestIdentifier [sys].[varchar](50)
			,[Address] [sys].[varchar](250), [Latitude] [sys].[decimal](25,20), [Longitude] [sys].[decimal](25,20), [IdDepartment] [sys].[INT]
			, LocationInDate [sys].[datetime], LocationOutDate [sys].[DATETIME], [ActionDate] [sys].[DATETIME]
			, PointOfInterestIdentifier [sys].[varchar](50), [ElapsedTime] [sys].[TIME]
			, [RestEntryDate] [sys].[DATETIME], [RestExitDate] [sys].[DATETIME], [RestHours] [sys].[TIME](7), [WorkHours] [sys].[TIME](7)
			, [GroupedDate] [sys].[datetime])	
AS
BEGIN
	
	DECLARE @PointsOfInterestVisitedSomeWay TABLE
	(
		[IdPointOfInterestVisited] [sys].[int], IdPersonOfInterest [sys].[int], PersonOfInterestName [sys].[varchar](50), 
		[PersonOfInterestLastName] [sys].[varchar](50), PersonOfInterestIdentifier [sys].[varchar](50), [ActionDate] [sys].[datetime], 
		[ActionDateSystem] [sys].[datetime], [Radius] [sys].[int], [MinElapsedTimeForVisit] [sys].[int], [IdDepartment] [sys].[INT],
        [Latitude] [sys].[decimal](25,20), [Longitude] [sys].[decimal](25,20), [Address] [sys].[varchar](250),
		[LocationInDate] [sys].[datetime], [LocationOutDate] [sys].[datetime], [IdPointOfInterest] [sys].[int], 
		[PointOfInterestName] [sys].[varchar](100), [ElapsedTime] [sys].[time], 
		PointOfInterestIdentifier [sys].[varchar](50), AutomaticValue [sys].[int], Reason [sys].[varchar](100), Number [sys].[int]
	)

    DECLARE @Marks TABLE
    (
        [IdPersonOfInterest] [sys].[int], [Date] [sys].[datetime], [DateSystem] [sys].[datetime], [Type] [sys].[varchar](5)
    )

	;WITH TablePartition AS 
	( 
		SELECT	[IdPointOfInterestVisited], [IdPersonOfInterest], [PersonOfInterestName], 
				[PersonOfInterestLastName],[PersonOfInterestIdentifier], [ActionDate], Tzdb.FromUtc([ActionDate]) AS ActionDateSystem,
                [Radius], [MinElapsedTimeForVisit], [IdDepartment], [Latitude], [Longitude], [Address],
                [LocationInDate], [LocationOutDate], [IdPointOfInterest], [PointOfInterestName],[ElapsedTime],
                [PointOfInterestIdentifier], [AutomaticValue],[Reason],
				ROW_NUMBER() OVER 
				( 
					PARTITION BY IdPersonOfInterest, IdPointOfInterest, Tzdb.FromUtc([ActionDate]) 
					ORDER BY AutomaticValue 
				) AS Number 
		 FROM [dbo].PointsOfInterestVisitedDailyReport(@DateFrom, @DateTo, @IdPersonsOfInterest, 
			@IdPointsOfInterest, @UseAutomaticMarks, @IdUser) POIV
	)

	INSERT INTO @PointsOfInterestVisitedSomeWay(IdPointOfInterestVisited , IdPersonOfInterest , PersonOfInterestName, 
			PersonOfInterestLastName,[PersonOfInterestIdentifier], [ActionDate], [ActionDateSystem], [Radius],
            [MinElapsedTimeForVisit], [IdDepartment], [Latitude], [Longitude], [Address], LocationInDate,
            LocationOutDate , [IdPointOfInterest], [PointOfInterestName], [ElapsedTime], PointOfInterestIdentifier,
            AutomaticValue , Reason, Number)
	SELECT * FROM TablePartition WHERE Number = 1
	
	DECLARE @DateFromAux [sys].[date] = Tzdb.FromUtc(@DateFrom)
	DECLARE @DateToTruncated [sys].[date]
	SET @DateToTruncated = Tzdb.FromUtc(@DateTo)

	INSERT INTO @Marks([IdPersonOfInterest], [Date], [DateSystem], [Type])
    SELECT  [IdPersonOfInterest], [Date], Tzdb.FromUtc([Date]), [Type]
    FROM    [dbo].[Mark] M WITH (NOLOCK)
	WHERE	((@IdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(M.[IdPersonOfInterest], @IdPersonsOfInterest) = 1))
			AND (M.[Date] BETWEEN @DateFrom AND @DateTo) AND (M.[Type] = 'ED' OR M.[Type] = 'SD')

	DECLARE @AllPersonOfInterestDates TABLE
	(
		GroupedDateSystem [sys].[DATETIME], IdPersonOfInterest [sys].[int], PersonOfInterestName [sys].[varchar](50)
		, PersonOfInterestLastName [sys].[varchar](50), PersonOfInterestIdentifier [sys].[varchar](50)
	)

	WHILE @DateFromAux <= @DateToTruncated 
	BEGIN

		INSERT INTO @AllPersonOfInterestDates(GroupedDateSystem, IdPersonOfInterest, PersonOfInterestName, PersonOfInterestLastName,
			PersonOfInterestIdentifier)
		SELECT DISTINCT @DateFromAux, P.[Id], P.[Name], P.[LastName], P.[Identifier]
		FROM [dbo].[PersonOfInterest] P
			JOIN PersonOfInterestSchedule S ON S.IdPersonOfInterest = P.Id
		WHERE P.[Deleted] = 0
			AND S.IdDayOfWeek = DATEPART(WEEKDAY, @DateFromAux)
			AND ((@IdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(P.[Id], @IdPersonsOfInterest) = 1))
			AND P.[Id] NOT IN (SELECT PA.[IdPersonOfInterest]
							FROM    [dbo].[PersonOfInterestAbsence] PA WITH (NOLOCK)
							WHERE   Tzdb.ToUtc(@DateFromAux) >= PA.[FromDate] AND (PA.[ToDate] IS NULL OR Tzdb.ToUtc(@DateFromAux) < PA.[ToDate]))

		SET @DateFromAux = DATEADD(DAY, 1, @DateFromAux)
	END

	IF @UseAutomaticMarks = 0
	--MARCAS MANUALES
	BEGIN
		INSERT INTO @t 
		SELECT A.[IdPointOfInterest], A.[PointOfInterestName], A.[IdPersonOfInterest], A.[PersonOfInterestName], 
				A.[PersonOfInterestLastName], A.[PersonOfInterestIdentifier], A.[Address], A.[Latitude], A.[Longitude], A.[IdDepartment], A.[LocationInDate], 
				A.[LocationOutDate], A.[ActionDate], A.[PointOfInterestIdentifier], A.[ElapsedTime], M1.[Date] AS RestEntryDate, M2.[Date] AS RestExitDate, PS.[RestHours], PS.[WorkHours]
				,Tzdb.ToUtc(CAST(A.[GroupedDate] AS Date)) as [GroupedDate]
		FROM (
			SELECT	P.[IdPointOfInterest], P.[PointOfInterestName], 
						COALESCE (AD.[IdPersonOfInterest], P.[IdPersonOfInterest]) as IdPersonOfInterest, 
						COALESCE (AD.[PersonOfInterestName], P.[PersonOfInterestName]) as PersonOfInterestName, 
						COALESCE (AD.[PersonOfInterestLastName], P.[PersonOfInterestLastName]) as PersonOfInterestLastName, 
						COALESCE (AD.[PersonOfInterestIdentifier], P.[PersonOfInterestIdentifier]) as PersonOfInterestIdentifier, 
						COALESCE (AD.[GroupedDateSystem], P.[ActionDate]) AS [GroupedDate],
						P.[Address], P.[Latitude], P.[Longitude], P.[IdDepartment], P.[LocationInDate], 
						P.[LocationOutDate], P.[ActionDate], COALESCE(P.[ActionDateSystem], AD.[GroupedDateSystem]) AS ActionDateSystem, P.[PointOfInterestIdentifier], P.[ElapsedTime]
			FROM	@AllPersonOfInterestDates AD
					FULL OUTER JOIN @PointsOfInterestVisitedSomeWay P ON AD.[IdPersonOfInterest] = P.[IdPersonOfInterest] AND DATEDIFF(DAY, AD.[GroupedDateSystem], P.[ActionDateSystem]) = 0
			GROUP BY		P.[IdPointOfInterest], P.[PointOfInterestName], 
					COALESCE (AD.[IdPersonOfInterest], P.[IdPersonOfInterest]), 
					COALESCE (AD.[PersonOfInterestName], P.[PersonOfInterestName]), 
					COALESCE (AD.[PersonOfInterestLastName], P.[PersonOfInterestLastName]), 
					COALESCE (AD.[PersonOfInterestIdentifier], P.[PersonOfInterestIdentifier]), 
					COALESCE (AD.[GroupedDateSystem], P.[ActionDate]),
					P.[Address], P.[Latitude], P.[Longitude], P.[IdDepartment], P.[LocationInDate], 
					P.[LocationOutDate], P.[ActionDate], COALESCE(P.[ActionDateSystem], AD.[GroupedDateSystem]), P.[PointOfInterestIdentifier], P.[ElapsedTime]) A
		LEFT JOIN @Marks M1 ON M1.[IdPersonOfInterest] = A.[IdPersonOfInterest] AND M1.[Type] = 'ED'
											AND DATEDIFF(DAY, M1.[DateSystem], A.[ActionDateSystem]) = 0
		LEFT JOIN @Marks M2 ON M2.[IdPersonOfInterest] = A.[IdPersonOfInterest] AND M2.[Type] = 'SD'
											AND DATEDIFF(DAY, M2.[DateSystem], A.[ActionDateSystem]) = 0
		LEFT JOIN dbo.[PersonOfInterestSchedule] PS WITH(NOLOCK) ON PS.[IdPersonOfInterest] = A.[IdPersonOfInterest]
											AND DATEPART(WEEKDAY, A.[ActionDateSystem]) = PS.[IdDayOfWeek]
		group by  
			a.[IdPointOfInterest], a.[PointOfInterestName], 
			A.IdPersonOfInterest, 
			A.PersonOfInterestName, 
			A.PersonOfInterestLastName, 
			A.PersonOfInterestIdentifier, 
			a.[Address], a.[Latitude], a.[Longitude],a.[IdDepartment], a.[LocationInDate], 
			a.[LocationOutDate], a.[ActionDate],A.[ActionDateSystem], a.[PointOfInterestIdentifier],a.[ElapsedTime],M1.[Date], M2.[Date], PS.[RestHours], PS.[WorkHours], A.[GroupedDate]
	
	
			ORDER BY		a.[IdPersonOfInterest], a.[ActionDate] ASC 
	END
	ELSE
	BEGIN
		
		IF @IncludeDaysNoVisits = 1
		BEGIN
		--Solo se tienen en cuenta dias configurados como de trabajo para las personas
			

			INSERT INTO @t 
			SELECT A.[IdPointOfInterest], A.[PointOfInterestName], A.[IdPersonOfInterest], A.[PersonOfInterestName], 
					A.[PersonOfInterestLastName], A.[PersonOfInterestIdentifier], A.[Address], A.[Latitude], A.[Longitude], A.[IdDepartment], A.[LocationInDate], 
					A.[LocationOutDate], A.[ActionDate], A.[PointOfInterestIdentifier], A.[ElapsedTime], M1.[Date] AS RestEntryDate, M2.[Date] AS RestExitDate, PS.[RestHours], PS.[WorkHours], A.[GroupedDate]
			from(
				SELECT	COALESCE (P.[IdPersonOfInterest], AD.[IdPersonOfInterest]) as IdPersonOfInterest, 
						COALESCE (P.[PersonOfInterestName], AD.[PersonOfInterestName]) as PersonOfInterestName, 
						COALESCE (P.[PersonOfInterestLastName], AD.[PersonOfInterestLastName]) as PersonOfInterestLastName, 
						COALESCE (P.[PersonOfInterestIdentifier], AD.[PersonOfInterestIdentifier]) as PersonOfInterestIdentifier, 
						COALESCE (P.[ActionDateSystem], AD.[GroupedDateSystem]) AS ActionDateSystem,
						P.[IdPointOfInterest], P.[PointOfInterestName],
						P.[Address], P.[Latitude], P.[Longitude], P.[IdDepartment], P.[LocationInDate], 
						P.[LocationOutDate], P.[ActionDate], P.[PointOfInterestIdentifier], P.[ElapsedTime], AD.[GroupedDateSystem] AS [GroupedDate]
	
				FROM	@AllPersonOfInterestDates AD
						LEFT JOIN @PointsOfInterestVisitedSomeWay P ON AD.[IdPersonOfInterest] = P.[IdPersonOfInterest] AND DATEDIFF(DAY, AD.[GroupedDateSystem], P.[ActionDateSystem]) = 0
	
				GROUP BY COALESCE (P.[IdPersonOfInterest], AD.[IdPersonOfInterest]), 
						COALESCE (P.[PersonOfInterestName], AD.[PersonOfInterestName]), 
						COALESCE (P.[PersonOfInterestLastName], AD.[PersonOfInterestLastName]), 
						COALESCE (P.[PersonOfInterestIdentifier], AD.[PersonOfInterestIdentifier]), 
						COALESCE (P.[ActionDateSystem], AD.[GroupedDateSystem]),
						P.[IdPointOfInterest], P.[PointOfInterestName],
						P.[Address], P.[Latitude], P.[Longitude], P.[IdDepartment], P.[LocationInDate], P.[LocationOutDate],
						P.[ActionDate], P.[PointOfInterestIdentifier], P.[ElapsedTime], AD.[GroupedDateSystem]) A
			LEFT JOIN @Marks M1 ON M1.[IdPersonOfInterest] = A.[IdPersonOfInterest] AND M1.[Type] = 'ED'
												AND DATEDIFF(DAY, M1.[DateSystem], A.[ActionDateSystem]) = 0
			LEFT JOIN @Marks M2 ON M2.[IdPersonOfInterest] = A.[IdPersonOfInterest] AND M2.[Type] = 'SD'
												AND DATEDIFF(DAY, M2.[DateSystem], A.[ActionDateSystem]) = 0
			LEFT JOIN dbo.[PersonOfInterestSchedule] PS WITH(NOLOCK) ON PS.[IdPersonOfInterest] = A.[IdPersonOfInterest]
												AND DATEPART(WEEKDAY, A.[ActionDateSystem]) = PS.[IdDayOfWeek]
			group by  
				a.[IdPointOfInterest], a.[PointOfInterestName], 
				A.IdPersonOfInterest, 
				A.PersonOfInterestName, 
				A.PersonOfInterestLastName, 
				A.PersonOfInterestIdentifier, 
				a.[Address], a.[Latitude], a.[Longitude],a.[IdDepartment], a.[LocationInDate], 
				a.[LocationOutDate], a.[ActionDate], A.[ActionDateSystem], a.[PointOfInterestIdentifier],a.[ElapsedTime],M1.[Date], M2.[Date], PS.[RestHours], PS.[WorkHours], A.[GroupedDate]
	
	
			ORDER BY		a.[IdPersonOfInterest], a.[ActionDate] ASC 	
		END
		ELSE
		BEGIN
			-- Se tienen en cuenta todos los dias, estèn configuirados o no
			INSERT INTO @t 
			SELECT A.[IdPointOfInterest], A.[PointOfInterestName], A.[IdPersonOfInterest], A.[PersonOfInterestName], 
					A.[PersonOfInterestLastName], A.[PersonOfInterestIdentifier], A.[Address], A.[Latitude], A.[Longitude], A.[IdDepartment], A.[LocationInDate], 
					A.[LocationOutDate], A.[ActionDate], A.[PointOfInterestIdentifier], A.[ElapsedTime], M1.[Date] AS RestEntryDate, M2.[Date] AS RestExitDate, 
					PS.[RestHours], PS.[WorkHours], A.[GroupedDate]
			from(
				SELECT	P.[IdPersonOfInterest] as IdPersonOfInterest, 
						P.[PersonOfInterestName] as PersonOfInterestName, 
						P.[PersonOfInterestLastName]as PersonOfInterestLastName, 
						P.[PersonOfInterestIdentifier] as PersonOfInterestIdentifier, 
						P.[ActionDateSystem] AS ActionDateSystem,
						P.[IdPointOfInterest], P.[PointOfInterestName],
						P.[Address], P.[Latitude], P.[Longitude], P.[IdDepartment], P.[LocationInDate], 
						P.[LocationOutDate], P.[ActionDate], P.[PointOfInterestIdentifier], P.[ElapsedTime], P.[ActionDate] AS [GroupedDate]
	
				FROM	 @PointsOfInterestVisitedSomeWay P 
	
				GROUP BY P.[IdPersonOfInterest], 
						P.[PersonOfInterestName], 
						P.[PersonOfInterestLastName], 
						P.[PersonOfInterestIdentifier], 
						P.[ActionDateSystem],
						P.[IdPointOfInterest], P.[PointOfInterestName],
						P.[Address], P.[Latitude], P.[Longitude], P.[IdDepartment], P.[LocationInDate], P.[LocationOutDate],
						P.[ActionDate], P.[PointOfInterestIdentifier], P.[ElapsedTime]) A
			LEFT JOIN @Marks M1 ON M1.[IdPersonOfInterest] = A.[IdPersonOfInterest] AND M1.[Type] = 'ED'
												AND DATEDIFF(DAY, M1.[DateSystem], A.[ActionDateSystem]) = 0
			LEFT JOIN @Marks M2 ON M2.[IdPersonOfInterest] = A.[IdPersonOfInterest] AND M2.[Type] = 'SD'
												AND DATEDIFF(DAY, M2.[DateSystem], A.[ActionDateSystem]) = 0
			LEFT JOIN dbo.[PersonOfInterestSchedule] PS WITH(NOLOCK) ON PS.[IdPersonOfInterest] = A.[IdPersonOfInterest]
												AND DATEPART(WEEKDAY, A.[ActionDateSystem]) = PS.[IdDayOfWeek]
			group by  
				a.[IdPointOfInterest], a.[PointOfInterestName], 
				A.IdPersonOfInterest, 
				A.PersonOfInterestName, 
				A.PersonOfInterestLastName, 
				A.PersonOfInterestIdentifier, 
				a.[Address], a.[Latitude], a.[Longitude],a.[IdDepartment], a.[LocationInDate], 
				a.[LocationOutDate], a.[ActionDate], A.[ActionDateSystem], a.[PointOfInterestIdentifier],a.[ElapsedTime],M1.[Date], M2.[Date], PS.[RestHours], PS.[WorkHours], A.[GroupedDate]
	
	
			ORDER BY		a.[IdPersonOfInterest], a.[ActionDate] ASC
		END

	END

	RETURN
END
