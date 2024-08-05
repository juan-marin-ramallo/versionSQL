/****** Object:  TableFunction [dbo].[PointsOfInterestVisitedFiltered]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 23/08/2016
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[PointsOfInterestVisitedFiltered]
(	
	@DateFrom [sys].[datetime] 
	,@DateTo [sys].[datetime]
	,@IdDepartments [sys].[varchar](max) = NULL
	,@Types [sys].[varchar](max) = NULL
	,@IdPersonsOfInterest [sys].[varchar](max) = NULL
	,@IdPointsOfInterest [sys].[varchar](max) = NULL
	,@IdUser [sys].[int] = NULL
)
RETURNS @t TABLE (IdPointOfInterestVisited [sys].[int], IdPersonOfInterest [sys].[int], PersonOfInterestName [sys].[varchar](50), 
			PersonOfInterestLastName [sys].[varchar](50), [IdLocationIn] [sys].[int], [LocationInDate] [sys].[datetime], [IdLocationOut] [sys].[int], 
			[LocationOutDate] [sys].[datetime], [IdPointOfInterest] [sys].[int], PointOfInterestName [sys].[varchar](100),  [ElapsedTime] [sys].[time],
			[Latitude] [sys].[decimal](25,20), [Longitude] [sys].[decimal](25,20), PointOfInterestIdentifier [sys].[varchar](50))	
AS
BEGIN

	INSERT INTO @t 
	SELECT	POIV.[Id] as IdPointOfInterestVisited, S.[Id] AS IdPersonOfInterest, S.[Name] AS PersonOfInterestName, 
			S.[LastName] AS PersonOfInterestLastName, [IdLocationIn], POIV.[LocationInDate], [IdLocationOut], 
			POIV.[LocationOutDate], [IdPointOfInterest], P.[Name] AS PointOfInterestName,  [ElapsedTime],
			P.[Latitude], P.[Longitude], P.[Identifier] AS PointOfInterestIdentifier	
	FROM	[dbo].[PointOfInterestVisited] POIV WITH (NOLOCK) 
			INNER JOIN [dbo].[PointOfInterest] P WITH (NOLOCK) ON P.[Id] = POIV.[IdPointOfInterest]
			LEFT OUTER JOIN [dbo].[PersonOfInterest] S WITH (NOLOCK) ON S.[Id] = POIV.[IdPersonOfInterest]
	WHERE	POIV.DeletedByNotVisited = 0 AND ((POIV.[LocationOutDate] IS NULL AND POIV.[LocationInDate] >= @DateFrom AND POIV.[LocationInDate] <= @DateTo) 
				OR (POIV.[LocationInDate] BETWEEN @DateFrom AND @DateTo) 
				OR (POIV.[LocationOutDate] BETWEEN @DateFrom AND @DateTo)) AND
			((@IdDepartments IS NULL) OR (S.[IdDepartment] IS NULL) OR (dbo.CheckValueInList(S.[IdDepartment], @IdDepartments) = 1)) AND
			((@Types IS NULL) OR (dbo.CheckCharValueInList(S.[Type], @Types) = 1)) AND
			((@IdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(S.[Id], @IdPersonsOfInterest) = 1)) AND
			((@IdPointsOfInterest IS NULL) OR (dbo.CheckValueInList(P.[Id], @IdPointsOfInterest) = 1)) AND			
			((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1)) AND
			((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1)) AND
			((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1)) AND
			((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1)) AND
			[dbo].IsVisitedLocationInPointHourWindow(POIV.[IdPointOfInterest], POIV.[LocationInDate], POIV.[LocationOutDate]) = 1
			--AND P.Deleted = 0 AND S.Deleted = 0

	GROUP BY  POIV.[Id], S.[Id], S.[Name], S.[LastName], [IdLocationIn], POIV.[LocationInDate], [IdLocationOut], POIV.[LocationOutDate], 
	          [IdPointOfInterest], P.[Name], [ElapsedTime], P.[Latitude], P.[Longitude], P.[Identifier]
	--ORDER BY POIV.[Id] desc)

	RETURN 
END
