/****** Object:  Procedure [dbo].[GetProductDynamicFiltered]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetProductDynamicFiltered]
	@ProductsId VARCHAR(MAX) = NULL
	,@PoisId VARCHAR(MAX) = NULL
	,@ProductBarCodes VARCHAR(MAX) = NULL
	,@ProductIdentifiers VARCHAR(MAX) = NULL
	,@PoiIdentifiers VARCHAR(MAX) = NULL
AS
BEGIN
SET NOCOUNT ON;

	SELECT	PD.[Id] AS ProductDynamicId, PD.[Dynamic] AS [Dynamic], 
			P.[Id] AS ProductId, P.[Name] AS ProductName, P.[Identifier] AS ProductIdentifier, P.[BarCode] AS ProductBarCode, 
			POI.[Id] AS PointOfInterestId, POI.[Name] AS PointOfInterestName, POI.[Identifier] AS PointOfInterestIdentifier, POI.[Address] AS PointOfInterestAddress,
			PRS.[Id] AS ProductReportSectionId, PRS.[Name] AS ProductReportSectionName, PRS.[Description] AS ProductReportSectionDescription,
			F.[Id] AS FormId, F.[Name] AS FormName, F.[Description] AS FormDescription, F.[StartDate] AS FormStartDate, F.[EndDate] AS FormEndDate
	INTO #ProductDynamic
	FROM [dbo].[ProductDynamic] PD WITH (NOLOCK)
	INNER JOIN [dbo].[Product] P WITH (NOLOCK) ON P.[Id] = PD.[IdProduct] AND P.[Deleted] = 0
	INNER JOIN [dbo].[PointOfInterest] POI WITH (NOLOCK) ON POI.[Id] = PD.[IdPointOfInterest] AND POI.[Deleted] = 0
	LEFT JOIN [dbo].[ProductReportSection] PRS WITH (NOLOCK) ON PRS.[Id] = PD.[IdProductReportSection] AND PRS.[Deleted] = 0
	LEFT JOIN [dbo].[Form] F WITH (NOLOCK) ON F.[Id] = PD.[IdForm] AND F.[Deleted] = 0
	WHERE PD.[Deleted] = 0
	AND ((@ProductsId IS NULL) OR dbo.CheckValueInList(P.[Id], @ProductsId) = 1)
	AND ((@ProductBarCodes IS NULL) OR (dbo.CheckVarcharInList(P.[BarCode], @ProductBarCodes) = 1))
	AND ((@ProductIdentifiers IS NULL) OR (dbo.CheckVarcharInList(P.[Identifier], @ProductIdentifiers) = 1))
	AND ((@PoisId IS NULL) OR dbo.CheckValueInList(POI.[Id], @PoisId) = 1)
	AND ((@PoiIdentifiers IS NULL) OR (dbo.CheckVarcharInList(POI.[Identifier], @PoiIdentifiers) = 1))
	ORDER BY P.[BarCode], POI.[Identifier], PD.[Dynamic]	

	SELECT	*
	FROM	#ProductDynamic
	WHERE	ProductReportSectionId IS NOT NULL OR FormId IS NOT NULL
	
	DROP TABLE #ProductDynamic
END
