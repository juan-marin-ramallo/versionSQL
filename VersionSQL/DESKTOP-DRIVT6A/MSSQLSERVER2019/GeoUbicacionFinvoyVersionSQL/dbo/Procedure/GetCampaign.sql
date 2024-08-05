/****** Object:  Procedure [dbo].[GetCampaign]    Committed by VersionSQL https://www.versionsql.com ******/

-- =====================================================
-- Author:		Fede Sobri
-- Create date: 05/06/2019
-- Description:	SP para obtener una campaña
-- =====================================================
CREATE PROCEDURE [dbo].[GetCampaign]
 @CampaignId [sys].[int]
AS
BEGIN
	SELECT C.[Id], C.[Name], C.[Description], C.[StartDate], C.[EndDate], C.[Prize], C.[PersonOfInterestIdWinner], C.[AllPointOfInterest], C.[AllPersonOfInterest]
			, CTC.[Id] AS IdCampaignConquestType, CTC.[IdConquestType], CTC.[Weight], CTC.[Amount], CT.[Name] AS ConquestName
	FROM [dbo].[Campaign] C WITH (NOLOCK)
		INNER JOIN [dbo].[CampaignConquestType] CTC WITH (NOLOCK) ON CTC.IdCampaign = C.Id 
		INNER JOIN [dbo].[Parameter] CT WITH (NOLOCK) ON CT.Id = CTC.IdConquestType
	WHERE C.Id = @CampaignId
	GROUP BY C.[Id], C.[Name], C.[Description], C.[StartDate], C.[EndDate], C.[Prize], C.[PersonOfInterestIdWinner], C.[AllPointOfInterest], C.[AllPersonOfInterest]
			, CTC.[Id] , CTC.[IdConquestType], CTC.[Weight], CTC.[Amount], CT.[Name]
	ORDER BY C.Id ASC, CTC.IdConquestType

	SELECT CP.IdPersonOfInterest
	FROM dbo.[CampaignPersonOfInterest] CP
	WHERE [IdCampaign] = @CampaignId

	SELECT CP.IdPointOfInterest
	FROM dbo.[CampaignPointOfInterest] CP
	WHERE [IdCampaign] = @CampaignId
END
