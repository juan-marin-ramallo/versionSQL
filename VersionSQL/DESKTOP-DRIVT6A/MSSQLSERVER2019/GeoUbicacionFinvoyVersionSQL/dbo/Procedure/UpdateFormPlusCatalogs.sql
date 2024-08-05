/****** Object:  Procedure [dbo].[UpdateFormPlusCatalogs]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:Cristian Barbarbini
-- Create date: 15/05/2023
-- Description: SP para actualizar catálogos de un formulario
-- =============================================
CREATE PROCEDURE [dbo].[UpdateFormPlusCatalogs]
	@IdForm [sys].[int]
	,@CatalogIds [dbo].[IdTableType] READONLY
AS
BEGIN
	DECLARE @IdFormPlus INT
	SELECT @IdFormPlus = Id FROM [dbo].[FormPlus] WHERE IdForm = @IdForm

	DELETE FROM [dbo].[FormPlusProduct] WHERE [IdFormPlus] = @IdFormPlus
	DELETE FROM [dbo].[FormPlusCatalog] WHERE [IdFormPlus] = @IdFormPlus

	INSERT INTO [dbo].[FormPlusCatalog]([IdFormPlus], [IdCatalog])
	SELECT @IdFormPlus, [Id]
	FROM @CatalogIds
END
