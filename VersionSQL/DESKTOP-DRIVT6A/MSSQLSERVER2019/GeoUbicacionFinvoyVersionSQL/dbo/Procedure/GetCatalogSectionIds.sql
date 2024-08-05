/****** Object:  Procedure [dbo].[GetCatalogSectionIds]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:Cbarbarini
-- Create date: 04/11/2021
-- Description: SP encargado de obtener las secciones por catalogo
-- =============================================
CREATE PROCEDURE [dbo].[GetCatalogSectionIds]
	@IdCatalog [int]
AS
BEGIN
	SELECT CP.IdProductReportSection AS Id, S.Name
	FROM CatalogProductReportSection CP
	LEFT JOIN ProductReportSection S ON S.Id = CP.IdProductReportSection
	WHERE CP.IdCatalog = @IdCatalog
END
