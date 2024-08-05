/****** Object:  Procedure [dbo].[GetAssetsForHash]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetAssetsForHash]
AS
BEGIN

  SET NOCOUNT ON;

   SELECT	A.[Id], A.[Name], A.[BarCode], A.[Identifier], T.[Id] AS TypeId, T.[Name] AS TypeName,
			C.[Id] as IdCompany, C.[Name] as CompanyName
    
	FROM	[dbo].[Asset] A
			LEFT JOIN dbo.[AssetType] T ON T.[Id] = A.[IdAssetType]
			LEFT JOIN dbo.[Company] C ON C.[Id] = A.[IdCompany]

	WHERE	A.[Deleted] = 0
END
