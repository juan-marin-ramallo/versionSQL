/****** Object:  Procedure [dbo].[GetIncidents]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Gastón Legnani
-- Create date: 02/08/2016
-- Description:	SP para obtener los incidentes
-- Change: Matias Corso - 19/10/17 - Agrego Tipo de incidente
-- =============================================
CREATE PROCEDURE [dbo].[GetIncidents]
(
	 @StartDate [sys].DATETIME
	,@EndDate [sys].DATETIME 
	,@IdPersonsOfInterest [sys].[varchar](max) = NULL
	,@IdPointsOfInterest [sys].[varchar](max) = NULL
	,@IdIncidentTypes [sys].[varchar](max) = NULL
	,@IdUser [sys].[int] = NULL
	,@ReturnImages [sys].[bit]
)
AS
BEGIN

	SELECT	I.[Id], I.[IdPersonOfInterest], I.[IdPointOfInterest], I.[CreatedDate],
			I.[Description], P.[Name] AS PersonOfInterestName, P.[LastName] AS PersonOfInterestLastName,
			P.[Identifier] AS PersonOfInterestIdentifier,
			POI.[Identifier] AS PointOfInterestIdentifier, POI.[Name] AS PointOfInterestName,
			IT.[Name] AS IncidentTypeName, IT.[Id] AS IdIncidentType, 
			(CASE @ReturnImages WHEN 1 THEN I.[ImageEncoded] ELSE NULL END) AS ImageArray,
      (CASE @ReturnImages WHEN 1 THEN I.[ImageUrl] ELSE NULL END) AS ImageUrl,
			(CASE @ReturnImages WHEN 1 THEN I.[ImageEncoded2] ELSE NULL END) AS ImageArray2,
      (CASE @ReturnImages WHEN 1 THEN I.[ImageUrl2] ELSE NULL END) AS ImageUrl2,
			(CASE @ReturnImages WHEN 1 THEN I.[ImageEncoded3] ELSE NULL END) AS ImageArray3,
      (CASE @ReturnImages WHEN 1 THEN I.[ImageUrl3] ELSE NULL END) AS ImageUrl3,
      IIF ( I.[ImageUrl] IS NOT NULL, 1, IIF ( I.[ImageEncoded] IS NOT NULL, 1, 0 ) ) AS HasImage1,
			IIF ( I.[ImageUrl2] IS NOT NULL, 1, IIF ( I.[ImageEncoded2] IS NOT NULL, 1, 0 ) ) AS HasImage2,
      IIF ( I.[ImageUrl3] IS NOT NULL, 1, IIF ( I.[ImageEncoded3] IS NOT NULL, 1, 0 ) ) AS HasImage3

	FROM	[dbo].[Incident] I WITH (NOLOCK)
			INNER JOIN [dbo].[PersonOfInterest] P WITH (NOLOCK) ON I.[IdPersonOfInterest] = P.[Id]
			INNER JOIN [dbo].[PointOfInterest] POI WITH (NOLOCK) ON I.[IdPointOfInterest] = POI.[Id]
			LEFT JOIN [dbo].[IncidentType] IT WITH (NOLOCK) ON I.[IdIncidentType] = IT.[Id]
	
	WHERE 	I.[CreatedDate] >= DATEADD(MINUTE, -1, @StartDate) AND I.[CreatedDate] <= DATEADD(MINUTE, 1, @EndDate) AND
			((@IdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(I.[IdPersonOfInterest], @IdPersonsOfInterest) = 1)) AND
			((@IdPointsOfInterest IS NULL) OR (dbo.CheckValueInList(I.[IdPointOfInterest], @IdPointsOfInterest) = 1)) AND
			((@IdIncidentTypes IS NULL) OR (dbo.CheckValueInList(I.[IdIncidentType], @IdIncidentTypes) = 1)) AND
			((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(POI.[Id], @IdUser) = 1)) AND
			((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(P.[Id], @IdUser) = 1)) AND
            ((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1)) AND
			((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(POI.[IdDepartment], @IdUser) = 1))

	ORDER BY I.[CreatedDate] desc
END
