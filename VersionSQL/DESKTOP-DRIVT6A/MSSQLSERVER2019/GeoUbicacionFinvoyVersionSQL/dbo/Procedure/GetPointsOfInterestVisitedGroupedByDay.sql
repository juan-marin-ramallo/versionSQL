/****** Object:  Procedure [dbo].[GetPointsOfInterestVisitedGroupedByDay]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 08/06/2016
-- Description:	SP para obtener los puntos de interés visitados ORDENADOS por persona y por dia
-- =============================================
CREATE PROCEDURE [dbo].[GetPointsOfInterestVisitedGroupedByDay]
(
	 @DateFrom [sys].[datetime]
	,@DateTo [sys].[datetime]
	,@IdDepartments [sys].[varchar](max) = NULL
	,@Types [sys].[varchar](max) = NULL
	,@IdPersonsOfInterest [sys].[varchar](max) = NULL	
	,@IdUser [sys].[int] = NULL
	,@IncludeAutomaticVisits [sys].[bit] = 1
)
AS
BEGIN

	CREATE TABLE #PointsOfInterestVisitedSomeWay
	(
		IdPointOfInterestVisited [sys].[int], IdPersonOfInterest [sys].[int], PersonOfInterestName [sys].[varchar](50), 
			PersonOfInterestLastName [sys].[varchar](50), [ActionDate] [sys].[datetime], [Radius] [sys].[int], 
			[MinElapsedTimeForVisit] [sys].[int], [IdDepartment] [sys].[INT], [Latitude] [sys].[decimal](25,20), 
			[Longitude] [sys].[decimal](25,20), [Address] [sys].[varchar](250),
			[LocationInDate] [sys].[datetime], [LocationOutDate] [sys].[datetime], [IdPointOfInterest] [sys].[int], 
			[PointOfInterestName] [sys].[varchar](100), [ElapsedTime] [sys].[time], 
			PointOfInterestIdentifier [sys].[varchar](50), AutomaticValue [sys].[int], Reason [sys].[varchar](100), Number [sys].[int]
	)

	;WITH TablePartition AS 
	( 
		SELECT	[IdPointOfInterestVisited], [IdPersonOfInterest], [PersonOfInterestName], 
				[PersonOfInterestLastName], [ActionDate], [Radius], [MinElapsedTimeForVisit], [IdDepartment],
				[Latitude], [Longitude], [Address], [LocationInDate],[LocationOutDate],
				[IdPointOfInterest], [PointOfInterestName],[ElapsedTime], [PointOfInterestIdentifier],
				[AutomaticValue],[Reason],
		 ROW_NUMBER() OVER 
		 ( 
			 PARTITION BY IdPersonOfInterest, IdPointOfInterest, CAST(Tzdb.FromUtc(ActionDate) AS [sys].[date])
			 ORDER BY AutomaticValue 
		 ) AS Number 
	 FROM [dbo].PointsOfInterestVisitedAnyWay(@DateFrom,@DateTo,@IdDepartments,@Types,@IdPersonsOfInterest, NULL,@IncludeAutomaticVisits,@IdUser) POIV
	) 

	INSERT INTO #PointsOfInterestVisitedSomeWay(IdPointOfInterestVisited , IdPersonOfInterest , PersonOfInterestName, 
			PersonOfInterestLastName, [ActionDate], [Radius], [MinElapsedTimeForVisit], [IdDepartment],
			[Latitude], [Longitude], [Address], LocationInDate , LocationOutDate , [IdPointOfInterest], 
			[PointOfInterestName], [ElapsedTime] , 
			PointOfInterestIdentifier , AutomaticValue , Reason, Number)
	 SELECT * FROM TablePartition WHERE Number = 1

	
	
	SELECT	P.[IdPointOfInterest], P.[PointOfInterestName], P.[IdPersonOfInterest], P.[PersonOfInterestName], 
			P.[PersonOfInterestLastName],P.[Address], P.[Latitude], P.[Longitude], P.[IdDepartment], P.[LocationInDate], 
			P.[LocationOutDate], P.[ActionDate], P.[IdPersonOfInterest], P.[PointOfInterestIdentifier], P.[ElapsedTime]
	
	FROM	#PointsOfInterestVisitedSomeWay P
	
	GROUP
	BY		P.[IdPointOfInterest], P.[PointOfInterestName], P.[IdPersonOfInterest], P.[PersonOfInterestName], 
			P.[PersonOfInterestLastName], P.[Address], P.[Latitude], P.[Longitude], P.[IdDepartment], P.[LocationInDate], P.[LocationOutDate],
			P.[ActionDate], P.[IdPersonOfInterest], P.[PointOfInterestIdentifier], P.[ElapsedTime]

	ORDER 
	BY		P.[IdPersonOfInterest], P.[ActionDate] ASC 



	DROP TABLE #PointsOfInterestVisitedSomeWay
	--SELECT A.[IdPointOfInterestVisited] , A.[IdPersonOfInterest], A.[PersonOfInterestName], 
	--		A.[PersonOfInterestLastName], A.[IdLocationIn], A.[LocationInDate], A.[IdLocationOut], 
	--		A.[LocationOutDate], A.[IdPointOfInterest], A.[PointOfInterestName],  A.[ElapsedTime],
	--		A.[Latitude], A.[Longitude], A.[PointOfInterestIdentifier], B.[IdRoutePointOfInterest] AS IdRoute
	
	--FROM	(

	--SELECT	POIV.[Id] as IdPointOfInterestVisited, S.[Id] AS IdPersonOfInterest, S.[Name] AS PersonOfInterestName, 
	--		S.[LastName] AS PersonOfInterestLastName, [IdLocationIn], POIV.[LocationInDate], [IdLocationOut], 
	--		POIV.[LocationOutDate], [IdPointOfInterest], P.[Name] AS PointOfInterestName,  [ElapsedTime],
	--		P.[Latitude], P.[Longitude], P.[Identifier] AS PointOfInterestIdentifier	
	--FROM	[dbo].[PointOfInterestVisited] POIV
	--		INNER JOIN [dbo].[PointOfInterest] P ON P.[Id] = POIV.[IdPointOfInterest]
	--		LEFT OUTER JOIN [dbo].[PersonOfInterest] S ON S.[Id] = POIV.[IdPersonOfInterest]
	--WHERE	POIV.DeletedByNotVisited = 0 AND ((POIV.[LocationOutDate] IS NULL AND POIV.[LocationInDate] >= @DateFrom AND POIV.[LocationInDate] <= @DateTo) 
	--			OR (POIV.[LocationInDate] BETWEEN @DateFrom AND @DateTo) 
	--			OR (POIV.[LocationOutDate] BETWEEN @DateFrom AND @DateTo)) AND
	--		((@IdDepartments IS NULL) OR (S.[IdDepartment] IS NULL) OR (dbo.CheckValueInList(S.[IdDepartment], @IdDepartments) = 1)) AND
	--		((@Types IS NULL) OR (dbo.CheckCharValueInList(S.[Type], @Types) = 1)) AND
	--		((@IdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(S.[Id], @IdPersonsOfInterest) = 1)) AND			
	--		((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1)) AND
	--		((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1)) AND
	--		((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1)) AND
	--		((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1))	 
	--		--AND P.Deleted = 0 AND s.Deleted = 0
	--GROUP BY  POIV.[Id], S.[Id], S.[Name], S.[LastName], [IdLocationIn], POIV.[LocationInDate], [IdLocationOut], POIV.[LocationOutDate], 
	--          [IdPointOfInterest], P.[Name], [ElapsedTime], P.[Latitude], P.[Longitude], P.[Identifier]
			  
	--		  ) A
	
	--LEFT JOIN (
			
	--		SELECT	RD.[IdRoutePointOfInterest], RD.[RouteDate], RG.[IdPersonOfInterest], RP.[IdPointOfInterest]
	--		FROM	[dbo].[RouteGroup] RG
	--				INNER JOIN [dbo].[RoutePointOfInterest] RP ON RP.[IdRouteGroup] = RG.[Id]
	--				INNER JOIN [dbo].[RouteDetail] RD ON RP.[Id] = RD.[IdRoutePointOfInterest]
	--		WHERE	(CAST(RD.[RouteDate] AS [sys].[date]) BETWEEN CAST(@DateFrom AS [sys].[date]) AND CAST(@DateTo AS [sys].[date])) AND
	--				((@IdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(RG.[IdPersonOfInterest], @IdPersonsOfInterest) = 1))
				
	--			) B

	--ON		A.[IdPointOfInterest] = B.[IdPointOfInterest] AND A.[IdPersonOfInterest] = B.[IdPersonOfInterest]
	--		AND CAST(A.[LocationInDate] AS [sys].[date]) = CAST(B.[RouteDate] AS [sys].[date])	
	
	
	--ORDER BY	A.[IdPersonOfInterest], A.[LocationInDate] ASC 
	
END
