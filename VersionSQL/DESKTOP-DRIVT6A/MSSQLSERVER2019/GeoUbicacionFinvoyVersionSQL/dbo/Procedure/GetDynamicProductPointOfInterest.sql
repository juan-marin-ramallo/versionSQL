/****** Object:  Procedure [dbo].[GetDynamicProductPointOfInterest]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================================================
-- Author:		Juan Marin
-- Create date: 10/11/2023
-- Description:	SP para obtener toda la informacion de las asociaciones de producto y punto de interes con una dinamica
-- Modified date: 21/11/2023
-- Description: Add parameter to include product and point of interest deleted
-- =============================================================================
CREATE PROCEDURE [dbo].[GetDynamicProductPointOfInterest]
(
	 @IdDynamic [int],
	 @IncludeProductAndPointOfInterestDeleted [bit] = 0
)
AS
BEGIN
SET NOCOUNT ON

	SELECT	DPOI.Id AS DynamicProductPointOfInterestId,
			P.Id AS ProductId, P.[Name] AS ProductName, P.BarCode AS ProductBarCode, P.Deleted AS ProductDeleted,
			POI.Id AS PointOfInterestId,  POI.[Name] AS PointOfInterestName, POI.Identifier PointOfInterestIdentifier, POI.Deleted AS PointOfInterestDeleted,
			D.[Id] AS DynamicId, D.[Name] AS [Dynamic]
		FROM [dbo].[DynamicProductPointOfInterest] DPOI WITH (NOLOCK)
		INNER JOIN	[dbo].[Product] P WITH (NOLOCK) ON P.Id = DPOI.IdProduct AND (@IncludeProductAndPointOfInterestDeleted = 1 OR P.Deleted = 0)
		INNER JOIN	[dbo].[PointOfInterest] POI WITH (NOLOCK) ON POI.Id = DPOI.IdPointOfInterest AND (@IncludeProductAndPointOfInterestDeleted = 1 OR POI.Deleted = 0)
		INNER JOIN	[dbo].[Dynamic] D WITH (NOLOCK) ON D.Id = DPOI.IdDynamic AND D.Deleted = 0
		WHERE DPOI.IdDynamic = @IdDynamic
		ORDER BY P.BarCode, POI.Identifier
END
