/****** Object:  Procedure [dbo].[SaveOrderReportAttributeValue]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:<Author,,Name>
-- Create date: <Create Date,,>
-- Description: <Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SaveOrderReportAttributeValue]
	@IdOrderReport [sys].[int]
	,@IdOrderReportAttribute [sys].[int]
	,@IdProduct [sys].[int]
	,@Value [sys].[varchar](MAX) = NULL
	,@IdOrderReportAttributeOption [sys].[int] = NULL
	,@ImageName varchar(100) = NULL
AS
BEGIN
	IF NOT EXISTS (SELECT 1 FROM [dbo].OrderReportAttributeValue WHERE [IdOrderReport] = @IdOrderReport AND [IdProduct] = @IdProduct)
	BEGIN
		INSERT INTO [dbo].OrderReportAttributeValue ([IdOrderReport], [IdProduct], [IdOrderReportAttribute], [Value], [IdOrderReportAttributeOption], [ImageName])
		VALUES (@IdOrderReport,@IdProduct, @IdOrderReportAttribute, @Value, @IdOrderReportAttributeOption, @ImageName)
	END
	ELSE BEGIN
		UPDATE [dbo].OrderReportAttributeValue SET [IdOrderReportAttribute] = @IdOrderReportAttribute,
			[Value] = @Value, [IdOrderReportAttributeOption] = @IdOrderReportAttributeOption, [ImageName] = @ImageName
		WHERE [IdOrderReport] = @IdOrderReport AND [IdProduct] = @IdProduct
	END
END
