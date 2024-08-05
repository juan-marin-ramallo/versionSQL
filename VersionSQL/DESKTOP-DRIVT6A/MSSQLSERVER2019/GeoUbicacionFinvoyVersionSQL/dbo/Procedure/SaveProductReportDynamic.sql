/****** Object:  Procedure [dbo].[SaveProductReportDynamic]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- Modified by: Juan Marin
-- Description:	GU-3021 Restaurar version 1 de Dinamicas para que tome el valor de la tabla [ProductPointOfInterest] para La Popular
-- =============================================
CREATE PROCEDURE [dbo].[SaveProductReportDynamic]
	 @Id [sys].[int] OUT
	,@IdProduct [sys].[int]
	,@IdPersonOfInterest [sys].[int]
	,@IdPointOfInterest [sys].[int]
	,@ReportDateTime [sys].[datetime]
	,@TheoricalStock [sys].[int] = NULL
	,@TheoricalPrice [sys].[decimal](18,2) = NULL
	,@Email [sys].[varchar](50) = NULL
AS
BEGIN
	SET @Id = 0
	DECLARE @Dynamic AS [sys].[varchar](100)

	IF EXISTS (SELECT 1 FROM [dbo].[Product] WITH (NOLOCK) WHERE [Id] = @IdProduct) AND EXISTS (SELECT 1 FROM [dbo].[PointOfInterest] WITH (NOLOCK) WHERE [id] = @IdPointOfInterest)
	BEGIN		
		IF NOT EXISTS (SELECT 1 FROM [dbo].[ProductReportDynamic] WITH (NOLOCK) WHERE [IdProduct] = @IdProduct
			AND [IdPointOfInterest] = @IdPointOfInterest AND [ReportDateTime] = @ReportDateTime)
		BEGIN
			SET NOCOUNT ON;

			SET @Dynamic = (SELECT TOP 1 [Dynamic] FROM [dbo].[ProductPointOfInterest]  WITH (NOLOCK) WHERE [IdProduct] = @IdProduct AND [IdPointOfInterest] = @IdPointOfInterest)
			--SET @Dynamic = (SELECT [Dynamic] FROM [dbo].[ProductDynamic]  WITH (NOLOCK) WHERE [IdProduct] = @IdProduct AND [IdPointOfInterest] = @IdPointOfInterest)
      
			INSERT INTO [dbo].[ProductReportDynamic] ([IdProduct], [IdPersonOfInterest], [IdPointOfInterest], 
				[Deleted], [ReportDateTime], [ReportReceivedDate], [TheoricalStock], [TheoricalPrice], [Email], [Dynamic])
			VALUES (@IdProduct, @IdPersonOfInterest, @IdPointOfInterest, 
				0, @ReportDateTime, GETUTCDATE(), @TheoricalStock, @TheoricalPrice, @Email, @Dynamic)
		
			SELECT @Id = SCOPE_IDENTITY()

			--ACTUALIZO VALORES TEORICOS EN PUNTO.
			IF EXISTS (SELECT 1 FROM [dbo].[ProductPointOfInterest] WITH (NOLOCK)
						WHERE [IdProduct] = @IdProduct AND [IdPointOfInterest] = @IdPointOfInterest)
			BEGIN

				IF (@TheoricalStock IS NOT NULL OR @TheoricalPrice IS NOT NULL)
				BEGIN
					UPDATE [dbo].[ProductPointOfInterest]
					SET	   [TheoricalStock] = @TheoricalStock
						  ,[TheoricalPrice] = @TheoricalPrice
					WHERE  [IdProduct] = @IdProduct 
					   AND [IdPointOfInterest] = @IdPointOfInterest
				END
				--ELSE
				--BEGIN
				--	DELETE FROM [dbo].[ProductPointOfInterest]
				--	WHERE [IdProduct] = @IdProduct AND [IdPointOfInterest] = @IdPointOfInterest
				--END

				EXEC [dbo].[SaveOrUpdateProductPointOInterestChangeLog] @IdPointOfInterest = @IdPointOfInterest
			END
			ELSE IF (@TheoricalStock IS NOT NULL OR @TheoricalPrice IS NOT NULL)
			BEGIN
				INSERT INTO [dbo].[ProductPointOfInterest](IdProduct, IdPointOfInterest, TheoricalStock, TheoricalPrice)
				VALUES (@IdProduct,@IdPointOfInterest, @TheoricalStock, @TheoricalPrice)

				EXEC [dbo].[SaveOrUpdateProductPointOInterestChangeLog] @IdPointOfInterest = @IdPointOfInterest
			END

			    
			EXEC [dbo].[SavePointsOfInterestActivity]
				 @IdPersonOfInterest = @IdPersonOfInterest
				,@IdPointOfInterest = @IdPointOfInterest
				,@DateIn = @ReportDateTime
				,@AutomaticValue = 4
		END
	END
END
