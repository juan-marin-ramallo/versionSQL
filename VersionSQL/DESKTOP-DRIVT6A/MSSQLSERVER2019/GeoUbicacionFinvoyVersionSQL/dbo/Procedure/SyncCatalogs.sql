/****** Object:  Procedure [dbo].[SyncCatalogs]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SyncCatalogs]
(
	 @SyncType [int]
	,@Data [CatalogTableType] READONLY
)
AS
BEGIN
	DECLARE @Add [int] = 0
	DECLARE @AddUpdate [int] = 1
	DECLARE @AddUpdateDelete [int] = 2

	---- Update ingresados
	--IF @AddUpdate <= @SyncType
	--BEGIN
	--END	
			
	---- Delete faltantes
	--IF @AddUpdateDelete <= @SyncType
	--BEGIN	
	--END

	-- Obtengo los que no tiene referencia de producto correcta
	SELECT  C.[Name], P.[ProductBarCode]
    FROM	@Data P
			LEFT OUTER JOIN [Catalog] C ON P.[IdCatalog] = C.[Id] AND C.[Deleted] = 0	
			LEFT OUTER JOIN [Product] PP ON P.[ProductBarCode] = PP.[BarCode] AND PP.[Deleted] = 0			
    WHERE   (@Add = @SyncType AND PP.Id IS NULL)

	-- Insert nuevos 
	IF @Add <= @SyncType 
	BEGIN
		INSERT [dbo].[CatalogProduct] ([IdCatalog], [IdProduct])
		SELECT  C.[Id], PP.[Id]
		FROM	@Data as P
				INNER JOIN [Product] PP ON P.[ProductBarCode] = PP.[BarCode] AND PP.[Deleted] = 0
				INNER JOIN [Catalog] C ON P.[IdCatalog] = C.[Id]
				LEFT OUTER JOIN [dbo].[CatalogProduct] CP ON  CP.[IdProduct] = PP.[Id] AND CP.[IdCatalog] = C.[Id]
		WHERE CP.[IdProduct] IS NULL
	END
END
