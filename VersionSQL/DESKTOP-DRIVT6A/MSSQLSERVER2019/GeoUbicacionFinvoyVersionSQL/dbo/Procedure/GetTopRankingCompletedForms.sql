/****** Object:  Procedure [dbo].[GetTopRankingCompletedForms]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Gaston Legnani
-- Create date: 16/10/2015
-- Description:	SP para obtener el top 5 de las personas de interes con mas formularios completados.
-- =============================================
CREATE PROCEDURE [dbo].[GetTopRankingCompletedForms]

	 @DateFrom [sys].[datetime] = NULL
	,@DateTo [sys].[datetime] = NULL
	,@IdPersonsOfInterest [sys].[varchar](MAX) = null
	,@IdUser [sys].[INT] = NULL
AS
BEGIN

	SELECT  S.[Id] AS PersonOfInterestId, S.[Name] AS PersonOfInterestName, S.[LastName] AS PersonOfInterestLastName
	, SUM(IIF(P.[Id] IS NOT NULL, 1, 0)) CompletedFormsInPoiQuantity , SUM(IIF(P.[Id] IS NULL, 1, 0)) CompletedFormsOutsidePoiQuantity 
	FROM    [dbo].[PersonOfInterest] S WITH (NOLOCK)
			LEFT JOIN [dbo].[CompletedForm] CF WITH (NOLOCK) ON CF.[IdPersonOfInterest] = S.[Id]
			LEFT JOIN [dbo].[PointOfInterest] P WITH (NOLOCK) ON P.[Id] = CF.[IdPointOfInterest]
			LEFT JOIN [dbo].[Form] F WITH (NOLOCK) ON CF.[IdForm] = F.[Id]
	WHERE	
	((@DateFrom IS NULL) OR (@DateTo IS NULL) OR CF.[Date] BETWEEN @DateFrom AND @DateTo) AND
	((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(CF.[IdPointOfInterest], @IdUser) = 1)) AND
	((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1)) AND
    ((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1)) AND
	((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1)) AND
	(@IdPersonsOfInterest IS NULL OR dbo.CheckValueInList(S.[Id], @IdPersonsOfInterest) > 0)
	AND ((@IdUser IS NULL) OR (dbo.CheckUserInFormCompanies(F.[IdCompany], @IdUser) = 1)) 
	--AND S.Deleted = 0 AND P.Deleted = 0
	GROUP BY	S.[Id], S.[Name], S.[LastName]
	ORDER BY CompletedFormsInPoiQuantity DESC
    
	

END
