/****** Object:  Procedure [dbo].[GetAssetsPointOfInterest]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 28/12/2015
-- Description:	SP para obtener los activos asignados a un punto de interes
-- =============================================
CREATE PROCEDURE [dbo].[GetAssetsPointOfInterest]
	 @IdPointOfInterest [sys].[int]
	,@AssetIds [sys].[varchar](max) = NULL
	,@AssetTypeIds [sys].[varchar](max) = NULL
	,@IdUser [sys].[int] = NULL
AS
BEGIN
	DECLARE @HidePending [sys].[BIT] = (SELECT TOP 1 IIF([Value] = '1',0, 1) FROM dbo.[ConfigurationTranslated] WHERE [Id] = 4058)

	SELECT		P.[Id] AS PointOfInterestId, P.[Name] AS PointOfInterestName, P.[Identifier] AS PointOfInterestIdentifier, 
				P.[Address] AS PointOfInterestAddress,
				AP.[Id], A.[Id] AS AssetId, A.[Identifier] AS AssetIdentifier, A.[Name] AS AssetName, A.[BarCode] AS AssetBarCode,
				T.[Id] AS AssetTypeId, T.[Name] AS AssetTypeName,
				P.[Latitude] AS PointOfInterestLatitude, P.[Longitude] AS PointOfInterestLongitude

	FROM		[dbo].[PointOfInterest] P 
				INNER JOIN [dbo].[AssetPointOfInterest] AP ON P.[Id] = AP.[IdPointOfInterest] AND AP.[Deleted] = 0
				INNER JOIN [dbo].[Asset] A ON A.[Id] = AP.[IdAsset]
				LEFT JOIN [dbo].[AssetType] T ON T.[Id] = A.[IdAssetType]
	WHERE		AP.[IdPointOfInterest] = @IdPointOfInterest AND A.[Deleted] = 0 AND
				((@AssetIds IS NULL) OR dbo.CheckValueInList (A.[Id], @AssetIds) = 1) AND
				((@AssetTypeIds IS NULL) OR dbo.CheckValueInList (A.[IdAssetType], @AssetTypeIds) = 1) AND
				(A.[Pending] = 0 OR @HidePending = 0)

	GROUP BY	P.[Id], P.[Name], P.[Identifier] , P.[Address],
				AP.[Id], A.[Id], A.[Name], A.[Identifier], A.[BarCode], 
				P.[Latitude], P.[Longitude], T.[Name], T.[Id]
				
	ORDER BY A.[Name] DESC
END
