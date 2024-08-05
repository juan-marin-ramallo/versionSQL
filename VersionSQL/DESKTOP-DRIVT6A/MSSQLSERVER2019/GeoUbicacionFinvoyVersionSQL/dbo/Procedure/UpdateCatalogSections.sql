/****** Object:  Procedure [dbo].[UpdateCatalogSections]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author: Cbarbarini
-- Create date: 04/11/2021
-- Description: SP encargado de guardar las secciones asociadas al catalogo
-- =============================================
CREATE PROCEDURE [dbo].[UpdateCatalogSections]
	@IdCatalog int,
	@IdSections varchar(max) = NULL
AS
BEGIN
	DELETE FROM dbo.CatalogProductReportSection
	WHERE IdCatalog = @IdCatalog AND (@IdSections IS NULL OR dbo.CheckValueInList(IdProductReportSection, @IdSections) = 0)

	INSERT INTO dbo.CatalogProductReportSection(IdCatalog, IdProductReportSection)
	SELECT @IdCatalog AS IdCatalog, P.Id AS IdProductReportSection
	FROM dbo.ProductReportSection P
	LEFT OUTER JOIN dbo.CatalogProductReportSection CP ON P.Id = CP.IdProductReportSection AND CP.IdCatalog = @IdCatalog
	WHERE CP.Id IS NULL AND (@IdSections IS NULL OR dbo.CheckValueInList(P.Id, @IdSections) = 1) AND P.Deleted = 0
END
