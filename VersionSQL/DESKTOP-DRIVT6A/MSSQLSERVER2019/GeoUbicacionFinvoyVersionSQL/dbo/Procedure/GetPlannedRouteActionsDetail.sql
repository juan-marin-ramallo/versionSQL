/****** Object:  Procedure [dbo].[GetPlannedRouteActionsDetail]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetPlannedRouteActionsDetail]
(
	@IdPersonOfInterest [sys].[INT],
	@IdPointOfInterest [sys].[INT]
)
AS
BEGIN
	DECLARE @Now [sys].[datetime]
	SET @Now = GETUTCDATE()

	DECLARE @PersonOfInterestType [sys].[CHAR](1) = (SELECT TOP 1 [Type] FROM [dbo].PersonOfInterest WITH (NOLOCK) WHERE [Id] = @IdPersonOfInterest)

	SELECT		pointInfo.PointOfInterestId, pointInfo.PointOfInterestName, pointInfo.PointOfInterestAddress, pointInfo.PointOfInterestLatitude,
				pointInfo.PointOfInterestLongitude,pointInfo.PointOfInterestIdentifier, pointInfo.PointOfInterestRadius,
				pointInfo.ContactName, 
				pointInfo.ContactPhoneNumber, pointInfo.PointOfInterestNFCTagId, pointInfo.PointOfInterestHasImage, pointInfo.CustomAttributeName, 
				pointInfo.CustomAttributeValue, pointInfo.CustomerAttributeId, pointInfo.CustomAttributeType, pointInfo.IdCustomAttributeGroup,
				pointInfo.HierarchyLevel1Id,
				pointInfo.HierarchyLevel1Name, pointInfo.HierarchyLevel2Id, pointInfo.HierarchyLevel2Name, pointInfo.DepartmentId,
				pointInfo.DepartmentName, pointInfo.PointOfInterestEmails,
				ISNULL(taskInfo.ExistsTask, 0) AS ExistsTasks, 
				CASE WHEN EXISTS (SELECT 1 FROM [dbo].Product where [Deleted] = 0) then 1 else 0 end as ExistsStock,
				ISNULL(assetInfo.ExistsAssets, 0) AS ExistsAssets,
				ISNULL(agreementInfo.ExistsAgreements, 0) AS ExistsAgreements,
				ISNULL(promotionInfo.ExistsPromotions, 0) AS ExistsPromotions,
				ISNULL(planimetryInfo.ExistsPlanimetry, 0) AS ExistsPlanimetry,
				ISNULL(campaignInfo.ExistsCampaigns, 0) AS ExistsCampaigns,
				ISNULL(agreementInfo.NumberContracts, 0) AS NumberContracts,
				ISNULL(promotionInfo.NumberPromotions, 0) AS NumberPromotions,
				ISNULL(planimetryInfo.NumberPlanimetries, 0) AS NumberPlanimetries
	FROM 

	(SELECT		POI.[Id] AS PointOfInterestId, POI.[Name] AS PointOfInterestName,
				POI.[Address] AS  PointOfInterestAddress, poi.[Latitude] AS PointOfInterestLatitude,
				POI.[Longitude] AS PointOfInterestLongitude, POI.[Radius] AS PointOfInterestRadius,
				POI.[Identifier] AS PointOfInterestIdentifier, POI.[ContactName], POI.ContactPhoneNumber,
				POI.[NFCTagId] AS PointOfInterestNFCTagId, IIF(POI.[Image] IS NULL, IIF(POI.[ImageUrl] IS NULL, 0, 1), 1) AS PointOfInterestHasImage, CAT.[Name] AS CustomAttributeName, 
				CAV.[Value] AS CustomAttributeValue, CAT.[Id] CustomerAttributeId, CAT.[IdValueType] AS CustomAttributeType, CAG.Id as IdCustomAttributeGroup,
				POI1.[Id] AS HierarchyLevel1Id, POI1.[Name] AS HierarchyLevel1Name,
				POI2.[Id] AS HierarchyLevel2Id, POI2.[Name] AS HierarchyLevel2Name, D.[Id] AS DepartmentId,
				D.[Name] AS DepartmentName, POI.[Emails] AS PointOfInterestEmails
	
	FROM		[dbo].[PointOfInterest] POI	WITH(NOLOCK)
				LEFT JOIN [dbo].[CustomAttributeValue] CAV WITH(NOLOCK) ON CAV.[IdPointOfInterest] = POI.[Id]
				LEFT JOIN [dbo].[CustomAttributeTranslated] CAT WITH(NOLOCK) ON CAV.[IdCustomAttribute] = CAT.[Id] AND CAT.[Deleted] = 0
				LEFT JOIN [dbo].[CustomAttributeGroupCustomAttribute] CAGA WITH(NOLOCK) ON CAT.Id = CAGA.IdCustomAttribute
				LEFT JOIN [dbo].[CustomAttributeGroup] CAG WITH(NOLOCK) ON CAGA.IdCustomAttributeGroup = CAG.Id AND CAG.[Deleted] = 0
				LEFT JOIN [dbo].[CustomAttributeGroupPersonType] CAGPT WITH(NOLOCK) ON CAG.Id = CAGPT.IdCustomAttributeGroup AND CAGPT.PersonOfInterestType = @PersonOfInterestType

				LEFT JOIN [dbo].[POIHierarchyLevel1] POI1 WITH(NOLOCK) ON POI1.[Id] = POI.[GrandfatherId]
				LEFT JOIN [dbo].[POIHierarchyLevel2] POI2 WITH(NOLOCK) ON POI2.[Id] = POI.[FatherId]
				LEFT JOIN [dbo].[Department] D WITH(NOLOCK) ON D.[Id] = POI.[IdDepartment]

	WHERE		POI.[Id] = @IdPointOfInterest
				--AND (CAV.Id IS NULL OR (CAV.Id IS NOT NULL AND CA.Id IS NOT NULL AND CAGPT.IdCustomAttributeGroup IS NOT NULL))
				) AS pointInfo 

	LEFT JOIN 

	(SELECT		TOP 1 ISNULL(AF.[IdPersonOfInterest] , 0) AS ExistsTask
	FROM		dbo.[AssignedForm] AF WITH(NOLOCK) 
				INNER JOIN dbo.[Form] F WITH(NOLOCK) ON F.[Id] = AF.[IdForm]
	WHERE		(F.[AllPointOfInterest] = 1 OR AF.[IdPointOfInterest] = @IdPointOfInterest) AND AF.[IdPersonOfInterest] = @IdPersonOfInterest AND
				AF.[Deleted] = 0 AND F.[Deleted] = 0
				AND Tzdb.IsLowerOrSameSystemDate(F.[StartDate], @Now) = 1
				AND Tzdb.IsGreaterOrSameSystemDate(F.[EndDate], @Now) = 1
	ORDER by AF.IdPointOfInterest desc)  AS taskInfo

	ON			pointInfo.PointOfInterestId = taskInfo.ExistsTask OR pointInfo.PointOfInterestId = @IdPointOfInterest

	LEFT JOIN

	(SELECT		TOP 1 ISNULL(AP.[IdPointOfInterest] , 0) AS ExistsAssets
	FROM		dbo.[AssetPointOfInterest] AP INNER JOIN dbo.[Asset] A ON A.[Id] = AP.[IdAsset]
	WHERE		AP.[Deleted] = 0 AND AP.[IdPointOfInterest] = @IdPointOfInterest AND A.[Deleted] = 0) AS assetInfo

	ON			pointInfo.PointOfInterestId = assetInfo.ExistsAssets

	LEFT JOIN

	(SELECT		TOP 1 ISNULL(AP.[IdPointOfInterest] , 0) AS ExistsAgreements, 
				COUNT(AP.[IdPointOfInterest]) AS NumberContracts
	FROM		dbo.[AgreementPointOfInterest] AP WITH(NOLOCK)
				INNER JOIN dbo.[Agreement] A WITH(NOLOCK) ON A.[Id] = AP.[IdAgreement]
	WHERE		AP.[IdPointOfInterest] = @IdPointOfInterest AND A.[Deleted] = 0
				AND Tzdb.IsLowerOrSameSystemDate(A.[StartDate], @Now) = 1
				AND Tzdb.IsGreaterOrSameSystemDate(A.[EndDate], @Now) = 1
	GROUP BY	AP.[IdPointOfInterest]) AS agreementInfo

	ON			pointInfo.PointOfInterestId = agreementInfo.ExistsAgreements

	LEFT JOIN 

	(SELECT		TOP 1 ISNULL(PP.[IdPointOfInterest] , 0) AS ExistsPromotions, 
				COUNT(PP.[IdPointOfInterest]) AS NumberPromotions
	FROM		dbo.[PromotionPointOfInterest] PP WITH(NOLOCK) 
				INNER JOIN dbo.[Promotion] P WITH(NOLOCK) ON P.[Id] = PP.[IdPromotion]
	WHERE		PP.[IdPointOfInterest] = @IdPointOfInterest AND P.[Deleted] = 0
				AND Tzdb.IsLowerOrSameSystemDate(P.[StartDate], @Now) = 1
				AND Tzdb.IsGreaterOrSameSystemDate(P.[EndDate], @Now) = 1
	GROUP BY	PP.[IdPointOfInterest]) AS promotionInfo

	ON			pointInfo.PointOfInterestId = promotionInfo.ExistsPromotions

	LEFT JOIN 

	(SELECT		TOP 1 ISNULL(PP.[IdPointOfInterest] , 0) AS ExistsPlanimetry, 
				COUNT(PP.[IdPointOfInterest]) AS NumberPlanimetries
	FROM		dbo.[PlanimetryPointOfInterest] PP INNER JOIN dbo.[Planimetry] P ON P.[Id] = PP.[IdPlanimetry]
	WHERE		PP.[IdPointOfInterest] = @IdPointOfInterest AND P.[Deleted] = 0
	GROUP BY	PP.[IdPointOfInterest]) AS planimetryInfo

	ON			pointInfo.PointOfInterestId = planimetryInfo.ExistsPlanimetry
	
	LEFT JOIN

	(SELECT		TOP 1 ISNULL(PC.[IdPointOfInterest] , 0) AS ExistsCampaigns
	FROM		dbo.[Campaign] C INNER JOIN dbo.[CampaignPointOfInterest] PC ON C.AllPointOfInterest = 1 OR C.[Id] = PC.[IdCampaign]
	WHERE		PC.[IdPointOfInterest] = @IdPointOfInterest AND C.[Deleted] = 0) AS campaignInfo
	ON			pointInfo.PointOfInterestId = campaignInfo.ExistsCampaigns

	ORDER BY	pointInfo.PointOfInterestId, pointInfo.CustomerAttributeId, pointInfo.IdCustomAttributeGroup

END
