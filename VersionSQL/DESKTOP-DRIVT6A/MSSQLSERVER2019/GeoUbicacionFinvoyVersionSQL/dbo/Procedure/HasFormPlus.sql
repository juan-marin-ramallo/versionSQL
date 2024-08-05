/****** Object:  Procedure [dbo].[HasFormPlus]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Javier
-- Create date: 05/04/2023
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[HasFormPlus] 
	-- Add the parameters for the stored procedure here
	@IdProduct [sys].[int]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT DISTINCT FP.Id
	FROM dbo.Product AS P
	INNER JOIN dbo.FormPlusProduct as FPP on FPP.IdProduct = P.Id
	INNER JOIN dbo.FormPlus as FP on FP.Id = FPP.IdFormPlus
	WHERE P.Id = @IdProduct AND P.Deleted = 0 AND FP.Deleted = 0
	UNION
	SELECT DISTINCT FP.Id
	FROM dbo.Product AS P
	INNER JOIN dbo.CatalogProduct as CP on CP.IdProduct = P.Id
	INNER JOIN dbo.FormPlusCatalog as FPC on FPC.IdCatalog = CP.IdCatalog
	INNER JOIN dbo.FormPlus as FP on FP.Id = FPC.IdFormPlus
	WHERE P.Id = @IdProduct AND P.Deleted = 0 AND FP.Deleted = 0
END
