/****** Object:  Procedure [dbo].[GetDocuments]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Gastón Legnani
-- Create date: 26/05/2017
-- Description:	SP para obtener los REPORTES DE DOCUMENTOS
-- =============================================
CREATE PROCEDURE [dbo].[GetDocuments]
(
	 @StartDate [sys].DATETIME
	,@EndDate [sys].DATETIME 
	,@IdPersonsOfInterest [sys].[varchar](max) = NULL
	,@IdPointsOfInterest [sys].[varchar](max) = NULL
	,@IdDocumentTypes [sys].[varchar](max) = NULL
	,@IdUser [sys].[int] = NULL
	,@ReturnImages [sys].[bit]
)
AS
BEGIN

	SELECT	document.[Id], document.[IdDocument], document.[IdPersonOfInterest], document.[IdPointOfInterest], document.[Date],
			document.[DocumentType], document.[PersonOfInterestName], document.[PersonOfInterestLastName],
			document.[PointOfInterestIdentifier], document.[PointOfInterestName],
			document.[ImageArray], document.[ImageUrl], document.[ImageArray2], document.[ImageUrl2],
      document.[ImageArray3], document.[ImageUrl3], document.[HasImage1],
			document.[HasImage2], document.[HasImage3], document.[IsFullfilled],
			P.[Name] as PlanimetryName, A.[Name] as AgreementName, PRO.[Name] as PromotionName
	FROM
	(
	SELECT	D.[Id], D.[IdDocument], D.[IdPersonOfInterest], D.[IdPointOfInterest], D.[Date],
			D.[DocumentType], P.[Name] AS PersonOfInterestName, P.[LastName] AS PersonOfInterestLastName,
			POI.[Identifier] AS PointOfInterestIdentifier, POI.[Name] AS PointOfInterestName,
			(CASE @ReturnImages WHEN 1 THEN D.[ImageEncoded] ELSE NULL END) AS ImageArray,
			(CASE @ReturnImages WHEN 1 THEN D.[ImageUrl] ELSE NULL END) AS ImageUrl,
      (CASE @ReturnImages WHEN 1 THEN D.[ImageEncoded2] ELSE NULL END) AS ImageArray2,
			(CASE @ReturnImages WHEN 1 THEN D.[ImageUrl2] ELSE NULL END) AS ImageUrl2,
      (CASE @ReturnImages WHEN 1 THEN D.[ImageEncoded3] ELSE NULL END) AS ImageArray3,
      (CASE @ReturnImages WHEN 1 THEN D.[ImageUrl3] ELSE NULL END) AS ImageUrl3,
      IIF ( D.[ImageUrl] IS NOT NULL, 1, IIF ( D.[ImageEncoded] IS NOT NULL, 1, 0 ) ) AS HasImage1,
			IIF ( D.[ImageUrl2] IS NOT NULL, 1, IIF ( D.[ImageEncoded2] IS NOT NULL, 1, 0 ) ) AS HasImage2,
      IIF ( D.[ImageUrl3] IS NOT NULL, 1, IIF ( D.[ImageEncoded3] IS NOT NULL, 1, 0 ) ) AS HasImage3, D.[IsFullfilled]

	FROM	[dbo].[DocumentReport] D WITH (NOLOCK)
			INNER JOIN [dbo].[PersonOfInterest] P WITH (NOLOCK) ON D.[IdPersonOfInterest] = P.[Id]
			INNER JOIN [dbo].[PointOfInterest] POI WITH (NOLOCK) ON D.[IdPointOfInterest] = POI.[Id]
	
	WHERE 	(D.[Date] BETWEEN @StartDate  AND @EndDate) AND
			((@IdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(D.[IdPersonOfInterest], @IdPersonsOfInterest) = 1)) AND
			((@IdPointsOfInterest IS NULL) OR (dbo.CheckValueInList(D.[IdPointOfInterest], @IdPointsOfInterest) = 1)) AND
			((@IdDocumentTypes IS NULL) OR (dbo.CheckValueInList(D.[DocumentType], @IdDocumentTypes) = 1)) AND
			((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(POI.[Id], @IdUser) = 1)) AND
			((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(P.[Id], @IdUser) = 1)) AND
            ((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1)) AND
			((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(POI.[IdDepartment], @IdUser) = 1))
	) document

	LEFT JOIN [dbo].[Planimetry] P WITH (NOLOCK) ON document.[DocumentType] = 0 AND P.[Id] = document.[IdDocument] 
	LEFT JOIN [dbo].[Agreement] A WITH (NOLOCK) ON document.[DocumentType] = 1 AND A.[Id] = document.[IdDocument] 
	LEFT JOIN [dbo].[Promotion] PRO WITH (NOLOCK) ON document.[DocumentType] = 2 AND PRO.[Id] = document.[IdDocument] 
	
	ORDER BY document.[Date] desc
END
