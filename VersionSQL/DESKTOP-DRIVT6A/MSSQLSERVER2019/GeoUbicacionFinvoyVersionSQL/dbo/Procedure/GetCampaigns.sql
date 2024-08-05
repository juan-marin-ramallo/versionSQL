/****** Object:  Procedure [dbo].[GetCampaigns]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Fede Sobri
-- Create date: 05/06/2019
-- Description:	SP para obtener las campañas.
-- =============================================
CREATE PROCEDURE [dbo].[GetCampaigns]
(
	 @DateFrom [sys].[DATETIME]  = NULL
	,@DateTo [sys].[DATETIME]  = NULL
	,@IdDepartments [sys].[varchar](max) = NULL
	,@IdPersonsOfInterest [sys].[VARCHAR](MAX) = NULL
	,@IdPointsOfInterest [sys].[VARCHAR](MAX) = NULL
	,@IdCampaign [sys].[VARCHAR](MAX) = NULL
	,@IdConquestType [sys].[VARCHAR](MAX) = NULL
	,@IdUser [sys].INT = NULL
)
AS
BEGIN
	SELECT C.[Id], C.[Name], C.[Description], C.[StartDate], C.[EndDate], C.[Prize], C.[PersonOfInterestIdWinner], C.[AllPointOfInterest], C.[AllPersonOfInterest]
	FROM [dbo].[Campaign] C
		INNER JOIN [dbo].[CampaignConquestType] CTC  WITH (NOLOCK) ON C.[Id] = CTC.[IdCampaign]
		LEFT OUTER JOIN [dbo].[CampaignPersonOfInterest] CS  WITH (NOLOCK) ON C.[Id] = CS.[IdCampaign]
		LEFT OUTER JOIN [dbo].[CampaignPointOfInterest] CPOI  WITH (NOLOCK) ON C.[Id] = CPOI.[IdCampaign]
		LEFT OUTER JOIN [dbo].[PersonOfInterest] S WITH (NOLOCK) ON CS.[IdPersonOfInterest] = S.[Id]
		LEFT OUTER JOIN [dbo].[PointOfInterest] POI WITH (NOLOCK) ON CPOI.[IdPointOfInterest] = POI.[Id]
	WHERE C.[Deleted] = 0
		AND (@DateFrom IS NULL OR @DateFrom <= StartDate OR @DateFrom <= EndDate)
		AND (@DateTo IS NULL OR @DateTo >= StartDate OR @DateTo >= EndDate)			
		AND (@IdDepartments IS NULL OR S.[IdDepartment] IS NULL OR dbo.CheckValueInList(S.[IdDepartment], @IdDepartments) = 1) 
		AND	(@IdPersonsOfInterest IS NULL OR C.AllPersonOfInterest = 1 OR dbo.CheckValueInList(S.[Id], @IdPersonsOfInterest) = 1) 
		AND	(@IdPointsOfInterest IS NULL OR C.AllPointOfInterest = 1 OR dbo.CheckValueInList(POI.[Id], @IdPointsOfInterest) = 1) 
		AND (@IdCampaign IS NULL OR dbo.CheckValueInList(C.[Id], @IdCampaign) = 1)
		AND (@IdConquestType IS NULL OR dbo.CheckValueInList(CTC.[IdConquestType], @IdConquestType) = 1)
		AND (@IdUser IS NULL OR C.AllPersonOfInterest = 1 OR dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1)
		AND (@IdUser IS NULL OR C.AllPersonOfInterest = 1 OR dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1)
		AND (@IdUser IS NULL OR C.AllPointOfInterest = 1 OR dbo.CheckUserInPointOfInterestZones(POI.[Id], @IdUser) = 1)
		AND (@IdUser IS NULL OR C.AllPointOfInterest = 1 OR dbo.CheckDepartmentInUserDepartments(POI.[IdDepartment], @IdUser) = 1)
	GROUP BY  C.[Id], C.[Name], C.[Description], C.[StartDate], C.[EndDate], C.[Prize], C.[PersonOfInterestIdWinner], C.[AllPointOfInterest], C.[AllPersonOfInterest]
	ORDER BY C.[Id] DESC
END
