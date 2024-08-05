/****** Object:  Procedure [dbo].[GetPointOfInterestFromRoute]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		gl
-- Create date: 15/07/2015
-- Description:	SP para obtener TODOS LOS PUNTOS DE INTERES DEFINIDOS PARA UNA RUTA
-- =============================================
CREATE PROCEDURE [dbo].[GetPointOfInterestFromRoute]
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
	SELECT	RP.[Id] as IdRoute, RD.[RouteDate],P.[Id] AS PointOfInterestId, P.[Name] AS PointOfInterestName,
			P.[Address] AS PointOfInterestAddress,P.[Latitude] AS PointOfInterestLatitude, P.[Longitude] AS PointOfInterestLongitude,
			P.[Radius] AS PointOfInterestRadius, P.[MinElapsedTimeForVisit] AS POIMinElapsedTimeForVisit, P.[IdDepartment], S.[Id] AS PersonOfInterestId, P.[Identifier] AS Identifier
	FROM	[dbo].[RouteGroup] RG WITH (NOLOCK)
			INNER JOIN [dbo].[RoutePointOfInterest] RP WITH (NOLOCK) ON RP.[IdRouteGroup] = RG.[Id]
			LEFT JOIN [dbo].[RouteDetail] RD WITH (NOLOCK) ON RD.[IdRoutePointOfInterest] = RP.[Id]
			INNER JOIN [dbo].[PointOfInterest] P WITH (NOLOCK) ON P.[Id] = RP.[IdPointOfInterest]	
			INNER JOIN [dbo].[PersonOfInterest] S WITH (NOLOCK) ON S.[Id] = RG.[IdPersonOfInterest]		
	WHERE	(CAST(Tzdb.FromUtc(RD.[RouteDate]) AS [sys].[date]) BETWEEN CAST(Tzdb.FromUtc(@DateFrom) AS [sys].[date]) AND CAST(Tzdb.FromUtc(@DateTo) AS [sys].[date])) AND
			((@IdDepartments IS NULL) OR (S.[IdDepartment] IS NULL) OR (dbo.CheckValueInList(S.[IdDepartment], @IdDepartments) = 1)) AND
			((@Types IS NULL) OR (dbo.CheckCharValueInList(S.[Type], @Types) = 1)) AND
			((@IdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(S.[Id], @IdPersonsOfInterest) = 1)) AND
			((@IdPointsOfInterest IS NULL) OR (dbo.CheckValueInList(P.[Id], @IdPointsOfInterest) = 1)) AND			
			((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1)) AND
			((@IdDepartments IS NOT NULL) OR (@IdUser IS NOT NULL AND dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1))	
			--AND RD.Disabled = 'False' AND R.Deleted = 'False' AND P.[Deleted] = 0 AND S.[Deleted] = 0
			AND RD.[Disabled] = 0
	GROUP BY  RP.[Id], RD.[RouteDate], P.[Id], P.[Name],
				P.[Address] ,P.[Latitude], P.[Longitude] ,
				P.[Radius] , P.[MinElapsedTimeForVisit], P.[IdDepartment],S.[Id], P.[Identifier]
	ORDER BY RP.[Id] desc
END
