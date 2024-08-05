/****** Object:  Procedure [dbo].[UpdateCatalogProducts]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UpdateCatalogProducts]
	 @IdCatalog [int],
	 @IdProducts [varchar](max) = NULL
AS
BEGIN

	DELETE FROM [dbo].[CatalogProduct]
	WHERE [IdCatalog] = @IdCatalog

	INSERT INTO [dbo].[CatalogProduct]([IdCatalog], [IdProduct])
	SELECT  @IdCatalog AS IdCatalog, P.[Id] AS IdProduct
	FROM	dbo.[Product] P
	WHERE   (dbo.CheckValueInList(P.[Id], @IdProducts) = 1)

END
