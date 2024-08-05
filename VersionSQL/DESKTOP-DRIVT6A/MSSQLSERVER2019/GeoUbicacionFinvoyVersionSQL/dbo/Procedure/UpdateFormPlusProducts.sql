/****** Object:  Procedure [dbo].[UpdateFormPlusProducts]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:Cristian Barbarini
-- Create date: 15/05/2023
-- Description: SP para actualizar productos de un formulario
-- =============================================
CREATE PROCEDURE [dbo].[UpdateFormPlusProducts]
	@IdForm [sys].[int]
	,@ProductIds [dbo].[IdTableType] READONLY
AS
BEGIN
	DECLARE @IdFormPlus INT
	SELECT @IdFormPlus = Id FROM [dbo].[FormPlus] WHERE IdForm = @IdForm

	DELETE FROM [dbo].[FormPlusCatalog] WHERE [IdFormPlus] = @IdFormPlus
	DELETE FROM [dbo].[FormPlusProduct] WHERE [IdFormPlus] = @IdFormPlus

	INSERT INTO [dbo].[FormPlusProduct]([IdFormPlus], [IdProduct])
	SELECT @IdFormPlus, [Id]
	FROM @ProductIds
END
