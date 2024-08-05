/****** Object:  Procedure [dbo].[GetProductReportAttributeImage]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 22/09/2016
-- Description:	SP para obtener las imagenes de atributos del reporte de stock
-- =============================================

CREATE PROCEDURE [dbo].[GetProductReportAttributeImage] 
	@AttributeId [sys].[INT]
AS
BEGIN

	SELECT		P.[ImageEncoded] AS FileEncoded, P.[ImageName], P.[ImageUrl]
	FROM		[dbo].[ProductReportAttributeValue] P	
	WHERE		P.[Id] = @AttributeId
		
END
