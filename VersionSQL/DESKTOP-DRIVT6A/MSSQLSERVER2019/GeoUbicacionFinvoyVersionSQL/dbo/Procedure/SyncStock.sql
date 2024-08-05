/****** Object:  Procedure [dbo].[SyncStock]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 20/04/2015
-- Description:	SP para sincronizar los Productos
-- =============================================
CREATE PROCEDURE [dbo].[SyncStock]
(
	 @SyncType [int]
	,@Data [StockTableType] READONLY
)
AS
BEGIN
	DECLARE @Now [sys].[datetime]
	SET @Now = GETUTCDATE()

	DECLARE @Add [int] = 0
	DECLARE @AddUpdate [int] = 1
	DECLARE @AddUpdateDelete [int] = 2
	--DECLARE @MinStock [int] = (SELECT [Value] FROM [dbo].[Configuration] WHERE Id = 20)


	--Update ingresados
	IF @AddUpdate <= @SyncType
	BEGIN
		UPDATE	PR
		SET		PR.[TheoricalStock] = P.[Quantity],
				PR.[TheoricalPrice] = P.[Price],
				PR.[Dynamic] = P.[Dynamic]
		FROM	[dbo].[ProductPointOfInterest] PR WITH (NOLOCK)
				INNER JOIN [Product] PP WITH (NOLOCK) ON PR.[IdProduct] = PP.[Id] AND PP.[Deleted] = 0
				INNER JOIN [PointOfInterest] PPOI WITH (NOLOCK) ON PR.[IdPointOfInterest] = PPOI.[Id] AND PPOI.[Deleted] = 0
				INNER JOIN @Data as P ON P.[ProductBarCode] = PP.[BarCode] AND P.[ClientId] = PPOI.[Identifier]
	END

	-- Delete faltantes
	IF @AddUpdateDelete <= @SyncType
	BEGIN	
		DELETE PR
		FROM	[dbo].[ProductPointOfInterest] PR WITH (NOLOCK)
				INNER JOIN [dbo].[Product] PRO WITH (NOLOCK) ON PR.[IdProduct] = PRO.[Id]
				INNER JOIN [dbo].[PointOfInterest] POI WITH (NOLOCK) ON PR.[IdPointOfInterest] = POI.[Id]
				LEFT OUTER JOIN @Data as P ON POI.[Identifier] = P.[ClientId] AND PRO.[BarCode] = P.[ProductBarCode]
		WHERE	P.[ClientId] IS NULL
	END

	-- Obtengo los que no tiene referencia
	SELECT P.[ProductBarCode], P.[ClientId], P.[Quantity], P.[Price], IIF(PP.[Id] IS NULL OR PPOI.[Id] IS NULL, 1, 0)
    FROM	@Data P
			LEFT OUTER JOIN [Product] PP WITH (NOLOCK) ON P.[ProductBarCode] = PP.[BarCode] AND PP.[Deleted] = 0
			LEFT OUTER JOIN [PointOfInterest] PPOI WITH (NOLOCK) ON P.[ClientId] = PPOI.[Identifier] AND PPOI.[Deleted] = 0
			LEFT OUTER JOIN [dbo].[ProductPointOfInterest] PR WITH (NOLOCK) ON  PR.[IdProduct] = PP.[Id] 
							AND PR.[IdPointOfInterest] = PPOI.[Id]

    WHERE   (@Add = @SyncType AND PR.IdPointOfInterest IS NOT NULL)
			OR (PP.[Id] IS NULL OR PPOI.[Id] IS NULL)

	-- Insert nuevos 
	IF @Add <= @SyncType 
	BEGIN
		INSERT [dbo].[ProductPointOfInterest] ([IdProduct], [IdPointOfInterest], [TheoricalStock], [TheoricalPrice], [Dynamic])
		SELECT  PP.[Id], PPOI.[Id], P.[Quantity], P.[Price], P.[Dynamic]
		FROM	@Data as P
				INNER JOIN [Product] PP WITH (NOLOCK) ON P.[ProductBarCode] = PP.[BarCode] AND PP.[Deleted] = 0
				INNER JOIN [PointOfInterest] PPOI WITH (NOLOCK) ON P.[ClientId] = PPOI.[Identifier] AND PPOI.[Deleted] = 0
				LEFT OUTER JOIN [dbo].[ProductPointOfInterest] PR WITH (NOLOCK) ON  PR.[IdProduct] = PP.[Id] 
								AND PR.[IdPointOfInterest] = PPOI.[Id]
		WHERE PR.[IdProduct] IS NULL
	END

	--Tengo que actualizar el change log para que se vea reflejado en los disposiivos
	UPDATE	[dbo].[ProductPointOfInterestChangeLog] 
	SET		[LastUpdatedDate] = @Now

	INSERT INTO [dbo].[ProductPointOfInterestChangeLog]  ([IdPointOfInterest], [LastUpdatedDate])
	SELECT	poi.[Id], @Now
	FROM	[dbo].[PointOfInterest] AS poi WITH (NOLOCK)
	WHERE	POI.[Deleted] = 0
			AND NOT EXISTS (SELECT 1 FROM [dbo].[ProductPointOfInterestChangeLog] AS prpoi WITH (NOLOCK) 
							WHERE prpoi.[IdPointOfInterest] = poi.[Id])

END
