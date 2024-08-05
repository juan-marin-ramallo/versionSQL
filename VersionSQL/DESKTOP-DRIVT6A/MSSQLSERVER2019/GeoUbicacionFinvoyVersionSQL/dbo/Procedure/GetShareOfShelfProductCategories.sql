/****** Object:  Procedure [dbo].[GetShareOfShelfProductCategories]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 20/07/2021
-- Description:	SP para obtener las categorías
--				de productos dado un id de
--				share of shelf
-- =============================================
CREATE   PROCEDURE [dbo].[GetShareOfShelfProductCategories]
    @Id [sys].[int]
AS
BEGIN
	SELECT 	PC.[Id], PC.[Name]
	FROM 	[dbo].[ProductCategory] PC WITH (NOLOCK)
			INNER JOIN [dbo].[ShareOfShelfProductCategory] SOSPC WITH (NOLOCK) ON SOSPC.[IdProductCategory] = PC.[Id]
	WHERE 	SOSPC.[IdShareOfShelf] = @Id
END;
