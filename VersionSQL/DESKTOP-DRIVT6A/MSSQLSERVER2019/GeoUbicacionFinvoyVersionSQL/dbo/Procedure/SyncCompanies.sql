/****** Object:  Procedure [dbo].[SyncCompanies]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 22/03/2019
-- Description:	SP para sincronizar las companias
-- =============================================
CREATE PROCEDURE [dbo].[SyncCompanies]
(
	 @SyncType [INT]
	,@Data [CompanyTableType] READONLY
)
AS
BEGIN
	SET ANSI_WARNINGS  OFF;
	DECLARE @Add [int] = 0
	DECLARE @AddUpdate [int] = 1
	DECLARE @AddUpdateDelete [int] = 2

	-- Update ingresados
	IF @AddUpdate <= @SyncType
	BEGIN
		UPDATE	 C
		SET		 C.[Identifier] = D.[Id]
				,C.[Name] = D.[Name]
				,C.[Description] = D.[Description]
				,C.[IsMain] = D.[IsMain]
				,C.[ImageName] = D.[ImageName]
				,C.[Deleted] = 0
		FROM	[dbo].[Company] C
				INNER JOIN @Data AS D ON C.[Identifier] = D.[Id] AND C.Deleted = 0
	END	
			
	-- Delete faltantes
	IF @AddUpdateDelete <= @SyncType
	BEGIN	
		UPDATE	PR
		SET		PR.[Deleted] = 1
		FROM	[dbo].[Company] PR
				LEFT OUTER JOIN @Data AS P ON P.[Id] = PR.[Identifier]
		WHERE	P.[Id] IS NULL

		UPDATE	PR
		SET		PR.[Deleted] = 1
		FROM	[dbo].[ProductBrand] PR 
				INNER JOIN [dbo].[Company] C ON PR.IdCompany = C.Id
				LEFT OUTER JOIN @Data AS P ON P.[Id] = C.[Identifier]
		WHERE	P.[Id] IS NULL

		--Borro asociacion con productos
		UPDATE	Prod
		SET		Prod.[IdProductBrand] = NULL
		FROM	[dbo].[Product] Prod
				INNER JOIN [dbo].[ProductBrand] PR ON PR.Id = Prod.IdProductBrand
				INNER JOIN [dbo].[Company] C ON PR.IdCompany = C.Id
				LEFT OUTER JOIN @Data AS P ON P.[Id] = C.[Identifier]
		WHERE	P.[Id] IS NULL

		--Borro asociacion con tareas
		UPDATE	F 
		SET		F.[IdCompany] = NULL
		FROM	[dbo].[Form] F 
				INNER JOIN [dbo].[Company] C ON F.IdCompany = C.Id
				LEFT OUTER JOIN @Data AS P ON P.[Id] = C.[Identifier]
		WHERE	P.[Id] IS NULL

	END

	-- Si solo agrego Obtengo los repetidos antes de agregar los nuevos
	-- de lo contrario siempre van a existir	
	SELECT P.[Id],P.[Name],P.[Description],P.[IsMain], P.[ImageName]
	FROM	@Data P
			LEFT OUTER JOIN [dbo].[Company] PR ON PR.[Identifier] = P.[Id] AND PR.[Deleted] = 0
	WHERE   @Add = @SyncType AND PR.[Id] IS NOT NULL

	-- Insert nuevos
	IF @Add <= @SyncType
	BEGIN	
		INSERT INTO [dbo].[Company]([Name], [Description], [Identifier], [IsMain], [ImageName])
		SELECT  P.[Name], P.[Description], P.[Id], P.[IsMain], P.[ImageName]
		FROM    @Data P
				LEFT OUTER JOIN [dbo].[Company] PR ON PR.[Identifier] = P.[Id] AND PR.[Deleted] = 0
		WHERE   PR.[Id] IS NULL
		GROUP BY P.[Name], P.[Description], P.[Id], P.[IsMain], P.[ImageName]
	END

	SET ANSI_WARNINGS  ON;

END
