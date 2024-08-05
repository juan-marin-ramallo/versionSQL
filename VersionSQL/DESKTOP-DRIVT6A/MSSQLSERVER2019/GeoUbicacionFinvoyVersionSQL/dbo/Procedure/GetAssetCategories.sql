/****** Object:  Procedure [dbo].[GetAssetCategories]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		gl
-- Create date: 12/03/21
-- Description:	SP para obtener categorias de activos
-- =============================================
CREATE PROCEDURE [dbo].[GetAssetCategories]
	 @IdCategoryFather [sys].[INT] = 0,
	 @IncludeDeleted [sys].[BIT] = 0
AS
BEGIN

	IF @IdCategoryFather = 0
	BEGIN
		--quiero todas las categorias
		SELECT	AC.[Id], AC.[Name], AC.[Identifier], AC.[IdCategoryFather], AC.IsSubCategory, AC.CreatedDate, AC.Deleted, AC.[IdUser]
		FROM	[dbo].[AssetCategory] AC WITH (NOLOCK)
		WHERE	(AC.[Deleted] = 0 OR @IncludeDeleted = 1)
	         AND (
					AC.[Id] IN (select AC1.[id] from AssetCategory AC1 where AC1.[IdCategoryFather] IS NULL AND AC1.[IsSubCategory]=0 AND AC1.[Deleted] = 0 )
					OR AC.[IdCategoryFather] IN (select [id] from [AssetCategory] AC1 where AC1.[IdCategoryFather] IS NULL AND AC1.[IsSubCategory]=0 AND AC1.[Deleted] = 0)
				)
		
		order by AC.[Name]

	END
	ELSE
	BEGIN
		--SOLO QUIERO LAS CATEGORIAS NIVEL 2
		SELECT	AC.[Id], AC.[Name], AC.[Identifier], AC.[IdCategoryFather], AC.IsSubCategory, AC.CreatedDate, AC.Deleted, AC.[IdUser]
		FROM	[dbo].[AssetCategory] AC WITH (NOLOCK)
		WHERE	(AC.[Deleted] = 0 OR @IncludeDeleted = 1) AND AC.IsSubCategory = 1 AND AC.IdCategoryFather = @IdCategoryFather
		order by AC.[Name]

	END


    
END
