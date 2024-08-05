/****** Object:  Procedure [dbo].[SaveProductRefundAttributeValue]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 16/07/2018
-- Description:	Guarda los valores de los atributos dinamicos de la devolucion
-- =============================================
CREATE PROCEDURE [dbo].[SaveProductRefundAttributeValue] 
	 @IdProductRefund [sys].[int]
	,@IdProductRefundAttribute [sys].[int]
	,@Value [sys].[varchar](MAX) = NULL
	,@IdProductRefundAttributeOption [sys].[int] = NULL
	,@ImageName varchar(100) = NULL
AS
BEGIN

	INSERT INTO [dbo].[ProductRefundAttributeValue] ([IdProductRefund], [IdProductRefundAttribute], [Value], 
		[IdProductRefundAttributeOption], [ImageName])
	VALUES (@IdProductRefund, @IdProductRefundAttribute, @Value,@IdProductRefundAttributeOption, @ImageName)

END
