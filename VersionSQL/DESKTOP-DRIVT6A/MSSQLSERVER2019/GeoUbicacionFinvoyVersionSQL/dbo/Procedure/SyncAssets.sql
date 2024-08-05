/****** Object:  Procedure [dbo].[SyncAssets]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 20/04/2015
-- Description:	SP para sincronizar los Productos
-- =============================================
CREATE PROCEDURE [dbo].[SyncAssets]
(
	 @SyncType [int]
	,@Data [AssetTableType] READONLY
)
AS
BEGIN
	DECLARE @Add [int] = 0
	DECLARE @AddUpdate [int] = 1
	DECLARE @AddUpdateDelete [int] = 2

	-- Update ingresados
	IF @AddUpdate <= @SyncType
	BEGIN
		UPDATE	PR
		SET		PR.[Identifier] = P.[Id]
				,PR.[ImageArray] = IIF(P.[ImageArray] IS NULL, PR.[ImageArray], P.[ImageArray])
				,PR.[Name] = P.[Name]
				,PR.[BarCode] = P.[BarCode]
				,PR.[IdAssetType] = T.[Id]
				,PR.[Deleted] = 0
				,PR.[IdCompany] = b.[Id]
				,PR.[IdCategory] = H1.[Id]
				,PR.[IdSubCategory] = H2.[Id]
		
		FROM	[dbo].[Asset] PR
				INNER JOIN @Data as P ON PR.[Identifier] = P.[Id]
				LEFT OUTER JOIN [dbo].[AssetType] T WITH (NOLOCK) ON T.[Name] LIKE P.[TypeName]
				LEFT OUTER JOIN dbo.[Company] b WITH (NOLOCK) ON P.CompanyIdentifier = b.[Identifier] AND b.[Deleted] = 0
				LEFT OUTER JOIN [dbo].[AssetCategory] H1 WITH (NOLOCK) ON H1.[Identifier] = P.[CategoryId] AND H1.IsSubCategory = 0
				LEFT OUTER JOIN [dbo].[AssetCategory] H2 WITH (NOLOCK) ON H2.[Identifier] = P.[SubCategoryId] AND H2.IsSubCategory = 1
		
		WHERE	PR.[Deleted] = 0
				AND (H1.[Id] IS NULL OR H1.[Deleted] = 0)
				AND (H2.[Id] IS NULL OR H2.[Deleted] = 0)
	END	
			
	-- Delete faltantes
	IF @AddUpdateDelete <= @SyncType
	BEGIN	
		UPDATE	PR
		SET		PR.[Deleted] = 1
		FROM	[dbo].[Asset] PR
				LEFT OUTER JOIN @Data as P ON PR.[Identifier] = P.[Id]
		WHERE	P.[Id] IS NULL
	END

	-- Si solo agrego Obtengo los repetidos antes de agregar los nuevos
	-- de lo contrario siempre van a existir

	SELECT  P.[Id], P.[ImageArray], P.[Name], P.[BarCode], P.[TypeName],
			IIF(P.[CategoryId] IS NOT NULL AND (H1.[Id] IS NULL OR H1.[Deleted] = 1), 1, 0) -- 1 Category no existe
			,IIF(P.[SubCategoryId] IS NOT NULL AND (H2.[Id] IS NULL OR H2.[Deleted] = 1), 1, 0) -- 1 SubCategory no existe
	FROM    @Data P
			LEFT OUTER JOIN [dbo].[Asset] A WITH (NOLOCK) ON A.[Identifier] = P.[Id] AND A.[Deleted] = 0
			LEFT OUTER JOIN [dbo].[AssetCategory] H1 WITH (NOLOCK) ON H1.[Identifier] = P.[CategoryId] AND H1.IsSubCategory = 0 AND H1.[Deleted] = 0
			LEFT OUTER JOIN [dbo].[AssetCategory] H2 WITH (NOLOCK) ON H2.[Identifier] = P.[SubCategoryId] AND H2.IsSubCategory = 1 AND H2.[Deleted] = 0
	WHERE	(@Add = @SyncType AND A.[Id] IS NOT NULL)
			OR (P.[CategoryId] IS NOT NULL AND (H1.[Id] IS NULL OR H1.[Deleted] = 1))
			OR (P.[SubCategoryId] IS NOT NULL AND (H2.[Id] IS NULL OR H2.[Deleted] = 1))
	

	-- Insert nuevos 
	IF @Add <= @SyncType
	BEGIN	
		INSERT INTO [dbo].[Asset]([Name], [BarCode], [Identifier], [ImageArray], [Deleted], [IdAssetType], [IdCompany], [IdCategory],[IdSubcategory])
		
		SELECT  P.[Name], P.[BarCode], P.[Id], P.[ImageArray], 0, T.[Id], b.Id, H1.[Id], H2.[Id]

		FROM    @Data P
				LEFT OUTER JOIN [dbo].[Asset] A ON A.[Identifier] = P.[Id] AND A.[Deleted] = 0
				LEFT OUTER JOIN [dbo].[AssetType] T ON T.[Name] LIKE P.[TypeName]
				LEFT OUTER JOIN dbo.[Company] b ON P.CompanyIdentifier = b.Identifier AND b.Deleted = 0
				LEFT OUTER JOIN [dbo].[AssetCategory] H1 WITH (NOLOCK) ON H1.[Identifier] = P.[CategoryId] AND H1.IsSubCategory = 0
				LEFT OUTER JOIN [dbo].[AssetCategory] H2 WITH (NOLOCK) ON H2.[Identifier] = P.[SubCategoryId] AND H2.IsSubCategory = 1

		WHERE   A.[Id] IS NULL 
				AND (H1.[Id] IS NULL OR H1.[Deleted] = 0)
				AND (H2.[Id] IS NULL OR H2.[Deleted] = 0)
	END
END
