/****** Object:  Procedure [dbo].[SaveProductReportStarAttributeValue]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SaveProductReportStarAttributeValue]
	 @IdProductReportDynamic [sys].[int]
	,@IdProductReportAttribute [sys].[int]
	,@Value [sys].[varchar](MAX) = NULL
	,@IdProduct [sys].[int]
	,@IdPointOfInterest [sys].[int]
	,@IdPersonOfInterest [sys].[int] = NULL
AS
BEGIN
	
	INSERT INTO [dbo].[ProductReportAttributeValue] ([IdProductReport], [IdProductReportAttribute], [Value])
	VALUES (@IdProductReportDynamic, @IdProductReportAttribute, @Value)

	EXEC [dbo].[SaveProductReportStarAttributeLastValue]
			 @IdProductReportDynamic = @IdProductReportDynamic
			,@IdProductReportAttribute = @IdProductReportAttribute
			,@Value = @Value
			,@IdProduct = @IdProduct
			,@IdPointOfInterest = @IdPointOfInterest
			,@IdPersonOfInterest = @IdPersonOfInterest

END
