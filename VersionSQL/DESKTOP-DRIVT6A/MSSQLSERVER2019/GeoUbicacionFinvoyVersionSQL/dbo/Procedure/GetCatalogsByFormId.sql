/****** Object:  Procedure [dbo].[GetCatalogsByFormId]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author: Cristian Barbarini
-- Create date: 15/05/2023
-- Description: SP para obtener los catalogos de un formulario
-- =============================================
CREATE PROCEDURE [dbo].[GetCatalogsByFormId]
(
	@IdForm [sys].[int] = NULL
)
AS
BEGIN
	SELECT c.Id, c.Name
	FROM FormPlus (NOLOCK) fp
	INNER JOIN FormPlusCatalog (NOLOCK) fpc ON fp.Id = fpc.IdFormPlus
	INNER JOIN Catalog (NOLOCK) c ON fpc.IdCatalog = c.Id
	WHERE IdForm = @IdForm
END
