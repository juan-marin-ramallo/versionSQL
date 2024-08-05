/****** Object:  Procedure [dbo].[GetConquests]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 06/06/2019
-- Description:	SP para obtener las conquistas.
-- =============================================
CREATE PROCEDURE [dbo].[GetConquests]
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
    SELECT C.[IdCampaign], C.[CampaignName], C.[CampaignDescription], C.[CampaignStartDate], C.[CampaignEndDate]
		, C.[ConquestTypeAmount], C.[ConquestTypeWeight], C.[ConquestTypeName], C.[ConquestTypeId]
		, C.[Id], C.[Date], C.[Description], C.[Active], C.[Amount]
		, C.[IdPersonOfInterest], C.[PersonName], C.[PersonLastName], C.[PersonIdentifier]
		, C.[IdPointOfInterest], C.[PointName], C.[PointIdentifier]
		, CI.[Id] AS [ImageId], CI.[ImageName], CI.[ImageUrl]
		, C.[IsVerified], C.[VerificationDate], C.[VerifierPersonId], C.[VerfierUserId]
		, C.[VerfierPersonName], C.[VerfierPersonLastName], C.[VerfierPersonIdentifier]
		, C.[VerfierUserName], C.[VerfierUserLastName], C.[VerfierUserUserName]
	FROM [dbo].[GetDetailedConquest] (@DateFrom, @DateTo, @IdDepartments, @IdPersonsOfInterest, @IdPointsOfInterest, @IdCampaign , @IdConquestType, @IdUser) AS C
		INNER JOIN [dbo].[conquestImage] CI WITH (NOLOCK) ON C.[Id] = CI.[IdConquest]
	GROUP BY C.[IdCampaign], C.[CampaignName], C.[CampaignDescription], C.[CampaignStartDate], C.[CampaignEndDate]
		, C.[ConquestTypeAmount], C.[ConquestTypeWeight], C.[ConquestTypeName], C.[ConquestTypeId]
		, C.[Id], C.[Date], C.[Description], C.[Active], C.[Amount]
		, C.[IdPersonOfInterest], C.[PersonName], C.[PersonLastName], C.[PersonIdentifier]
		, C.[IdPointOfInterest], C.[PointName], C.[PointIdentifier]
		, CI.[Id], CI.[ImageName], CI.[ImageUrl]
		, C.[IsVerified], C.[VerificationDate], C.[VerifierPersonId], C.[VerfierUserId]
		, C.[VerfierPersonName], C.[VerfierPersonLastName], C.[VerfierPersonIdentifier]
		, C.[VerfierUserName], C.[VerfierUserLastName], C.[VerfierUserUserName]
	ORDER BY C.[Id] DESC, CI.[Id] DESC
END
