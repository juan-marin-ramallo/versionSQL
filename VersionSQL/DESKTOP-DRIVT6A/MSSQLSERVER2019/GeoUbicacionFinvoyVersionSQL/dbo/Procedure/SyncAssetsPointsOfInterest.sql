/****** Object:  Procedure [dbo].[SyncAssetsPointsOfInterest]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 20/04/2015
-- Description:	SP para sincronizar los Productos
-- =============================================
CREATE PROCEDURE [dbo].[SyncAssetsPointsOfInterest]
(
	 @SyncType [int]
	,@Data [AssetPointOfInterestTableType] READONLY
)
AS
BEGIN
	DECLARE @Add [int] = 0
	DECLARE @AddUpdate [int] = 1
	DECLARE @AddUpdateDelete [int] = 2

	-- Update ingresados
	--IF @AddUpdate <= @SyncType
	--BEGIN
	--END	
			
	-- Delete faltantes
	IF @AddUpdateDelete <= @SyncType
	BEGIN	
		UPDATE PR
		SET [Deleted] = 1,
			[DateTo] = GETUTCDATE()
		FROM	[dbo].[AssetPointOfInterest] PR
				INNER JOIN [dbo].[Asset] A ON PR.[IdAsset] = A.[Id]
				INNER JOIN [dbo].[PointOfInterest] POI ON PR.[IdPointOfInterest] = POI.[Id]
				LEFT OUTER JOIN @Data as P ON POI.[Identifier] = P.[PointOfInterestId] AND A.[Identifier] = P.[AssetId]
		WHERE	PR.[Deleted] = 0 AND P.[PointOfInterestId] IS NULL
	END

	-- Obtengo los que no tiene referencia
	SELECT P.[PointOfInterestId],P.[AssetId], IIF(A.[Id] IS NULL OR POI.[Id] IS NULL, 1, 0)
	FROM	@Data P
			LEFT OUTER JOIN [dbo].[Asset] A ON A.[Identifier] = P.[AssetId]
			LEFT OUTER JOIN [dbo].[PointOfInterest] POI ON POI.[Identifier] = P.[PointOfInterestId]
			LEFT OUTER JOIN [dbo].[AssetPointOfInterest] PR ON PR.[IdAsset] = A.[Id] AND PR.[IdPointOfInterest] = POI.[Id] AND PR.[Deleted] = 0
	WHERE   (@Add = @SyncType AND PR.IdAsset IS NOT NULL)
			OR (A.[Id] IS NULL OR POI.[Id] IS NULL)

	-- Insert nuevos 
	IF @Add <= @SyncType
	BEGIN	
		INSERT INTO [dbo].[AssetPointOfInterest]([IdPointOfInterest], [IdAsset])
		SELECT  POI.[Id], A.[Id]
		FROM    @Data P		 
				INNER JOIN [dbo].[Asset] A ON A.[Identifier] = P.[AssetId]
				INNER JOIN [dbo].[PointOfInterest] POI ON POI.[Identifier] = P.[PointOfInterestId]
				LEFT OUTER JOIN [dbo].[AssetPointOfInterest] PR ON PR.[IdAsset] = A.[Id] AND PR.[IdPointOfInterest] = POI.[Id] AND PR.[Deleted] = 0
		WHERE   PR.[IdPointOfInterest] IS NULL 
	END

END
