/****** Object:  Procedure [dbo].[GetProductStarValuesByPointOfInterest]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetProductStarValuesByPointOfInterest]
	@PointOfInterestId [sys].[int] = NULL
AS
BEGIN
	
	SELECT	P.[Id] IdPointOfInterest, PR.[Id] AS IdProduct, PP.[TheoricalStock] AS TheoricalStock, 
			PP.[TheoricalPrice] AS TheoricalPrice, PRL.[IdProductReportAttribute], PRL.[Value] AS ProductReportAttributeValue,
			PRA.[IdType] AS IdProductReportAttributeType,  PRA.[Name] AS ProductReportAttributeName
	
	FROM	[dbo].[PointOfInterest] P 
			INNER JOIN [dbo].[ProductPointOfInterest] PP ON P.[Id] = PP.[IdPointOfInterest] 
			INNER JOIN [dbo].[Product] PR ON PR.[Id] = PP.[IdProduct]
			LEFT OUTER JOIN [dbo].[ProductReportLastStarAttributeValue] PRL 
				ON PRL.[IdPointOfInterest] = P.[Id] AND PRL.[IdProduct] = PR.[Id] AND EXISTS(SELECT 1 FROM [ProductReportAttribute] 
				WHERE [Id] = prl.[IdProductReportAttribute] AND [IsStar] = 1 AND [Deleted] = 0 and [FullDeleted] = 0)
			LEFT OUTER JOIN [dbo].[ProductReportAttribute] PRA ON PRA.[Id] = PRL.[IdProductReportAttribute]
	
	WHERE	PP.[IdPointOfInterest] = @PointOfInterestId AND PR.[Deleted] = 0
			

	UNION
     
	SELECT	@PointOfInterestId AS IdPointOfInterest, PR.[Id] AS IdProduct, NULL AS TheoricalStock, NULL AS TheoricalPrice,
			PRL.[IdProductReportAttribute], PRL.[Value] AS ProductReportAttributeValue,
			PRA.[IdType] AS IdProductReportAttributeType,  PRA.[Name] AS ProductReportAttributeName
	FROM	[Product] PR 
			LEFT OUTER JOIN [dbo].[ProductReportLastStarAttributeValue] PRL 
				ON PRL.[IdPointOfInterest] = @PointOfInterestId AND PRL.[IdProduct] = PR.[Id]
				AND EXISTS(SELECT 1 FROM [ProductReportAttribute] 
				WHERE [Id] = prl.[IdProductReportAttribute] AND [IsStar] = 1 AND [Deleted] = 0 and [FullDeleted] = 0)
			LEFT OUTER JOIN [dbo].[ProductReportAttribute] PRA ON PRA.[Id] = PRL.[IdProductReportAttribute]

	WHERE	NOT EXISTS (SELECT 1 
						FROM [dbo].[ProductPointOfInterest] PP 
						INNER JOIN [dbo].[Product] P ON P.[Id] = PP.[IdProduct]
						WHERE PP.[IdPointOfInterest] = @PointOfInterestId AND P.[Deleted] = 0)
			AND PR.[Deleted] = 0




	--SELECT PRL.[IdPointOfInterest], PRL.[IdProduct], PRL.[Value], 
	--	   PRL.[IdProductReportAttribute], PRA.[IdType] AS IdProductReportAttributeType, 
	--	   PRA.[Name] AS ProductReportAttributeName
	--FROM	[dbo].[ProductReportLastStarAttributeValue] PRL
	--		INNER JOIN [dbo].[ProductReportAttribute] PRA ON PRA.[Id] = PRL.[IdProductReportAttribute]
	--WHERE	@PointOfInterestIds IS NULL OR (dbo.[CheckValueInList](PRL.[IdPointOfInterest], @PointOfInterestIds) = 1)
	--		AND PRA.[IsStar] = 1 AND PRA.[Deleted] = 0 and PRA.[FullDeleted] = 0
	--ORDER BY [IdPointOfInterest], [IdProduct]

END
