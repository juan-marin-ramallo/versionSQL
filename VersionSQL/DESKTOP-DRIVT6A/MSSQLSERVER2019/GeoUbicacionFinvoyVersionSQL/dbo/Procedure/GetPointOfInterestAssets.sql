/****** Object:  Procedure [dbo].[GetPointOfInterestAssets]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetPointOfInterestAssets] 
	
	@AssetIds [sys].[VARCHAR](MAX) = NULL ,
	@PointOfInterestId [sys].[INT] = NULL ,
    @ReturnImages [sys].[bit]
AS
BEGIN
	
	IF @PointOfInterestId IS NOT NULL
	BEGIN 
		SELECT	A.[Id], A.[Name], A.[BarCode], A.[Identifier], (CASE @ReturnImages WHEN 1 THEN A.[ImageArray] ELSE NULL END) AS ImageArray,
				--A.[IdCategory], A.[IdSubCategory],
				C.[Id] AS IdCompany, C.[Name] AS CompanyName,
				--AC1.[Name] AS CategoryName, AC2.[Name] AS SubCategoryName
				(CASE WHEN AC1.Deleted = 0 THEN AC1.[Id] ELSE NULL END) AS IdCategory,
				(CASE WHEN AC1.Deleted = 0 THEN AC1.[Name] ELSE NULL END) AS CategoryName,
				(CASE WHEN AC1.[Name] IS NULL OR AC1.Deleted = 1 OR AC2.Deleted = 1 THEN NULL ELSE AC2.[Id] END) AS IdSubCategory,
				(CASE WHEN AC1.[Name] IS NULL OR AC1.Deleted = 1 OR AC2.Deleted = 1 THEN NULL ELSE AC2.[Name] END) AS SubCategoryName
		
		FROM	dbo.[AssetPointOfInterest] APOI WITH (NOLOCK)
				LEFT JOIN	dbo.[Asset] A WITH (NOLOCK) ON APOI.[IdAsset] = A.[Id]
				LEFT JOIN	dbo.[Company] C WITH (NOLOCK) ON C.[Id] = A.[IdCompany]
				LEFT JOIN	DBO.[AssetCategory] AC1 WITH (NOLOCK) ON AC1.[Id] = A.[IdCategory]
				LEFT JOIN	DBO.[AssetCategory] AC2 WITH (NOLOCK) ON AC2.[Id] = A.[IdSubCategory]
		
		WHERE	APOI.[Deleted] = 0 AND APOI.[IdPointOfInterest] = @PointOfInterestId 
			AND A.[Deleted] = 0 
			AND A.[Pending] = 0 
			AND ((@AssetIds IS NULL) OR (dbo.[CheckValueInList](APOI.[IdAsset], @AssetIds) = 1))
	END
    ELSE
    BEGIN
		SELECT	A.[Id], A.[Name], A.[BarCode], A.[Identifier], (CASE @ReturnImages WHEN 1 THEN A.[ImageArray] ELSE NULL END) AS ImageArray,
				--A.[IdCategory], A.[IdSubCategory],
				C.[Id] AS IdCompany, C.[Name] AS CompanyName,
				--AC1.[Name] AS CategoryName, AC2.[Name] AS SubCategoryName
				(CASE WHEN AC1.Deleted = 0 THEN AC1.[Id] ELSE NULL END) AS IdCategory,
				(CASE WHEN AC1.Deleted = 0 THEN AC1.[Name] ELSE NULL END) AS CategoryName,
				(CASE WHEN AC1.[Name] IS NULL OR AC1.Deleted = 1 OR AC2.Deleted = 1 THEN NULL ELSE AC2.[Id] END) AS IdSubCategory,
				(CASE WHEN AC1.[Name] IS NULL OR AC1.Deleted = 1 OR AC2.Deleted = 1 THEN NULL ELSE AC2.[Name] END) AS SubCategoryName
		
		FROM	dbo.[Asset] A WITH (NOLOCK)
				LEFT JOIN	dbo.[Company] C WITH (NOLOCK) ON C.[Id] = A.[IdCompany]
				LEFT JOIN	DBO.[AssetCategory] AC1 WITH (NOLOCK) ON AC1.[Id] = A.[IdCategory]
				LEFT JOIN	DBO.[AssetCategory] AC2 WITH (NOLOCK) ON AC2.[Id] = A.[IdSubCategory]
		
		WHERE	A.[Deleted] = 0 
			AND A.[Pending] = 0
			AND ((@AssetIds IS NULL) OR (dbo.[CheckValueInList](A.[Id], @AssetIds) = 1))
	END

	--declare @quantity int = 0
	--SET @quantity = (SELECT count(1) 
	--				FROM dbo.Asset a 
	--				INNER JOIN AssetPointOfInterest apoi ON apoi.[IdPointOfInterest] = @PointOfInterestId 
	--				WHERE apoi.[IdAsset] = a.[Id] AND a.[Deleted] = 0)
	
	--IF(@quantity = 0) 
	--	BEGIN 
	--		Select a.[Id], a.[Name], a.[BarCode], (CASE @ReturnImages WHEN 1 THEN a.[ImageArray] ELSE NULL END) AS ImageArray
	--		FROM Asset a
	--		WHERE a.Deleted = 0
	--	END 
	--ELSE 
	--	BEGIN
	--		Select a.[Id], a.[Name], a.[BarCode], (CASE @ReturnImages WHEN 1 THEN a.[ImageArray] ELSE NULL END) AS ImageArray
	--		from dbo.AssetPointOfInterest apoi
	--		LEFT JOIN  Asset a ON apoi.[IdAsset] = a.[Id]
	--		WHERE apoi.[IdPointOfInterest] = @PointOfInterestId AND a.[Deleted] = 0
	--	END
END
