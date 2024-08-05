/****** Object:  Procedure [dbo].[GetPointOfInterestCampaigns]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Laura Pérez
-- Create date: 25/03/2019
-- Description:	SP para obtener las campañas por puntos de interés.
-- =============================================
CREATE PROCEDURE [dbo].[GetPointOfInterestCampaigns]
(
	@PointOfInterestId [sys].[int]
)
AS
BEGIN 
	DECLARE @Today [sys].[date]
	SET @Today = GETUTCDATE()

   	SELECT C.[Id], C.[Name], C.[Description], C.[StartDate], C.[EndDate], C.[Prize], C.[PersonOfInterestIdWinner], C.[OutsidePointOfInterest], C.[AllPointOfInterest], C.[AllPersonOfInterest]
			, CTC.[IdConquestType], CTC.[Weight], CTC.[Amount]
	FROM [dbo].[Campaign] C WITH (NOLOCK)
		LEFT OUTER JOIN [dbo].[PointOfInterestCampaigns] PC WITH (NOLOCK) ON C.[Id] = PC.IdCampaign
		LEFT OUTER JOIN [dbo].[CampaignConquestType] CTC WITH (NOLOCK) ON CTC.IdCampaign = C.[Id] 
	WHERE (C.[AllPersonOfInterest] = 1 OR PC.[IdPointOfInterest] = @PointOfInterestId)
			AND C.Deleted = 0 
			AND C.StartDate <= @Today
			AND @Today <= C.EndDate
	GROUP BY C.[Id], C.[Name], C.[Description], C.[StartDate], C.[EndDate], C.[Prize], C.[PersonOfInterestIdWinner], C.[OutsidePointOfInterest], C.[AllPointOfInterest], C.[AllPersonOfInterest]
			, CTC.[IdConquestType], CTC.[Weight], CTC.[Amount]
	ORDER BY C.[Id] ASC, CTC.IdConquestType

END
