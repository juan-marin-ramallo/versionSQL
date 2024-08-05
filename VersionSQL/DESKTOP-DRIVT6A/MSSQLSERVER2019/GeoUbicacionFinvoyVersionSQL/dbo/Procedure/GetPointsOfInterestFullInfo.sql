/****** Object:  Procedure [dbo].[GetPointsOfInterestFullInfo]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 29/07/2016
-- Description:	SP para obtener la información de los puntos de interés para ver en los dispositivos en cuanto a formularios, promociones, productos, activos, contratos y planimetrias.
-- =============================================
CREATE PROCEDURE [dbo].[GetPointsOfInterestFullInfo]
	@IdsPointsOfInterest [dbo].[IdTableType] readonly,
	@IdPersonOfInterest [sys].[int]
AS
BEGIN
	DECLARE @Now [sys].[datetime]
	SET @Now = GETUTCDATE()

	SELECT	P.[Id] AS PointOfInterestId, F.[Id] AS FormId, NULL AS ProductId, NULL AS AssetId,
			NULL AS PromotionId, NULL AS AgreementId, NULL AS PlanimetryId,
			
			NULL AS CampaignId, NULL AS [IdPersonOfInterestPermission]
	FROM	[dbo].[Form] F WITH (NOLOCK)
			INNER JOIN [dbo].[AssignedForm] AF WITH (NOLOCK) ON AF.[IdForm] = F.[Id]
			INNER JOIN @IdsPointsOfInterest PID ON PID.[Id] = AF.[IdPointOfInterest] OR AF.[IdPointOfInterest] IS NULL
			INNER JOIN [dbo].[PointOfInterest] P WITH (NOLOCK) ON P.[Id]  = PID.Id

	WHERE	(F.[AllPointOfInterest] = 1 OR AF.[IdPointOfInterest] IS NOT NULL)
			AND AF.[IdPersonOfInterest] = @IdPersonOfInterest AND AF.[Deleted] = 0 AND F.[Deleted] = 0
			AND Tzdb.IsLowerOrSameSystemDate(F.[StartDate], @Now) = 1 AND Tzdb.IsGreaterOrSameSystemDate(F.[EndDate], @Now) = 1 --FORMULARIO ACTIVO
	GROUP BY P.[Id], F.[Id]

	UNION
    
	SELECT	P.[Id] PointOfInterestId, NULL AS FormId, NULL AS ProductId, A.[Id] AS AssetId, NULL AS PromotionId,
			NULL AS AgreementId, NULL AS PlanimetryId,
			
			NULL AS CampaignId,  NULL AS [IdPersonOfInterestPermission]
	FROM	@IdsPointsOfInterest PID
			INNER JOIN [dbo].[PointOfInterest] P  WITH (NOLOCK) ON PID.Id = P.Id
			INNER JOIN [dbo].[AssetPointOfInterest] AP  WITH (NOLOCK) ON P.[Id] = AP.[IdPointOfInterest] AND AP.[Deleted] = 0
			INNER JOIN [dbo].[Asset] A  WITH (NOLOCK) ON A.[Id] = AP.[IdAsset]
	WHERE	A.[Deleted] = 0
	GROUP BY P.Id, A.Id

	UNION
    
	SELECT	P.[Id] PointOfInterestId, NULL AS FormId, NULL AS ProductId, NULL AS AssetId, PROM.[Id] AS PromotionId,
			NULL AS AgreementId, NULL AS PlanimetryId,
			
			NULL AS CampaignId,  NULL AS [IdPersonOfInterestPermission]
	FROM	@IdsPointsOfInterest PID
			INNER JOIN [dbo].[PointOfInterest] P  WITH (NOLOCK) ON PID.Id = P.Id
			INNER JOIN [dbo].[PromotionPointOfInterest] PP  WITH (NOLOCK) ON P.[Id] = PP.[IdPointOfInterest]
			INNER JOIN [dbo].[Promotion] PROM  WITH (NOLOCK) ON PROM.[Id] = PP.[IdPromotion]

	WHERE	PROM.[Deleted] = 0
	GROUP BY P.Id, PROM.Id
	
	UNION
    
	SELECT	P.[Id] PointOfInterestId, NULL AS FormId, NULL AS ProductId, NULL AS AssetId, NULL AS PromotionId,
			A.[Id] AS AgreementId, NULL AS PlanimetryId,
			
			NULL AS CampaignId,  NULL AS [IdPersonOfInterestPermission]
	FROM	@IdsPointsOfInterest PID
			INNER JOIN [dbo].[PointOfInterest] P  WITH (NOLOCK) ON PID.Id = P.Id
			INNER JOIN [dbo].[AgreementPointOfInterest] AP  WITH (NOLOCK) ON P.[Id] = AP.[IdPointOfInterest]
			INNER JOIN [dbo].[Agreement] A  WITH (NOLOCK) ON A.[Id] = AP.[IdAgreement]

	WHERE	A.[Deleted] = 0
	GROUP BY P.Id, A.Id

	UNION
    
	SELECT	P.[Id] PointOfInterestId, NULL AS FormId, NULL AS ProductId, NULL AS AssetId, NULL AS PromotionId,
			NULL AS AgreementId, PL.[Id] AS PlanimetryId,
			
			NULL AS CampaignId,  NULL AS [IdPersonOfInterestPermission]
	FROM	@IdsPointsOfInterest PID
			INNER JOIN [dbo].[PointOfInterest] P  WITH (NOLOCK) ON PID.Id = P.Id
			INNER JOIN [dbo].[PlanimetryPointOfInterest] PP  WITH (NOLOCK) ON P.[Id] = PP.[IdPointOfInterest]
			INNER JOIN [dbo].[Planimetry] PL  WITH (NOLOCK) ON PL.[Id] = PP.[IdPlanimetry]

	WHERE	PL.[Deleted] = 0
	GROUP BY P.Id, PL.Id

	UNION
    
	SELECT	P.[Id] PointOfInterestId, NULL AS FormId, NULL AS ProductId, NULL AS AssetId, NULL AS PromotionId,
			NULL AS AgreementId, NULL AS PlanimetryId,
			
			C.[Id] AS CampaignId,  NULL AS [IdPersonOfInterestPermission]
	FROM	@IdsPointsOfInterest PID
			INNER JOIN [dbo].[PointOfInterest] P  WITH (NOLOCK) ON PID.Id = P.Id
			INNER JOIN [dbo].[CampaignPointOfInterest] CP  WITH (NOLOCK) ON P.[Id] = CP.[IdPointOfInterest]
			INNER JOIN [dbo].[Campaign] C  WITH (NOLOCK) ON C.[Id] = CP.[IdCampaign]

	WHERE	C.[Deleted] = 0
	GROUP BY P.Id, C.Id


END
