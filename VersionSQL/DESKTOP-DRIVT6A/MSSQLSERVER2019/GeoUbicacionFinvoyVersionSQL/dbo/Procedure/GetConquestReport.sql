/****** Object:  Procedure [dbo].[GetConquestReport]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 06/06/2019
-- Description:	SP para obtener las conquistas.
-- =============================================
CREATE PROCEDURE [dbo].[GetConquestReport]
(
	 @DateFrom [sys].[datetime]
	,@DateTo [sys].[datetime]
	,@IdDepartments [sys].[varchar](max) = NULL
	,@IdPersonsOfInterest [sys].[VARCHAR](MAX) = NULL
	,@IdPointsOfInterest [sys].[VARCHAR](MAX) = NULL
	,@IdCampaign [sys].[VARCHAR](MAX) = NULL
	,@IdConquestType [sys].[VARCHAR](MAX) = NULL
	,@IdUser [sys].INT = NULL
)
AS
BEGIN
    SELECT C.[IdCampaign], C.[CampaignName], C.[CampaignDescription], C.[CampaignStartDate], C.[CampaignEndDate], C.[CampaignPrize]
			, SUM(C.[Amount]) AS [Total], SUM(IIF(C.[IsVerified] IS NOT NULL AND C.[IsVerified] = 1, C.[Amount], 0)) AS TotalVerified, SUM(IIF(C.[IsVerified] IS NOT NULL AND C.[IsVerified] = 0, C.[Amount], 0)) AS TotalRejected
	FROM [dbo].[GetDetailedConquest] (@DateFrom, @DateTo, @IdDepartments, @IdPersonsOfInterest, @IdPointsOfInterest, @IdCampaign , @IdConquestType, @IdUser) AS C
	GROUP BY C.[IdCampaign], C.[CampaignName], C.[CampaignDescription], C.[CampaignStartDate], C.[CampaignEndDate], C.[CampaignPrize]
	ORDER BY C.[IdCampaign] DESC
END
