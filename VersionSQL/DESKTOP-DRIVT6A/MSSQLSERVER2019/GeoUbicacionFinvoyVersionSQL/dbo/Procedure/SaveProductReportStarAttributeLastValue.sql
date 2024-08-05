/****** Object:  Procedure [dbo].[SaveProductReportStarAttributeLastValue]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 27/11/2019
-- Description:	Guarda atributos estrella para control unitario
-- =============================================
CREATE PROCEDURE [dbo].[SaveProductReportStarAttributeLastValue]
	 @IdProductReportDynamic [sys].[int]
	,@IdProductReportAttribute [sys].[int]
	,@Value [sys].[varchar](MAX) = NULL
	,@IdProduct [sys].[int]
	,@IdPointOfInterest [sys].[int]
	,@IdPersonOfInterest [sys].[int] = NULL
AS
BEGIN

	IF EXISTS (SELECT 1 
			   FROM ProductReportLastStarAttributeValue 
			   WHERE [IdPointOfInterest] = @IdPointOfInterest
			     AND [IdProduct] = @IdProduct
			     AND [IdProductReportAttribute] = @IdProductReportAttribute)
	BEGIN

		UPDATE ProductReportLastStarAttributeValue
		SET  [Value] = @Value
			,[Date] = GETUTCDATE()
			,[IdPersonOfInterest] = @IdPersonOfInterest
		WHERE [IdPointOfInterest] = @IdPointOfInterest
		  AND [IdProduct] = @IdProduct
		  AND [IdProductReportAttribute] = @IdProductReportAttribute
	
	END ELSE BEGIN
		
		INSERT ProductReportLastStarAttributeValue ([IdPointOfInterest], [IdProduct], 
			[IdProductReportAttribute],	[Value], [Date], [IdPersonOfInterest])
		VALUES (@IdPointOfInterest, @IdProduct, @IdProductReportAttribute,
			@Value, GETUTCDATE(),  @IdPersonOfInterest)
	END

	EXEC [dbo].[SaveOrUpdateProductPointOInterestChangeLog] @IdPointOfInterest = @IdPointOfInterest

END
