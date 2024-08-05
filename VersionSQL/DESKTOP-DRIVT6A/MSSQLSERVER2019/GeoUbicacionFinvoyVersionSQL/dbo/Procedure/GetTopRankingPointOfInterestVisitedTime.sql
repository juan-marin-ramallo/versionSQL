/****** Object:  Procedure [dbo].[GetTopRankingPointOfInterestVisitedTime]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 03/12/2015
-- Description:	SP para obtener el ranking de tiempo de visita en los puntos de interés.
-- =============================================
CREATE PROCEDURE [dbo].[GetTopRankingPointOfInterestVisitedTime]
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
AS
BEGIN

	;WITH TablePartition AS 
	( 
		SELECT	PointOfInterestId, PointOfInterestName, 
					PointOfInterestIdentifier,ElapsedTimeInSeconds, AutomaticValue,
		 ROW_NUMBER() OVER 
		 ( 
			 PARTITION BY PointOfInterestId
			 ORDER BY AutomaticValue 
		 ) AS Number 
	 FROM [dbo].GetPointOfInterestVisitedTime(@DateFrom,@DateTo,@IdDepartments,@Types,@IdPersonsOfInterest,@IdPointsOfInterest, @IncludeAutomaticVisits, @IdUser) POIV
	) 

	SELECT		PointOfInterestId, PointOfInterestName, 
				PointOfInterestIdentifier,  ElapsedTimeInSeconds

	FROM		[TablePartition] POIV

	WHERE		[Number] = 1

	GROUP BY	PointOfInterestId, PointOfInterestName, 
				PointOfInterestIdentifier,  ElapsedTimeInSeconds

	order by	ElapsedTimeInSeconds desc

	--SELECT	P.[Id] AS PointOfInterestId, P.[Name] AS PointOfInterestName, 
	--		P.[Identifier] AS PointOfInterestIdentifier,  SUM(DATEDIFF(MILLISECOND, '0:00:00', [POIV].[ElapsedTime])) AS ElapsedTimeInMilliSeconds
	--FROM	[dbo].[PointOfInterestVisited] POIV
	--		INNER JOIN [dbo].[PersonOfInterest] S ON S.[Id] = POIV.[IdPersonOfInterest]
	--		INNER JOIN [dbo].[PointOfInterest] P ON P.[Id] = POIV.[IdPointOfInterest]
	--WHERE	POIV.DeletedByNotVisited = 0 AND ((POIV.[LocationOutDate] IS NULL AND CAST(POIV.[LocationInDate] AS [sys].[date]) >= CAST(@DateFrom AS [sys].[date]) AND CAST(POIV.[LocationInDate] AS [sys].[date]) <= CAST(@DateTo AS [sys].[date])) 
	--			OR (CAST(POIV.[LocationInDate] AS [sys].[date]) BETWEEN CAST(@DateFrom AS [sys].[date]) AND CAST(@DateTo AS [sys].[date])) 
	--			OR (CAST(POIV.[LocationOutDate] AS [sys].[date]) 
	--			BETWEEN CAST(@DateFrom AS [sys].[date]) AND CAST(@DateTo AS [sys].[date]))) AND
	--		((@IdDepartments IS NULL) OR (S.[IdDepartment] IS NULL) OR (dbo.CheckValueInList(S.[IdDepartment], @IdDepartments) = 1)) AND
	--		((@Types IS NULL) OR (dbo.CheckCharValueInList(S.[Type], @Types) = 1)) AND
	--		((@IdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(S.[Id], @IdPersonsOfInterest) = 1)) AND
	--		((@IdPointsOfInterest IS NULL) OR (dbo.CheckValueInList(P.[Id], @IdPointsOfInterest) = 1)) AND			
	--		((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1)) AND
	--		((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1)) AND
	--		((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1)) AND
	--		((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1))
	--		--AND S.Deleted = 0 AND P.Deleted = 0
	--GROUP BY  P.[Id], P.[Name], P.[Identifier]
	--ORDER BY ElapsedTimeInMilliSeconds desc
END
