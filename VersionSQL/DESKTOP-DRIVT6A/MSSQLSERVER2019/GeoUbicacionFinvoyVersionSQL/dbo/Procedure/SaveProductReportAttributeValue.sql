/****** Object:  Procedure [dbo].[SaveProductReportAttributeValue]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SaveProductReportAttributeValue] 
	 @IdProductReportDynamic [sys].[int]
	,@IdProductReportAttribute [sys].[int]
	,@Value [sys].[varchar](MAX) = NULL
	,@IdProductReportAttributeOption [sys].[int] = NULL
	,@ImageName varchar(100) = NULL
	,@IdProduct [sys].[int]
	,@IdPointOfInterest [sys].[int]
	,@IdPersonOfInterest [sys].[int] = NULL
AS
BEGIN
	DECLARE @IDTYPE_PRICE [sys].[int] = 12

	INSERT INTO [dbo].[ProductReportAttributeValue] ([IdProductReport], [IdProductReportAttribute], [Value], 
		[IdProductReportAttributeOption], [ImageName])
	VALUES (@IdProductReportDynamic, @IdProductReportAttribute, @Value,
		@IdProductReportAttributeOption, @ImageName)

	-- En un mundo ideal acá tmb se guardan los estrellas
	IF @Value IS NOT NULL AND EXISTS (SELECT TOP 1 1 FROM dbo.ProductReportAttribute WHERE [Id] = @IdProductReportAttribute AND [IdType] = @IDTYPE_PRICE AND [IsStar] = 0)
	BEGIN		
		EXEC [dbo].[SaveProductReportStarAttributeLastValue]
				 @IdProductReportDynamic = @IdProductReportDynamic
				,@IdProductReportAttribute = @IdProductReportAttribute
				,@Value = @Value
				,@IdProduct = @IdProduct
				,@IdPointOfInterest = @IdPointOfInterest
				,@IdPersonOfInterest = @IdPersonOfInterest
	END

END
