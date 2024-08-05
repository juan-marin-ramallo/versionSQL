/****** Object:  Procedure [dbo].[GetActiveCampaigns]    Committed by VersionSQL https://www.versionsql.com ******/

-- =====================================================
-- Author:		Laura Pérez
-- Create date: 04/04/2019
-- Description:	SP para obtener las campañas activas.
-- =====================================================
CREATE PROCEDURE [dbo].[GetActiveCampaigns]
	@PersonOfInterestId [sys].[INT]
AS
BEGIN
    DECLARE @Today [sys].[date]
	SET @Today = GETUTCDATE()

	SELECT C.[Id], C.[Name], C.[Description], C.[StartDate], C.[EndDate], C.[Prize], C.[PersonOfInterestIdWinner], C.[AllPointOfInterest], C.[AllPersonOfInterest]
			, CTC.[IdConquestType], CTC.[Weight], CTC.[Amount]
	FROM [dbo].[Campaign] C WITH (NOLOCK)
		LEFT OUTER JOIN [dbo].[CampaignPersonOfInterest] PC WITH (NOLOCK) ON C.Id = PC.IdCampaign
		INNER JOIN [dbo].[CampaignConquestType] CTC WITH (NOLOCK) ON CTC.IdCampaign = C.Id 
	 WHERE (C.[AllPersonOfInterest] = 1 OR Pc.IdPersonOfInterest = @PersonOfInterestId)
			AND C.Deleted = 0 
			AND C.StartDate <= @Today
			AND @Today <= C.EndDate
	GROUP BY C.[Id], C.[Name], C.[Description], C.[StartDate], C.[EndDate], C.[Prize], C.[PersonOfInterestIdWinner], C.[AllPointOfInterest], C.[AllPersonOfInterest]
			, CTC.[IdConquestType], CTC.[Weight], CTC.[Amount]
	ORDER BY C.Id ASC, CTC.IdConquestType
END
