/****** Object:  Procedure [dbo].[DeleteAllProductPointOfInterest]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[DeleteAllProductPointOfInterest](
	@IdPointOfInterest [sys].[int]
)
AS 
BEGIN

	DELETE FROM [dbo].[ProductPointOfInterest]
	WHERE [IdPointOfInterest] = @IdPointOfInterest
	
	DELETE FROM [dbo].[CatalogPointOfInterest]
	WHERE [IdPointOfInterest] = @IdPointOfInterest

	EXEC [dbo].[SaveOrUpdateProductPointOInterestChangeLog] @IdPointOfInterest = @IdPointOfInterest	
END
