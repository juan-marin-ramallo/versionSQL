/****** Object:  Procedure [dbo].[DeleteProductPointOfInterest]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[DeleteProductPointOfInterest](
   @IdProduct [sys].[int]
   ,@IdPointOfInterest [sys].[int]
)
AS 
BEGIN

	DELETE FROM [dbo].[ProductPointOfInterest]
	WHERE [IdProduct] = @IdProduct AND [IdPointOfInterest] = @IdPointOfInterest

	EXEC [dbo].[SaveOrUpdateProductPointOInterestChangeLog] @IdPointOfInterest = @IdPointOfInterest	
END
