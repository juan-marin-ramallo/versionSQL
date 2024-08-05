/****** Object:  Procedure [dbo].[SaveProductReport]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[SaveProductReport]
	@IdProduct int,
	@IdPersonOfInterest int,
	@IdPointOfInterest int,
	@Stock [sys].[INT] = NULL,
	@ReportDateTime datetime,
	@ExpirationDate datetime = NULL,
	@Price decimal(18,2) = NULL,
	@Suggested [sys].[INT] = NULL,
	@Comment VARCHAR(100) = NULL,
	@SuggestedEmail VARCHAR(100) = NULL,
	@ShortStock [sys].[BIT] = NULL,
	@TheoricalStock [sys].[INT] = NULL,
	@TheoricalPrice[sys].[decimal](18,2) = NULL,
	@Id [sys].[int] OUT,
	@Notify [sys].[bit] OUT
AS
BEGIN
	SET @Notify = 0
	SET @Id = 0

	IF EXISTS (SELECT 1 FROM [dbo].[Product] WITH (NOLOCK) WHERE [Id] = @IdProduct) AND EXISTS (SELECT 1 FROM [dbo].[PointOfInterest] WITH (NOLOCK) WHERE [id] = @IdPointOfInterest)
	BEGIN
		
		SET NOCOUNT ON;
		INSERT INTO [dbo].[ProductReport] ([IdProduct], [IdPersonOfInterest], [IdPointOfInterest], [Stock], [Deleted], 
		[ReportDateTime], [ExpirationDate], [Price], [Suggested], [ReportReceivedDate], [Comment], [ShortStock], 
		[SuggestedEmail], [TheoricalStock], [TheoricalPrice])
		VALUES (@IdProduct, @IdPersonOfInterest, @IdPointOfInterest, @Stock, 0, @ReportDateTime, @ExpirationDate, @Price,
			@Suggested, GETUTCDATE(), @Comment, @ShortStock, @SuggestedEmail, @TheoricalStock, @TheoricalPrice)
		
		
		SELECT @Id = SCOPE_IDENTITY()

		--ACTUALIZO VALORES TEORICOS EN PUNTO.
		IF EXISTS (SELECT 1 FROM [dbo].[ProductPointOfInterest] WITH (NOLOCK) WHERE [IdProduct] = @IdProduct AND [IdPointOfInterest] = @IdPointOfInterest)
		BEGIN

			UPDATE [dbo].[ProductPointOfInterest]
			SET [TheoricalStock] = @TheoricalStock, [TheoricalPrice] = @TheoricalPrice
			WHERE [IdProduct] = @IdProduct AND [IdPointOfInterest] = @IdPointOfInterest

			EXEC [dbo].[SaveOrUpdateProductPointOInterestChangeLog] @IdPointOfInterest = @IdPointOfInterest
		END
		ELSE IF (@TheoricalStock IS NOT NULL OR @TheoricalPrice IS NOT NULL)
		BEGIN
			INSERT INTO [dbo].[ProductPointOfInterest](IdProduct, IdPointOfInterest, TheoricalStock, TheoricalPrice)
			VALUES (@IdProduct,@IdPointOfInterest, @TheoricalStock, @TheoricalPrice)

			EXEC [dbo].[SaveOrUpdateProductPointOInterestChangeLog] @IdPointOfInterest = @IdPointOfInterest
		END

		

	END
END
