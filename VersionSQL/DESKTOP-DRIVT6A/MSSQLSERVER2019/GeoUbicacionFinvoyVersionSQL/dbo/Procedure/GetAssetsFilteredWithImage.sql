/****** Object:  Procedure [dbo].[GetAssetsFilteredWithImage]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetAssetsFilteredWithImage]
     @Names [varchar](max) = NULL
	,@BarCodes [varchar](max) = NULL
	,@TypeIds [varchar](max) = NULL	 
AS 
BEGIN
    
	SELECT		A.[Id], A.[Name], A.[BarCode], A.[ImageArray], A.[Identifier], 
				T.[Id] AS TypeId, T.[Name] AS TypeName, C.[Id] as IdCompany, C.[Name] as CompanyName, C.[Identifier] as CompanyIdentifier,
				A.[IdCategory], A.[IdSubCategory],
				--AC1.[Name] AS CategoryName, AC2.[Name] AS SubCategoryName,
				(case when AC1.Deleted = 0 then AC1.[Name] else null END) AS CategoryName,
				(case when AC1.[Name] is null or AC1.Deleted = 1 or AC2.Deleted = 1 then null else AC2.[Name] end) AS SubCategoryName,
				--AC1.[Identifier] AS CategoryIdentifier, AC2.[Identifier] AS SubCategoryIdentifier
				(case when AC1.Deleted = 0 then AC1.[Identifier] else null END) AS CategoryIdentifier,
				(case when AC1.[Identifier] is null or AC1.Deleted = 1 or AC2.Deleted = 1 then null else AC2.[Identifier] end) AS SubCategoryIdentifier
    
	FROM		[dbo].[Asset] A
				LEFT JOIN [dbo].[AssetType] T ON T.[Id] = A.[IdAssetType]
				LEFT JOIN [dbo].[Company] C ON C.[Id] = A.[IdCompany]
				LEFT JOIN	DBO.[AssetCategory] AC1 ON AC1.[Id] = A.[IdCategory]
				LEFT JOIN	DBO.[AssetCategory] AC2 ON AC2.[Id] = A.[IdSubCategory]

    WHERE		((@Names IS NULL) OR dbo.CheckVarcharInList(A.[Name], @Names) = 1)  AND
				((@BarCodes IS NULL) OR dbo.CheckVarcharInList(A.[BarCode], @BarCodes) = 1) AND 
				((@TypeIds IS NULL) OR dbo.CheckValueInList(A.[IdAssetType], @TypeIds) = 1) AND 

				A.[Deleted] = 0
END
