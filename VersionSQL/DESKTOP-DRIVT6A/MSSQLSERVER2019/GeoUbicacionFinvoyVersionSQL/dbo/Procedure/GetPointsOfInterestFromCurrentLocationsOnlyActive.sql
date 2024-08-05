/****** Object:  Procedure [dbo].[GetPointsOfInterestFromCurrentLocationsOnlyActive]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Diego Caceres
-- Create date: 24/08/2016
-- Description:	SP para obtener los datos de los puntos de interés cercanos a las posiciones actuales ACTIVAS
-- Change: Matias Corso - 21/10/2016 - Agrego la fecha y hora de la ubicación actual en el retorno
-- =============================================
CREATE PROCEDURE [dbo].[GetPointsOfInterestFromCurrentLocationsOnlyActive]
(
	 @IdDepartments [sys].[varchar](max) = NULL
	,@Types [sys].[varchar](max) = NULL
	,@IdPersonsOfInterest [sys].[varchar](max) = NULL
	,@IdUser [sys].[int] = NULL
)
AS
BEGIN
	DECLARE @CurrentLocationRadius [sys].[int]
	SET @CurrentLocationRadius = (SELECT CAST([Value] AS [sys].[int]) FROM [dbo].[ConfigurationTranslated] WITH (NOLOCK) WHERE [Id] = 12)

	;WITH PointsOfInterestView([Id], [Name], [Address], [Latitude], [Longitude], [LatLong], [Radius], [MinElapsedTimeForVisit], [IdDepartment], [Identifier])
	AS
	(
		SELECT	P.[Id], P.[Name], P.[Address], P.[Latitude], P.[Longitude], P.[LatLong], P.[Radius], P.[MinElapsedTimeForVisit], P.[IdDepartment], P.[Identifier]
		FROM	[dbo].[PointOfInterest] P WITH (NOLOCK)
				LEFT OUTER JOIN [dbo].[PointOfInterestZone] POIZ WITH (NOLOCK) ON POIZ.[IdPointOfInterest] = P.[Id]
		WHERE	P.[Deleted] = 0 AND
				((@IdUser IS NULL) OR
				 ((dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1) OR
				  (dbo.CheckZoneInUserZones(POIZ.[IdZone], @IdUser) = 1)))
	)
	,AvailablePersonOfInterestView([Id], [Type], [IdDepartment])
	AS
	(
		SELECT	[Id], [Type], [IdDepartment]
		FROM	[dbo].[AvailablePersonOfInterest] WITH (NOLOCK)
		WHERE	((@IdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList([Id], @IdPersonsOfInterest) = 1)) AND
				((@Types IS NULL) OR (dbo.CheckCharValueInList([Type], @Types) = 1)) AND
				((@IdDepartments IS NULL) OR ([IdDepartment] IS NULL) OR (dbo.CheckValueInList([IdDepartment], @IdDepartments) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones([Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments([IdDepartment], @IdUser) = 1))
	)
	
	SELECT		P.[Id], P.[Name], P.[Address], P.[Latitude], P.[Longitude], P.[Radius], P.[MinElapsedTimeForVisit], 
				P.[IdDepartment], CL.[Date] AS CurrentLocationDate, P.[Identifier]
	FROM		AvailablePersonOfInterestView S WITH (NOLOCK)
				INNER JOIN [dbo].[CurrentLocation] CL WITH (NOLOCK) ON CL.[IdPersonOfInterest] = S.[Id]
				INNER JOIN PointsOfInterestView P ON P.[LatLong].STDistance(CL.[LatLong]) - P.[Radius] < @CurrentLocationRadius
	WHERE		Tzdb.AreSameSystemDates(CL.Date, GETUTCDATE()) = 1
	GROUP BY	P.[Id], P.[Name], P.[Address], P.[Latitude], P.[Longitude], P.[Radius], P.[MinElapsedTimeForVisit], 
				P.[IdDepartment], CL.[Date], P.[Identifier]

END
