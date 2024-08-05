/****** Object:  Procedure [dbo].[GetAssetsFiltered]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetAssetsFiltered]
     @Names [varchar](max) = NULL
	,@BarCodes [varchar](max) = NULL
	,@TypeIds [varchar](max) = NULL
	,@Pending [bit] = 0
	,@IdUser [int] = NULL
AS
BEGIN
    SELECT		A.[Id], A.[Name], A.[BarCode], A.[Identifier], T.[Id] AS TypeId, T.[Name] AS TypeName,
				C.[Id] as IdCompany, C.[Name] as CompanyName,
				A.[IdCategory], A.[IdSubCategory], 
				(case when AC1.Deleted = 0 then AC1.[Name] else null END) AS CategoryName,
				(case when AC1.[Name] is null or AC1.Deleted = 1 or AC2.Deleted = 1 then null else AC2.[Name] end) AS SubCategoryName
    
	FROM		[dbo].[Asset] A
				LEFT JOIN dbo.[AssetType] T ON T.[Id] = A.[IdAssetType]
				LEFT JOIN dbo.[Company] C ON C.[Id] = A.[IdCompany]
				LEFT JOIN	DBO.[AssetCategory] AC1 ON AC1.[Id] = A.[IdCategory]
				LEFT JOIN	DBO.[AssetCategory] AC2 ON AC2.[Id] = A.[IdSubCategory]

    WHERE		((@Names IS NULL) OR dbo.CheckVarcharInList(A.[Name], @Names) = 1)  AND
				((@BarCodes IS NULL) OR dbo.CheckVarcharInList(A.[BarCode], @BarCodes) = 1) AND
				((@TypeIds IS NULL) OR dbo.CheckValueInList(A.[IdAssetType], @TypeIds) = 1) AND
				a.[Deleted] = 0 AND a.[Pending] = @Pending
				AND ((@IdUser IS NULL) OR (dbo.CheckUserInAssetCompanies(A.[IdCompany], @IdUser) = 1)) 
END
