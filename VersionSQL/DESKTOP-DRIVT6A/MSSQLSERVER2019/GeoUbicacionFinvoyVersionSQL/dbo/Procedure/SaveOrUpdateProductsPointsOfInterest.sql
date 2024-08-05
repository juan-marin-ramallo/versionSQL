/****** Object:  Procedure [dbo].[SaveOrUpdateProductsPointsOfInterest]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 06/12/15
-- Description:	SP para agregar o actualizar los productos en puntos de interés
-- =============================================
CREATE PROCEDURE [dbo].[SaveOrUpdateProductsPointsOfInterest]
(
	  @PointsOfInterestIds [sys].[varchar](8000)
	 ,@ProductsIds [sys].[varchar](8000)
	 ,@TheoricalStock [sys].[INT] = NULL
	 ,@TheoricalPrice [sys].[DECIMAL](18,2) = NULL
)
AS
BEGIN
	DECLARE @Now [sys].[datetime]
	SET @Now = GETUTCDATE()

	DECLARE @Delimiter [sys].[varchar](1)
	SET @Delimiter = ','
	
	DECLARE @PointsOfInterestIdsXML XML;
	SET @PointsOfInterestIdsXML = CAST('<d>' + REPLACE(@PointsOfInterestIds, @Delimiter, '</d><d>') + '</d>' AS XML)

	DECLARE @ProductsIdsXML XML;
	SET @ProductsIdsXML = CAST('<d>' + REPLACE(@ProductsIds, @Delimiter, '</d><d>') + '</d>' AS XML)

	BEGIN TRANSACTION;
    SAVE TRANSACTION SaveOrUpdateProducts;
	BEGIN TRY
		CREATE TABLE #PointsOfInterest
		(
			[Id] [sys].[int]
		)
		INSERT INTO #PointsOfInterest
		SELECT	[Id]
		FROM	[dbo].[PointOfInterest] WITH (NOLOCK)
		WHERE	[Deleted] = 0
				AND [Id] IN (SELECT T.split.value('.', 'int') FROM @PointsOfInterestIdsXML.nodes('/d') T (split) WHERE T.split.value('.', 'int') > 0)

		CREATE TABLE #ProductPointOfInterest
		(
			[IdPointOfInterest]  [sys].[int] NOT NULL,
			[IdProduct]  [sys].[int] NOT NULL,
			[IdCatalog] [sys].[int] NULL
		)
		INSERT INTO #ProductPointOfInterest(IdPointOfInterest,IdProduct,IdCatalog)
		SELECT IdPointOfInterest,IdProduct,IdCatalog from ProductPointOfInterest

		CREATE TABLE #ProductPointOfInterestChangeLog
		(
			[IdPointOfInterest] [sys].[int]
		)
		INSERT INTO #ProductPointOfInterestChangeLog(IdPointOfInterest)
		SELECT IdPointOfInterest from ProductPointOfInterestChangeLog

		UPDATE	[dbo].[ProductPointOfInterest] 	
		SET		[TheoricalStock] = @TheoricalStock, [TheoricalPrice] = @TheoricalPrice	
		WHERE	[IdPointOfInterest] IN (SELECT T.split.value('.', 'int') FROM @PointsOfInterestIdsXML.nodes('/d') T (split) WHERE T.split.value('.', 'int') > 0)
				AND [IdProduct] IN (SELECT T.split.value('.', 'int') FROM @ProductsIdsXML.nodes('/d') T (split) WHERE T.split.value('.', 'int') > 0)

		INSERT INTO [dbo].[ProductPointOfInterest]  ([IdPointOfInterest], [IdProduct], [TheoricalStock],[TheoricalPrice])
		SELECT	poi.[Id], pr.[Id], @TheoricalStock, @TheoricalPrice	
		FROM	#PointsOfInterest AS poi WITH (NOLOCK), [dbo].[Product] AS pr WITH (NOLOCK)
		WHERE	pr.[Id] IN (SELECT T.split.value('.', 'int') FROM @ProductsIdsXML.nodes('/d') T (split) WHERE T.split.value('.', 'int') > 0)
				AND NOT EXISTS (SELECT 1 FROM #ProductPointOfInterest AS prpoi WITH (NOLOCK)
								WHERE prpoi.[IdPointOfInterest] = poi.[Id] AND prpoi.[IdProduct] = pr.[Id] AND prpoi.IdCatalog IS NULL)
		
		UPDATE	[dbo].[ProductPointOfInterestChangeLog] 
		SET		[LastUpdatedDate] = @Now
		WHERE	[IdPointOfInterest] IN (SELECT T.split.value('.', 'int') FROM @PointsOfInterestIdsXML.nodes('/d') T (split) WHERE T.split.value('.', 'int') > 0)

		INSERT INTO [dbo].[ProductPointOfInterestChangeLog]  ([IdPointOfInterest], [LastUpdatedDate])
		SELECT	poi.[Id], @Now
		FROM	#PointsOfInterest AS poi WITH (NOLOCK)
		WHERE	[Id] NOT IN (SELECT prpoi.[IdPointOfInterest] FROM #ProductPointOfInterestChangeLog AS prpoi)

		DROP TABLE #PointsOfInterest
		DROP TABLE #ProductPointOfInterest
		DROP TABLE #ProductPointOfInterestChangeLog
	END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION SaveOrUpdateProducts;
        END
    END CATCH
    COMMIT TRANSACTION 
END

-- OLD) 2022-07-26
--BEGIN
--	DECLARE @Now [sys].[datetime]
--	SET @Now = GETUTCDATE()

--	BEGIN TRANSACTION;
--    SAVE TRANSACTION SaveOrUpdateProducts;
--	BEGIN TRY

--	CREATE TABLE #ProductPointOfInterest(
--										 [IdPointOfInterest]  [sys].[int],
--										 [IdProduct]  [sys].[int] NOT NULL,
--										 [IdCatalog] [sys].[int] NOT NULL
--										)
--	INSERT INTO #ProductPointOfInterest(IdPointOfInterest,IdProduct,IdCatalog)
--	SELECT IdPointOfInterest,IdProduct,IdCatalog from ProductPointOfInterest

--	CREATE TABLE #ProductPointOfInterestChangeLog(
--												  [IdPointOfInterest] [sys].[int]
--											     )
--	INSERT INTO #ProductPointOfInterestChangeLog(IdPointOfInterest)
--	SELECT IdPointOfInterest from ProductPointOfInterestChangeLog

--	UPDATE	[dbo].[ProductPointOfInterest] 	
--	SET		[TheoricalStock] = @TheoricalStock, [TheoricalPrice] = @TheoricalPrice	
--	WHERE	[dbo].[CheckValueInList]([IdPointOfInterest], @PointsOfInterestIds) > 0
--			AND [dbo].[CheckValueInList]([IdProduct], @ProductsIds) > 0

--	INSERT INTO [dbo].[ProductPointOfInterest]  ([IdPointOfInterest], [IdProduct], [TheoricalStock],[TheoricalPrice])
--	SELECT	poi.[Id], pr.[Id], @TheoricalStock, @TheoricalPrice	
--	FROM	[dbo].[PointOfInterest] AS poi WITH (NOLOCK), [dbo].[Product] AS pr WITH (NOLOCK)
--	WHERE	[dbo].[CheckValueInList](poi.[Id], @PointsOfInterestIds) > 0
--			AND [dbo].[CheckValueInList](pr.[Id], @ProductsIds) > 0
--			AND NOT EXISTS (SELECT 1 FROM #ProductPointOfInterest AS prpoi WITH (NOLOCK)
--							WHERE prpoi.[IdPointOfInterest] = poi.[Id] AND prpoi.[IdProduct] = pr.[Id] AND prpoi.IdCatalog IS NULL)
--			AND poi.Deleted=0
--	UPDATE	[dbo].[ProductPointOfInterestChangeLog] 
--	SET		[LastUpdatedDate] = @Now
--	WHERE	[dbo].[CheckValueInList]([IdPointOfInterest], @PointsOfInterestIds) > 0

--	INSERT INTO [dbo].[ProductPointOfInterestChangeLog]  ([IdPointOfInterest], [LastUpdatedDate])
--	SELECT	poi.[Id], @Now
--	FROM	[dbo].[PointOfInterest] AS poi WITH (NOLOCK)
--	WHERE	[dbo].[CheckValueInList](poi.[Id], @PointsOfInterestIds) > 0 and poi.[Deleted] = 0
--			AND NOT EXISTS (SELECT 1 FROM #ProductPointOfInterestChangeLog AS prpoi 
--							WHERE prpoi.[IdPointOfInterest] = poi.[Id])
--			AND poi.Deleted=0

--	END TRY
--    BEGIN CATCH
--        IF @@TRANCOUNT > 0
--        BEGIN
--            ROLLBACK TRANSACTION SaveOrUpdateProducts; --
--        END
--    END CATCH
--    COMMIT TRANSACTION 

--	DROP TABLE #ProductPointOfInterest
--	DROP TABLE #ProductPointOfInterestChangeLog
--END
