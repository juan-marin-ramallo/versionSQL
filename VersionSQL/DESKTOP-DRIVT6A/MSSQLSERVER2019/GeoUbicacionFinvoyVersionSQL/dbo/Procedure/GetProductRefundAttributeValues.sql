/****** Object:  Procedure [dbo].[GetProductRefundAttributeValues]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 20/07/2018
-- Description:	Devuelve los valores de los atributos dinamicos reportados en control de devolucion de sku
-- =============================================
CREATE PROCEDURE [dbo].[GetProductRefundAttributeValues]
(
	@IdProductRefund [sys].[int]
)
AS
BEGIN
	SELECT	[Id], [Value], [IdProductRefund], [IdProductRefundAttribute], [IdProductRefundAttributeOption],
			[ImageName], [ImageEncoded]	
	FROM	[dbo].[ProductRefundAttributeValue] WITH (NOLOCK)
	WHERE	[IdProductRefund] = @IdProductRefund
END
