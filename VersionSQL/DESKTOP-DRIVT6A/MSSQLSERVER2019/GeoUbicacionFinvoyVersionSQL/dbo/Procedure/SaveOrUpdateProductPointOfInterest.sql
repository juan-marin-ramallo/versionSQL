/****** Object:  Procedure [dbo].[SaveOrUpdateProductPointOfInterest]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 06/12/15
-- Description:	SP para agregar o actualizar los productos en puntos de interés
-- =============================================
CREATE PROCEDURE [dbo].[SaveOrUpdateProductPointOfInterest]
(
	 @PointOfInterestIdentifier [sys].[varchar](50)
	,@ProductIdentifier [sys].[varchar](50) = NULL
	,@ProductBarCode [sys].[varchar](100) = NULL
    ,@TheoricalStock [sys].[INT] = NULL
	,@TheoricalPrice [sys].[DECIMAL](18,2) = NULL
)
AS
BEGIN
	DECLARE @PointOfInterestId [sys].[int] = (SELECT p.[Id] FROM [dbo].[PointOfInterest] p WHERE p.[Identifier] = @PointOfInterestIdentifier)
	DECLARE @ProductId [sys].[int] = (SELECT pr.[Id] FROM [dbo].[Product] pr WHERE (@ProductIdentifier IS NOT NULL AND pr.[Identifier] = @ProductIdentifier) OR (@ProductIdentifier IS NULL AND @ProductBarCode IS NOT NULL AND @ProductBarCode = pr.[BarCode]))

	IF(@PointOfInterestId IS NOT NULL AND @ProductId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM [dbo].[ProductPointOfInterest] WHERE [IdProduct] = @ProductId AND [IdPointOfInterest] = @PointOfInterestId))
	BEGIN
		INSERT INTO [dbo].[ProductPointOfInterest] (IdProduct, IdPointOfInterest, TheoricalStock, TheoricalPrice)
		VALUES (@ProductId ,@PointOfInterestId , @TheoricalStock, @TheoricalPrice)
	END
	ELSE IF (@PointOfInterestId IS NOT NULL AND @ProductId IS NOT NULL)
	BEGIN
		UPDATE	[dbo].[ProductPointOfInterest] 
		SET		[TheoricalStock] = @TheoricalStock , [TheoricalPrice] = @TheoricalPrice
		WHERE	[IdProduct] = @ProductId AND [IdPointOfInterest] = @PointOfInterestId
	END

	EXEC [dbo].[SaveOrUpdateProductPointOInterestChangeLog] @IdPointOfInterest = @PointOfInterestId
END
