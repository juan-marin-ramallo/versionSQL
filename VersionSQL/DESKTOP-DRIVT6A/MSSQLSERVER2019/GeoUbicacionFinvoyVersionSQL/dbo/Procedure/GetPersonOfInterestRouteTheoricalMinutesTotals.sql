/****** Object:  Procedure [dbo].[GetPersonOfInterestRouteTheoricalMinutesTotals]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Daniel Artigas
-- Create date: 27/08/2021
-- Description:	SP para obtener las horas teóricas
--              totales de rutas definidas por
--              Persona de Interés y Punto de Interés
-- =============================================
CREATE PROCEDURE [dbo].[GetPersonOfInterestRouteTheoricalMinutesTotals]
(
	 @DateFrom [sys].[datetime]
	,@DateTo [sys].[datetime]
	,@IdPersonsOfInterest [sys].[varchar](max) = NULL	
	,@IdPointsOfInterest [sys].[varchar](max) = NULL
	,@IdUser [sys].[int] = NULL
)
AS
BEGIN
	SELECT A.PersonOfInterestId,A.PersonOfInterestIdentifier,A.PersonOfInterestName, A.PersonOfInterestLastName,SUM(A.[TheoricalMinutes]) AS TheoricalMinutesTotals
	FROM
	(
		SELECT 	    S.[Id] AS PersonOfInterestId, S.[Identifier] AS PersonOfInterestIdentifier, S.[Name] AS PersonOfInterestName, S.[LastName] AS PersonOfInterestLastName,
					P.[Id] AS PointOfInterestId, P.[Identifier] AS PointOfInterestIdentifier, P.[Name] AS PointOfInterestName,
					SUM(RD.[TheoricalMinutes]) AS TheoricalMinutes
		FROM	    [dbo].[RouteGroup] RG WITH (NOLOCK)
					INNER JOIN [dbo].[RoutePointOfInterest] RPOI WITH (NOLOCK) ON RPOI.[IdRouteGroup] = RG.[Id] AND RPOI.[Deleted] = 0
					INNER JOIN [dbo].[PersonOfInterest] S WITH (NOLOCK) ON S.Id = RG.[IdPersonOfInterest] AND S.[Deleted] = 0
					INNER JOIN [dbo].[PointOfInterest] P WITH (NOLOCK) ON P.Id = RPOI.[IdPointOfInterest] AND P.[Deleted] = 0
					INNER JOIN [dbo].[RouteDetail] RD WITH (NOLOCK) ON RD.[IdRoutePointOfInterest] = RPOI.[Id] AND RD.[Disabled] = 0
		WHERE	    RG.[Deleted] = 0
					AND RD.[RouteDate] BETWEEN @DateFrom AND @DateTo
					AND ((@IdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(S.[Id], @IdPersonsOfInterest) = 1))
					AND ((@IdPointsOfInterest IS NULL) OR (dbo.CheckValueInList(P.[Id], @IdPointsOfInterest) = 1))
					AND ((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1))
					AND ((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1))
					AND ((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1))
					AND ((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1))
		GROUP BY	S.[Id], S.[Identifier], S.[Name], S.[LastName],
					P.[Id], P.[Identifier], P.[Name]
	) as A
	GROUP BY A.PersonOfInterestId,A.PersonOfInterestIdentifier,A.PersonOfInterestName, A.PersonOfInterestLastName
	ORDER BY A.[PersonOfInterestName], A.[PersonOfInterestLastName]
END
