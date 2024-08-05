/****** Object:  Procedure [dbo].[SaveProductPointOfInterest]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[SaveProductPointOfInterest](
	 @PointOfInterestIdentifier [sys].[varchar](50)
	,@ProductIdentifier [sys].[varchar](50) = null
	,@ProductBarCode [sys].[varchar](100) = null
	,@TheoricalStock [sys].[INT] = NULL
	,@TheoricalPrice [sys].[DECIMAL](18,2) = NULL
)
AS 
BEGIN

	DECLARE @PointOfInterestId [sys].[int] = (SELECT p.[Id] FROM [dbo].[PointOfInterest] p WHERE p.[Identifier] = @PointOfInterestIdentifier)
	DECLARE @ProductId [sys].[int] = (SELECT pr.[Id] FROM [dbo].[Product] pr WHERE (@ProductIdentifier IS NOT NULL AND pr.[Identifier] = @ProductIdentifier) OR (@ProductIdentifier IS NULL AND @ProductBarCode IS NOT NULL AND @ProductBarCode = pr.[BarCode]))

	IF(@PointOfInterestId IS NOT NULL AND @ProductId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM [dbo].[ProductPointOfInterest] WHERE [IdProduct] = @ProductId AND [IdPointOfInterest] = @PointOfInterestId))
	BEGIN
		INSERT INTO [dbo].[ProductPointOfInterest] (IdProduct, IdPointOfInterest, [TheoricalStock], [TheoricalPrice])
		VALUES (@ProductId ,@PointOfInterestId, @TheoricalStock, @TheoricalPrice)

		EXEC [dbo].[SaveOrUpdateProductPointOInterestChangeLog] @IdPointOfInterest = @PointOfInterestId

	END
END	
