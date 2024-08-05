/****** Object:  Procedure [dbo].[GetProductsByFormId]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author: Cristian Barbarini
-- Create date: 15/05/2023
-- Description: SP para obtener los productos de un formulario
-- =============================================
CREATE PROCEDURE [dbo].[GetProductsByFormId]
(
	@IdForm [sys].[int] = NULL
)
AS
BEGIN
	SELECT p.Id, p.Name, p.Identifier
	FROM FormPlus (NOLOCK) fp
	INNER JOIN FormPlusProduct (NOLOCK) fpp ON fp.Id = fpp.IdFormPlus
	INNER JOIN Product (NOLOCK) p ON fpp.IdProduct = p.Id
	WHERE fp.IdForm = @IdForm
END
