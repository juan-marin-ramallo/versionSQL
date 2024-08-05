/****** Object:  TableFunction [dbo].[GetShareOfShelfSimilarReport]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		FS
-- Create date: 02/11/2021
-- Description:	SOSs with same point and category as the one with @IdShareOfShelf
-- =============================================
CREATE FUNCTION [dbo].[GetShareOfShelfSimilarReport]
(
	 @IdShareOfShelf [sys].[int]
	,@Limit [sys].[int]
)
RETURNS @t TABLE (
	[Id] [sys].[int], [Date] [sys].[DateTime], [PointOfInterestId] [sys].[int], PointOfInterestName [sys].[varchar](100),[PointOfInterestIdentifier] [sys].[varchar](50), 
	[HierarchyLevel1Id] [sys].[int], [HierarchyLevel2Id] [sys].[int], [HierarchyLevel1Name] [sys].[varchar](100), [HierarchyLevel2Name] [sys].[varchar](100), [HierarchyLevel1SapId] [sys].[VARCHAR](100), [HierarchyLevel2SapId] [sys].[VARCHAR](100),
	[BrandId] [sys].[int], [BrandName] [sys].[varchar](50), [BrandIdentifier] [sys].[varchar](50),
	[ItemId] [sys].[int], [Total] [sys].[DECIMAL](10,2), [ProductMinSalesQuantity] [sys].[int], [ProductMinUnitsPackage] [sys].[int],
	[ProductMaxSalesQuantity] [sys].[int], [ProductInStock] [sys].[BIT] 
	--,ProductColumn_1 varchar(100), ProductColumn_2 varchar(100),  ProductColumn_3 varchar(100), ProductColumn_4 varchar(100), ProductColumn_5 varchar(100), 
	-- ProductColumn_6 varchar(100), ProductColumn_7 varchar(100), ProductColumn_8 varchar(100), ProductColumn_9 varchar(100), ProductColumn_10 varchar(100), 
	-- ProductColumn_11 varchar(100), ProductColumn_12 varchar(100), ProductColumn_13 varchar(100), ProductColumn_14 varchar(100), ProductColumn_15 varchar(100), 
	-- ProductColumn_16 varchar(100), ProductColumn_17 varchar(100), ProductColumn_18 varchar(100), ProductColumn_19 varchar(100), ProductColumn_20 varchar(100),	
	-- ProductColumn_21 varchar(100), ProductColumn_22 varchar(100), ProductColumn_23 varchar(100), ProductColumn_24 varchar(100), ProductColumn_25 varchar(100)
	)
AS
BEGIN

	DECLARE @LimitedResultsIds [dbo].[IdTableType]
	DECLARE @IdProductCategorySOS [dbo].[IdTableType]
	DECLARE @IdPointOfInterest [sys].[int]
	
	SET @IdPointOfInterest = (SELECT IdPointOfInterest from dbo.[ShareOfShelfReport] WHERE Id = @IdShareOfShelf)
	INSERT INTO @IdProductCategorySOS(Id)
	SELECT IdProductCategory FROM dbo.ShareOfShelfProductCategory WHERE IdShareOfShelf = @IdShareOfShelf

	INSERT INTO @LimitedResultsIds(Id)	
	SELECT TOP (@Limit) SOS.Id 
	FROM [dbo].[ShareOfShelfReport] SOS WITH (NOLOCK)
			INNER JOIN  [dbo].[ShareOfShelfProductCategory] SOSPC WITH(NOLOCK) ON SOS.Id = SOSPC.IdShareOfShelf
			INNER JOIN  @IdProductCategorySOS IDPC ON SOSPC.IdProductCategory = IDPC.Id
	WHERE SOS.IdPointOfInterest = @IdPointOfInterest AND SOS.Id <> @IdShareOfShelf
	GROUP BY SOS.Id, SOS.[Date]
	ORDER BY SOS.[Date] DESC 

	
	INSERT INTO @t 
	SELECT		 SOS.Id, SOS.[Date], POI.[Id] AS PointOfInterestId, POI.[Name] AS PointOfInterestName, POI.[Identifier] AS PointOfInterestIdentifier
				,POI.[GrandfatherId] AS HierarchyLevel1Id, POI.[FatherId] AS HierarchyLevel2Id, PHL1.[Name] AS HierarchyLevel1Name, PHL2.[Name] AS HierarchyLevel2Name, PHL1.SapId AS [HierarchyLevel1SapId], PHL2.SapId AS [HierarchyLevel2SapId]
				,B.[Id] AS BrandId, B.[Name] AS BrandName, B.[Identifier] AS BrandIdentifier
				,SI.[Id] AS ItemId, SI.[Total], P.[MinSalesQuantity] AS ProductMinSalesQuantity, P.[MinUnitsPackage] AS ProductMinUnitsPackage
				,P.[MaxSalesQuantity] AS ProductMaxSalesQuantity, P.[InStock] AS ProductInStock
				--,P.[Column_1] AS ProductColumn_1, P.[Column_2] AS ProductColumn_2,P.[Column_3] AS ProductColumn_3,P.[Column_4] AS ProductColumn_4,
				-- P.[Column_5]  AS ProductColumn_5,P.[Column_6] AS ProductColumn_6,P.[Column_7] AS ProductColumn_7,P.[Column_8] AS ProductColumn_8,
				-- P.[Column_9] AS ProductColumn_9, P.[Column_10] AS ProductColumn_10, P.[Column_11] AS ProductColumn_11,P.[Column_12] AS ProductColumn_12,
				-- P.[Column_13] AS ProductColumn_13, P.[Column_14] AS ProductColumn_14,P.[Column_15] AS ProductColumn_15,P.[Column_16] AS ProductColumn_17,
				-- P.[Column_17] AS ProductColumn_17,P.[Column_18] AS ProductColumn_18, P.[Column_19] AS ProductColumn_19,P.[Column_20] AS ProductColumn_20,
				-- P.[Column_21] AS ProductColumn_21,P.[Column_22] AS ProductColumn_22,P.[Column_23] AS ProductColumn_23,P.[Column_24] AS ProductColumn_24,
				-- P.[Column_25]  AS ProductColumn_25
	
	FROM		[dbo].[PointOfInterest] POI WITH (NOLOCK)
				LEFT OUTER JOIN [dbo].[POIHierarchyLevel1] PHL1 WITH (NOLOCK) ON POI.[GrandfatherId] = PHL1.[Id]	
				LEFT OUTER JOIN [dbo].[POIHierarchyLevel2] PHL2 WITH (NOLOCK) ON POI.[FatherId] = PHL2.[Id]
				LEFT OUTER JOIN @LimitedResultsIds IDS ON 1 = 1
				LEFT OUTER JOIN [dbo].[ShareOfShelfReport] SOS WITH (NOLOCK) ON IDS.[Id] = SOS.[Id]
				LEFT OUTER JOIN	[dbo].[ShareOfShelfItem] SI WITH (NOLOCK) ON SOS.[Id] = SI.IdShareOfShelf
				LEFT OUTER JOIN	[dbo].[Product] P WITH (NOLOCK) ON P.[Id] = SI.IdProduct
				LEFT OUTER JOIN	[dbo].[ProductBrand] B WITH (NOLOCK) ON B.[Id] = SI.IdProductBrand OR B.[Id] = P.IdProductBrand

	WHERE		POI.Id = @IdPointOfInterest 
				AND (SOS.Id IS NULL OR (SOS.Id = @IdShareOfShelf OR (SOS.ISManual = 1 OR SOS.IsValid = 1)))
	
	GROUP BY	 SOS.Id, SOS.[Date], POI.[Id], POI.[Name], POI.[Identifier]
				,POI.[GrandfatherId], POI.[FatherId] , PHL1.[Name] , PHL2.[Name], PHL1.SapId, PHL2.SapId  
				,B.[Id], B.[Name], B.[Identifier]
				,SI.[Id],SI.[Total], P.[MinSalesQuantity], P.[MinUnitsPackage] , P.[MaxSalesQuantity], P.[InStock]
				--,P.[Column_1] , P.[Column_2] ,P.[Column_3],P.[Column_4] ,
				-- P.[Column_5] ,P.[Column_6] ,P.[Column_7],P.[Column_8] ,
				-- P.[Column_9] , P.[Column_10] , P.[Column_11],P.[Column_12] ,
				-- P.[Column_13] , P.[Column_14] ,P.[Column_15],P.[Column_16] ,
				-- P.[Column_17],P.[Column_18] , P.[Column_19],P.[Column_20] ,
				-- P.[Column_21] ,P.[Column_22] ,P.[Column_23] ,P.[Column_24],
				-- P.[Column_25]  
	RETURN 

END
