/****** Object:  Procedure [dbo].[SaveAutomaticProductReportAttributeValues]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SaveAutomaticProductReportAttributeValues]
	 @IdProductReportDynamic [sys].[int]
	,@IdPointOfInterest [sys].[int]
	,@LastValues [sys].[bit] = 0
AS
BEGIN

	DECLARE @IDTYPE_PRICE [sys].[int] = 12
	DECLARE @IdProductReportAttribute AS INT
	DECLARE @IdProductReportOption AS INT
	DECLARE @ImageName AS varchar(100)
	DECLARE @ImageEncoded AS VARBINARY(MAX)
	DECLARE @Value AS VARCHAR(MAX)
	DECLARE @DefaultValue AS VARCHAR(MAX)
	DECLARE @ImageUrl AS varchar(5000)

	DECLARE @IdProduct [sys].[int] = (SELECT P.[IdProduct] FROM dbo.[ProductReportDynamic] P WITH(NOLOCK) WHERE P.[Id] = @IdProductReportDynamic)
	DECLARE @IdPersonOfInterest [sys].[int] = (SELECT P.[IdPersonOfInterest] FROM dbo.[ProductReportDynamic] P WITH(NOLOCK) WHERE P.[Id] = @IdProductReportDynamic)

	IF @LastValues = 1
	BEGIN

		DECLARE @PreviousProductReportDynamicId [sys].[int] = 
		   (SELECT TOP 1 P.[Id] 
			FROM	dbo.[ProductReportDynamic] P WITH(NOLOCK)
			JOIN	dbo.[ProductReportAttributeValue] PAV WITH(NOLOCK) ON PAV.[IdProductReport] = P.[Id]
			JOIN	dbo.[ProductReportAttribute] PA WITH(NOLOCK) ON PA.[Id] = PAV.[IdProductReportAttribute]
			WHERE	P.[IdPointOfInterest] = @IdPointOfInterest AND P.[IdProduct] = @IdProduct AND PA.[Deleted] = 0 AND PA.[FullDeleted] = 0
			ORDER BY [ReportDateTime] DESC)

		IF @PreviousProductReportDynamicId IS NOT NULL
		BEGIN 

			DECLARE cur CURSOR FOR SELECT [IdProductReportAttribute], [IdProductReportAttributeOption], 
					[ImageName], [ImageEncoded], [Value], [ImageUrl]
			FROM	[dbo].[ProductReportAttributeValue] WITH(NOLOCK)
			WHERE	[IdProductReport] = @PreviousProductReportDynamicId
	 
			OPEN cur

			FETCH NEXT FROM cur INTO @IdProductReportAttribute, @IdProductReportOption, @ImageName, @ImageEncoded, @Value, @ImageUrl

			WHILE @@FETCH_STATUS = 0 
			BEGIN

				INSERT INTO [dbo].[ProductReportAttributeValue] ([IdProductReport], [IdProductReportAttribute], [Value], 
							[IdProductReportAttributeOption], [ImageName], [ImageEncoded],[ImageUrl])
				VALUES	(@IdProductReportDynamic, @IdProductReportAttribute, @Value, @IdProductReportOption, 
						@ImageName, @ImageEncoded, @ImageUrl)

				IF EXISTS (SELECT 1 
							FROM [dbo].[ProductReportLastStarAttributeValue]
							WHERE [IdPointOfInterest] = @IdPointOfInterest
							 AND [IdProduct] = @IdProduct
							 AND [IdProductReportAttribute] = @IdProductReportAttribute)
				BEGIN
					--Verifico que siga siendo estrella
					IF EXISTS(SELECT 1 FROM [dbo].[ProductReportAttribute] WHERE [Id] = @IdProductReportAttribute AND [Deleted] = 0 AND [FullDeleted] = 0 AND ([IsStar] = 1 OR [IdType] = @IDTYPE_PRICE))
					BEGIN
						UPDATE	[dbo].[ProductReportLastStarAttributeValue]
						SET		[Value] = @Value, [Date] = GETUTCDATE(), [IdPersonOfInterest] = @IdPersonOfInterest
						WHERE	[IdPointOfInterest] = @IdPointOfInterest AND [IdProduct] = @IdProduct
								AND [IdProductReportAttribute] = @IdProductReportAttribute
					END
				END 
				ELSE 
				BEGIN
				IF EXISTS(SELECT 1 FROM [dbo].[ProductReportAttribute] WHERE [Id] = @IdProductReportAttribute AND [Deleted] = 0 AND [FullDeleted] = 0 AND ([IsStar] = 1 OR [IdType] = @IDTYPE_PRICE))
				BEGIN
					INSERT	[dbo].[ProductReportLastStarAttributeValue] ([IdPointOfInterest], [IdProduct], 
							[IdProductReportAttribute],	[Value], [Date], [IdPersonOfInterest])
					VALUES	(@IdPointOfInterest, @IdProduct, @IdProductReportAttribute, @Value, GETUTCDATE(), @IdPersonOfInterest)
				END
				END 


			FETCH NEXT FROM cur INTO @IdProductReportAttribute, @IdProductReportOption, @ImageName, @ImageEncoded, @Value, @ImageUrl
			END

			CLOSE cur    
			DEALLOCATE cur

			--INSERT INTO [dbo].[ProductReportAttributeValue] ([IdProductReport], [IdProductReportAttribute], [Value], 
			--			[IdProductReportAttributeOption], [ImageName], [ImageEncoded])
			--SELECT	@IdProductReportDynamic, [IdProductReportAttribute], [Value], [IdProductReportAttributeOption], 
			--		[ImageName], [ImageEncoded]
			--FROM	[dbo].[ProductReportAttributeValue] WITH(NOLOCK)
			--WHERE	[IdProductReport] = @PreviousProductReportDynamicId

		END
	END
	ELSE
	BEGIN

		--Agrego todos los valores del producto en 0
		--INSERT INTO [dbo].[ProductReportAttributeValue] ([IdProductReport], [IdProductReportAttribute], [Value], 
		--			[IdProductReportAttributeOption], [ImageName], [ImageEncoded])
		--SELECT	@IdProductReportDynamic, [Id], [DefaultValue], NULL, NULL, NULL
		--FROM	[dbo].[ProductReportAttribute]
		--WHERE	[Deleted] = 0 AND [FullDeleted] = 0

			DECLARE cur2 CURSOR FOR SELECT [Id], [DefaultValue]
			FROM	[dbo].[ProductReportAttribute] WITH(NOLOCK)
			WHERE	[Deleted] = 0 AND [FullDeleted] = 0
	 
			OPEN cur2

			FETCH NEXT FROM cur2 INTO @IdProductReportAttribute, @DefaultValue

			WHILE @@FETCH_STATUS = 0 
			BEGIN

				INSERT INTO [dbo].[ProductReportAttributeValue] ([IdProductReport], [IdProductReportAttribute], [Value], 
					[IdProductReportAttributeOption], [ImageName], [ImageEncoded],[ImageUrl])
				VALUES (@IdProductReportDynamic,@IdProductReportAttribute,@DefaultValue, NULL, NULL, NULL, NULL)

				IF EXISTS (SELECT 1 
							FROM [dbo].[ProductReportLastStarAttributeValue]
							WHERE [IdPointOfInterest] = @IdPointOfInterest
							 AND [IdProduct] = @IdProduct
							 AND [IdProductReportAttribute] = @IdProductReportAttribute)
				BEGIN
					--Verifico que siga siendo estrella
					IF @Value IS NOT NULL AND EXISTS(SELECT 1 FROM [dbo].[ProductReportAttribute] WHERE [Id] = @IdProductReportAttribute AND [Deleted] = 0 AND [FullDeleted] = 0 AND ([IsStar] = 1 OR [IdType] = @IDTYPE_PRICE))
					BEGIN
						UPDATE	[dbo].[ProductReportLastStarAttributeValue]
						SET		[Value] = @Value, [Date] = GETUTCDATE(), [IdPersonOfInterest] = @IdPersonOfInterest
						WHERE	[IdPointOfInterest] = @IdPointOfInterest AND [IdProduct] = @IdProduct
								AND [IdProductReportAttribute] = @IdProductReportAttribute
					END
				END 
				ELSE 
				BEGIN
				IF @Value IS NOT NULL AND EXISTS(SELECT 1 FROM [dbo].[ProductReportAttribute] WHERE [Id] = @IdProductReportAttribute AND [Deleted] = 0 AND [FullDeleted] = 0 AND ([IsStar] = 1 OR [IdType] = @IDTYPE_PRICE))
				BEGIN
					INSERT	[dbo].[ProductReportLastStarAttributeValue] ([IdPointOfInterest], [IdProduct], 
							[IdProductReportAttribute],	[Value], [Date], [IdPersonOfInterest])
					VALUES	(@IdPointOfInterest, @IdProduct, @IdProductReportAttribute, @Value, GETUTCDATE(), @IdPersonOfInterest)
				END
				END 


			FETCH NEXT FROM cur2 INTO  @IdProductReportAttribute, @DefaultValue
			END

			CLOSE cur2   
			DEALLOCATE cur2

	END
END
