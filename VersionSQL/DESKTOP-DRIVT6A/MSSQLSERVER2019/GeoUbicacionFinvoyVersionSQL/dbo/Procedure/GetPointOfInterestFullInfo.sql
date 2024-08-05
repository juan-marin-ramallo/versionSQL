/****** Object:  Procedure [dbo].[GetPointOfInterestFullInfo]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 29/07/2016
-- Description:	SP para obtener la información de los puntos de interés para ver en los dispositivos en cuanto a formularios, promociones, productos, activos, contratos y planimetrias.
-- =============================================
CREATE PROCEDURE [dbo].[GetPointOfInterestFullInfo]
	@IdPointOfInterest [sys].[int],
	@IdPersonOfInterest [sys].[int]
AS
BEGIN
	DECLARE @Now [sys].[datetime]
	SET @Now = GETUTCDATE()

	SELECT	ISNULL(P.[Id], @IdPointOfInterest) AS PointOfInterestId, F.[Id] AS FormId, NULL AS ProductId, NULL AS AssetId,
			NULL AS PromotionId, NULL AS AgreementId, NULL AS PlanimetryId, NULL AS TheoricalStock, NULL AS TheoricalPrice,
			NULL AS IdProductReportAttribute, NULL AS ProductReportAttributeValue,
			NULL AS CampaignId, NULL AS [IdPersonOfInterestPermission]
	FROM	[dbo].[Form] F WITH (NOLOCK)
			INNER JOIN [dbo].[AssignedForm] AF WITH (NOLOCK) ON AF.[IdForm] = F.[Id] 
			LEFT JOIN [dbo].[PointOfInterest] P WITH (NOLOCK) ON P.[Id] = AF.[IdPointOfInterest] OR (AF.[IdPointOfInterest] IS NULL AND P.[Id] = @IdPointOfInterest)

	WHERE	(F.[AllPointOfInterest] = 1 OR AF.[IdPointOfInterest] = @IdPointOfInterest) 
			AND AF.[IdPersonOfInterest] = @IdPersonOfInterest AND AF.[Deleted] = 0 AND F.[Deleted] = 0
			AND Tzdb.IsLowerOrSameSystemDate(F.[StartDate], @Now) = 1 AND Tzdb.IsGreaterOrSameSystemDate(F.[EndDate], @Now) = 1 --FORMULARIO ACTIVO 

	UNION
     
	SELECT	P.[Id] PointOfInterestId, NULL AS FormId, PR.[Id] AS ProductId, NULL AS AssetId, NULL AS PromotionId, 
			NULL AS AgreementId, NULL AS PlanimetryId, PP.[TheoricalStock] AS TheoricalStock, PP.[TheoricalPrice] AS TheoricalPrice,
			PRL.[IdProductReportAttribute], PRL.[Value] AS ProductReportAttributeValue,
			NULL AS CampaignId, CSP.[IdPersonOfInterestPermission]
	FROM	[dbo].[PointOfInterest] P  WITH (NOLOCK)
			INNER JOIN [dbo].[ProductPointOfInterest] PP  WITH (NOLOCK) ON P.[Id] = PP.[IdPointOfInterest] 
			INNER JOIN [dbo].[Product] PR  WITH (NOLOCK) ON PR.[Id] = PP.[IdProduct]
			LEFT OUTER JOIN [dbo].[ProductReportLastStarAttributeValue] PRL  WITH (NOLOCK)
			ON PRL.[IdPointOfInterest] = P.[Id] AND PRL.[IdProduct] = PR.[Id] AND EXISTS(SELECT 1 FROM [ProductReportAttribute] 
			WHERE [Id] = prl.[IdProductReportAttribute] AND [IsStar] = 1 AND [Deleted] = 0 and [FullDeleted] = 0)
			LEFT OUTER JOIN [dbo].[CatalogPersonOfInterestPermission] CSP WITH(NOLOCK)  ON PP.[IdCatalog] =  CSP.[IdCatalog]
	WHERE	PP.[IdPointOfInterest] = @IdPointOfInterest AND PR.[Deleted] = 0

	UNION
     
	SELECT	@IdPointOfInterest AS PointOfInterestId, NULL AS FormId, PR.[Id] AS ProductId, NULL AS AssetId, 
			NULL AS PromotionId, NULL AS AgreementId, NULL AS PlanimetryId, NULL AS TheoricalStock, NULL AS TheoricalPrice,
			PRL.[IdProductReportAttribute], PRL.[Value] AS ProductReportAttributeValue,
			NULL AS CampaignId,  NULL AS [IdPersonOfInterestPermission]
	FROM	[Product] PR  WITH (NOLOCK)
			LEFT OUTER JOIN [dbo].[ProductReportLastStarAttributeValue] PRL WITH (NOLOCK)
			ON PRL.[IdPointOfInterest] = @IdPointOfInterest AND PRL.[IdProduct] = PR.[Id]
						AND EXISTS(SELECT 1 FROM [ProductReportAttribute] 
			WHERE [Id] = prl.[IdProductReportAttribute] AND [IsStar] = 1 AND [Deleted] = 0 and [FullDeleted] = 0)
	WHERE	NOT EXISTS (SELECT 1 
						FROM [dbo].[ProductPointOfInterest] PP  WITH (NOLOCK)
						INNER JOIN [dbo].[Product] P  WITH (NOLOCK) ON P.[Id] = PP.[IdProduct]
						WHERE PP.[IdPointOfInterest] = @IdPointOfInterest AND P.[Deleted] = 0)
			AND PR.[Deleted] = 0 

	UNION
    
	SELECT	P.[Id] PointOfInterestId, NULL AS FormId, NULL AS ProductId, A.[Id] AS AssetId, NULL AS PromotionId, 
			NULL AS AgreementId, NULL AS PlanimetryId, NULL AS TheoricalStock, NULL AS TheoricalPrice,
			NULL AS IdProductReportAttribute, NULL AS ProductReportAttributeValue,
			NULL AS CampaignId,  NULL AS [IdPersonOfInterestPermission]
	FROM	[dbo].[PointOfInterest] P  WITH (NOLOCK)
			INNER JOIN [dbo].[AssetPointOfInterest] AP  WITH (NOLOCK) ON P.[Id] = AP.[IdPointOfInterest] AND AP.[Deleted] = 0
			INNER JOIN [dbo].[Asset] A  WITH (NOLOCK) ON A.[Id] = AP.[IdAsset] 

	WHERE	AP.[IdPointOfInterest] = @IdPointOfInterest AND A.[Deleted] = 0

	UNION
    
	SELECT	P.[Id] PointOfInterestId, NULL AS FormId, NULL AS ProductId, NULL AS AssetId, PROM.[Id] AS PromotionId,
			NULL AS AgreementId, NULL AS PlanimetryId, NULL AS TheoricalStock, NULL AS TheoricalPrice,
			NULL AS IdProductReportAttribute, NULL AS ProductReportAttributeValue,
			NULL AS CampaignId,  NULL AS [IdPersonOfInterestPermission]
	FROM	[dbo].[PointOfInterest] P  WITH (NOLOCK)
			INNER JOIN [dbo].[PromotionPointOfInterest] PP  WITH (NOLOCK) ON P.[Id] = PP.[IdPointOfInterest] 
			INNER JOIN [dbo].[Promotion] PROM  WITH (NOLOCK) ON PROM.[Id] = PP.[IdPromotion] 

	WHERE	PP.[IdPointOfInterest] = @IdPointOfInterest AND PROM.[Deleted] = 0
	
	UNION
    
	SELECT	P.[Id] PointOfInterestId, NULL AS FormId, NULL AS ProductId, NULL AS AssetId, NULL AS PromotionId, 
			A.[Id] AS AgreementId, NULL AS PlanimetryId, NULL AS TheoricalStock, NULL AS TheoricalPrice,
			NULL AS IdProductReportAttribute, NULL AS ProductReportAttributeValue,
			NULL AS CampaignId,  NULL AS [IdPersonOfInterestPermission]
	FROM	[dbo].[PointOfInterest] P  WITH (NOLOCK)
			INNER JOIN [dbo].[AgreementPointOfInterest] AP  WITH (NOLOCK) ON P.[Id] = AP.[IdPointOfInterest]
			INNER JOIN [dbo].[Agreement] A  WITH (NOLOCK) ON A.[Id] = AP.[IdAgreement] 

	WHERE	AP.[IdPointOfInterest] = @IdPointOfInterest AND A.[Deleted] = 0

	UNION
    
	SELECT	P.[Id] PointOfInterestId, NULL AS FormId, NULL AS ProductId, NULL AS AssetId, NULL AS PromotionId,  
			NULL AS AgreementId, PL.[Id] AS PlanimetryId, NULL AS TheoricalStock, NULL AS TheoricalPrice,
			NULL AS IdProductReportAttribute, NULL AS ProductReportAttributeValue,
			NULL AS CampaignId,  NULL AS [IdPersonOfInterestPermission]
	FROM	[dbo].[PointOfInterest] P  WITH (NOLOCK)
			INNER JOIN [dbo].[PlanimetryPointOfInterest] PP  WITH (NOLOCK) ON P.[Id] = PP.[IdPointOfInterest]
			INNER JOIN [dbo].[Planimetry] PL  WITH (NOLOCK) ON PL.[Id] = PP.[IdPlanimetry] 

	WHERE	PP.[IdPointOfInterest] = @IdPointOfInterest AND PL.[Deleted] = 0

	UNION
    
	SELECT	P.[Id] PointOfInterestId, NULL AS FormId, NULL AS ProductId, NULL AS AssetId, NULL AS PromotionId,  
			NULL AS AgreementId, NULL AS PlanimetryId, NULL AS TheoricalStock, NULL AS TheoricalPrice,
			NULL AS IdProductReportAttribute, NULL AS ProductReportAttributeValue,
			C.[Id] AS CampaignId,  NULL AS [IdPersonOfInterestPermission]
	FROM	[dbo].[PointOfInterest] P  WITH (NOLOCK)
			INNER JOIN [dbo].[CampaignPointOfInterest] CP  WITH (NOLOCK) ON P.[Id] = CP.[IdPointOfInterest]
			INNER JOIN [dbo].[Campaign] C  WITH (NOLOCK) ON C.[Id] = CP.[IdCampaign] 

	WHERE	CP.[IdPointOfInterest] = @IdPointOfInterest AND C.[Deleted] = 0


END
