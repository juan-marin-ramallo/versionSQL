/****** Object:  Procedure [dbo].[GetLastAssetReport]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetLastAssetReport]
	 @IdAsset int
	,@IdPersonOfInterest int
	,@IdPointOfInterest int
AS
BEGIN
	
	SELECT		 
				AR.[Id], AR.[IdAsset] as AssetId, AR.[IdPersonOfInterest] as PersonOfInterestId, 
				AR.[IdPointOfInterest] as PointOfInterestId, AR.[Date] AS ReportDateTime,
				A.[Identifier] AS AssetIdentifier, A.[Name] AS AssetName, A.[BarCode] AS AssetBarCode, 
				POI.[Name] as PointOfInterestName, POI.[Identifier] AS PointOfInterestIdentifier,
				T.[Id] AS AssetTypeId, T.[Name] AS AssetTypeName,
				PEOI.[Name] as PersonOfInterestName, PEOI.[LastName] AS PersonOfInterestLastName,
				ARAV.[IdAssetReportAttribute], ARAV.[Value] AS AssetReportAttributeValue, ARAV.[Id] AS IdAssetReportAttributeValue,
				ARAO.[Text] AS AssetReportAttributeOption,
				ARAV.[ImageEncoded] AS AssetReportAttributeImage,
				ARAV.[ImageUrl] AS AssetReportAttributeImageUrl,
				ARAV.[ImageName] AS AssetReportAttributeImageName,
				ARAT.[Id] AS IdAssetReportAttributeType, ARA.[Name] AS AssetReportAttributeName,
				A.[IdCategory], A.[IdSubCategory], AC1.[Name] AS CategoryName, AC2.[Name] AS SubCategoryName,
				AC1.[Identifier] AS CategoryIdentifier, AC2.[Identifier] AS SubCategoryIdentifier

	FROM		dbo.[AssetReportDynamic] AR WITH (NOLOCK)
				LEFT JOIN dbo.[Asset] A WITH (NOLOCK) ON A.[Id] = AR.[IdAsset]
				LEFT JOIN	DBO.[AssetCategory] AC1 ON AC1.[Id] = A.[IdCategory]
				LEFT JOIN	DBO.[AssetCategory] AC2 ON AC2.[Id] = A.[IdSubCategory]
				LEFT JOIN dbo.[AssetType] T WITH (NOLOCK) ON T.[Id] = A.[IdAssetType]
				LEFT JOIN dbo.[PointOfInterest] POI WITH (NOLOCK) ON POI.[Id] = AR.[IdPointOfInterest]
				LEFT JOIN dbo.[PersonOfInterest] PEOI WITH (NOLOCK) ON PEOI.[Id] = AR.[IdPersonOfInterest]
				LEFT JOIN dbo.[AssetReportAttributeValue] ARAV WITH (NOLOCK) ON ARAV.[IdAssetReport] = AR.[Id]
				LEFT JOIN dbo.[AssetReportAttribute] ARA WITH (NOLOCK) ON ARA.[Id] = ARAV.[IdAssetReportAttribute]
				LEFT JOIN dbo.[AssetReportAttributeOption] ARAO WITH (NOLOCK) ON ARAO.[Id] = ARAV.[IdAssetReportAttributeOption]
				LEFT JOIN dbo.[AssetReportAttributeTypeTranslated] ARAT WITH (NOLOCK) ON ARAT.[Id] = ARA.[IdType]
	
	WHERE		AR.[IdAsset] = @IdAsset
				AND AR.[IdPointOfInterest] = @IdPointOfInterest
				AND AR.[Id] = (SELECT TOP 1 AR1.[Id] 
								FROM [dbo].[AssetReportDynamic] AR1  WITH (NOLOCK)
								WHERE AR1.[IdAsset] = @IdAsset 
								  AND AR1.[IdPointOfInterest] = @IdPointOfInterest 
								ORDER BY AR1.[Date] DESC)

	ORDER BY	AR.[Id]

END
