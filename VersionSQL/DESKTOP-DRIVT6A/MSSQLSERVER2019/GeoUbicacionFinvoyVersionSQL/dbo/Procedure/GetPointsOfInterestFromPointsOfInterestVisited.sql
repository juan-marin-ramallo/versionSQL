/****** Object:  Procedure [dbo].[GetPointsOfInterestFromPointsOfInterestVisited]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 30/10/2012
-- Description:	SP para obtener los datos de los puntos de interés que fueron visitados
-- =============================================
CREATE PROCEDURE [dbo].[GetPointsOfInterestFromPointsOfInterestVisited]
(
	 @DateFrom [sys].[datetime]
	,@DateTo [sys].[datetime]
	,@IdDepartments [sys].[varchar](max) = NULL
	,@Types [sys].[varchar](max) = NULL
	,@IdPersonsOfInterest [sys].[varchar](max) = NULL
	,@IdPointsOfInterest [sys].[varchar](max) = NULL
	,@IdUser [sys].[int] = NULL
)
AS
BEGIN
	SELECT		P.[Id], P.[Name], P.[Address], P.[Latitude], P.[Longitude], P.[Radius], P.[MinElapsedTimeForVisit], P.[IdDepartment]
	FROM		[dbo].[PointOfInterest] P
				INNER JOIN [dbo].[PointOfInterestVisited] POIV ON POIV.[IdPointOfInterest] = P.[Id]
				LEFT OUTER JOIN [dbo].[PersonOfInterest] S ON S.[Id] = POIV.[IdPersonOfInterest]				
	WHERE		((POIV.[LocationOutDate] IS NULL AND POIV.[LocationInDate] >= @DateFrom) OR (POIV.[LocationInDate] BETWEEN @DateFrom AND @DateTo) OR (POIV.[LocationOutDate] BETWEEN @DateFrom AND @DateTo)) AND
				((@IdDepartments IS NULL) OR (S.[IdDepartment] IS NULL) OR (dbo.CheckValueInList(S.[IdDepartment], @IdDepartments) = 1)) AND
				((@Types IS NULL) OR (dbo.CheckCharValueInList(S.[Type], @Types) = 1)) AND
				((@IdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(S.[Id], @IdPersonsOfInterest) = 1)) AND
				((@IdPointsOfInterest IS NULL) OR (dbo.CheckValueInList(P.[Id], @IdPointsOfInterest) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1)) AND
				[dbo].IsVisitedLocationInPointHourWindow(POIV.[IdPointOfInterest], POIV.[LocationInDate], POIV.[LocationOutDate]) = 1

	GROUP BY	P.[Id], P.[Name], P.[Address], P.[Latitude], P.[Longitude], P.[Radius], P.[MinElapsedTimeForVisit], P.[IdDepartment]
END
