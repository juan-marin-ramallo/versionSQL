/****** Object:  Procedure [dbo].[SyncProductBrands]    Committed by VersionSQL https://www.versionsql.com ******/

-- =========================================================================
-- Author:		Federico Sobral
-- Create date: 22/03/2019
-- Description:	SP para sincronizar las Marcas
-- Modified by: Juan Marin
-- Modified date: 22/09/2023
-- Description:Ya no se trabaja con las 5 columnas de categorias de producto
-- =========================================================================
CREATE PROCEDURE [dbo].[SyncProductBrands]
(
	 @SyncType [INT]
	,@Data [ProductBrandTableType] READONLY
)
AS
BEGIN
	SET ANSI_WARNINGS  OFF;
	DECLARE @Add [int] = 0
	DECLARE @AddUpdate [int] = 1
	DECLARE @AddUpdateDelete [int] = 2

	-- Delete faltantes
	IF @AddUpdateDelete <= @SyncType
	BEGIN	
		UPDATE	PR
		SET		PR.[Deleted] = 1
		FROM	[dbo].[ProductBrand] PR
				LEFT OUTER JOIN @Data AS P ON P.[Id] = PR.[Identifier]
		WHERE	P.[Id] IS NULL

		UPDATE	PR
		SET		PR.[Deleted] = 1
		FROM	[dbo].[ProductBrand] PR 
				INNER JOIN [dbo].[ProductBrand] C ON PR.IdFather = C.Id
				LEFT OUTER JOIN @Data AS P ON P.[Id] = C.[Identifier]
		WHERE	P.[Id] IS NULL

		--Borro asociacion con productos
		UPDATE	Prod
		SET		Prod.[IdProductBrand] = NULL
		FROM	[dbo].[Product] Prod
				INNER JOIN [dbo].[ProductBrand] PR ON PR.Id = Prod.IdProductBrand
				LEFT OUTER JOIN @Data AS P ON P.[Id] = PR.[Identifier]
		WHERE	P.[Id] IS NULL
	END

	-- Si solo agrego Obtengo los repetidos antes de agregar los nuevos
	-- de lo contrario siempre van a existir
	SELECT P.[IdCompany], P.[Id],P.[Name],P.[Description],P.[IdFather], P.[ImageName]
	FROM	@Data P
			LEFT OUTER JOIN [dbo].[ProductBrand] PR ON PR.[Identifier] = P.[Id] AND PR.[Deleted] = 0
	WHERE   @Add = @SyncType AND PR.[Id] IS NOT NULL


	-- Insert nuevos
	IF @Add <= @SyncType
	BEGIN	
		INSERT INTO [dbo].[ProductBrand]([IdCompany], [Name], [Description], [Identifier], [IsSubbrand], [IdFather], [ImageName])
		SELECT  C.Id, P.[Name], P.[Description], P.[Id], 0, NULL, P.[ImageName]
		FROM    @Data P
				INNER JOIN [dbo].[Company] C ON C.[Identifier] = P.[IdCompany] AND C.[Deleted] = 0
				LEFT OUTER JOIN [dbo].[ProductBrand] PR ON PR.[Identifier] = P.[Id] AND PR.[Deleted] = 0
		WHERE  P.IdFather IS NULL AND PR.[Id] IS NULL 

		INSERT INTO [dbo].[ProductBrand]([IdCompany], [Name], [Description], [Identifier], [IsSubbrand], [IdFather], [ImageName])
		SELECT  C.Id, P.[Name], P.[Description], P.[Id], 1, PB.[Id], P.[ImageName]
		FROM    @Data P
				INNER JOIN [dbo].[Company] C ON C.[Identifier] = P.[IdCompany] AND C.[Deleted] = 0
				LEFT OUTER JOIN [dbo].[ProductBrand] PR ON PR.[Identifier] = P.[Id] AND PR.[Deleted] = 0
				LEFT OUTER JOIN [dbo].[ProductBrand] PB ON PB.[Identifier] = P.[IdFather] AND PB.[Deleted] = 0
		WHERE  P.IdFather IS NOT NULL AND PR.[Id] IS NULL		
	END		

	-- Update ingresados
	IF @AddUpdate <= @SyncType
	BEGIN
		UPDATE	 PB
		SET		 PB.[IdCompany] = C.[Id]
				,PB.[Identifier] = D.[Id]
				,PB.[Name] = D.[Name]
				,PB.[Description] = D.[Description]
				,PB.[IsSubbrand] = IIF(F.[Id] IS NULL, 0, 1)
				,PB.[IdFather] = F.[Id]
				,PB.[ImageName] = D.[ImageName]
				,PB.[Deleted] = 0
		FROM	[dbo].[ProductBrand] PB
				INNER JOIN @Data AS D ON PB.[Identifier] = D.[Id] AND PB.[Deleted] = 0
				INNER JOIN [dbo].[Company] C ON C.[Identifier] = D.[IdCompany] AND C.[Deleted] = 0
				LEFT OUTER JOIN [dbo].[ProductBrand] F ON F.[Identifier] = D.[IdFather]
		WHERE D.[IdFather] IS NULL OR F.[Id] IS NOT NULL		
	END	

	-- obtener sin padre o sin compania
	-- Obtengo dsp de agregar por las dudas
	SELECT P.[IdCompany], P.[Id],P.[Name],P.[Description],P.[IdFather], P.[ImageName]
	FROM	@Data P
			LEFT OUTER JOIN [dbo].[Company] C ON C.[Identifier] = P.[IdCompany] AND C.[Deleted] = 0
			LEFT OUTER JOIN [dbo].[ProductBrand] PR ON PR.[Identifier] = P.[IdFather] AND PR.[Deleted] = 0
	WHERE   @Add = @SyncType AND (C.[Id] IS NULL OR (P.[IdFather] IS NOT NULL AND PR.[Id] IS NULL))

	SET ANSI_WARNINGS  ON;

END


/****** Object:  StoredProcedure [dbo].[SyncProductBrandProductCategory]    Script Date: 20/9/2023 15:48:42 ******/
