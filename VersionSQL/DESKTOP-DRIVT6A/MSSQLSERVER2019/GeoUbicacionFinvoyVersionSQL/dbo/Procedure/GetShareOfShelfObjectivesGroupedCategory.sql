/****** Object:  Procedure [dbo].[GetShareOfShelfObjectivesGroupedCategory]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 27/03/2019
-- Description:	SP para obtener el reporte Share of shelf
-- =============================================
CREATE PROCEDURE [dbo].[GetShareOfShelfObjectivesGroupedCategory]
(
	 @IdZone [sys].[int] = NULL
	,@IdPOIHierarchyLevel1 [sys].[int] = NULL
	,@IdPOIHierarchyLevel2 [sys].[int] = NULL
	,@IdProductCategories [sys].[varchar](max) = NULL 
	,@IdProductBrand [sys].[varchar](max) = NULL
	,@IdCompany [sys].[varchar](max) = NULL 
	,@IdUser [sys].INT = NULL
)
AS
BEGIN
	SELECT  SOS.[Id], SOS.[IdProductCategory], SOS.[ProductCategoryName]
	FROM dbo.[GetShareOfShelfObjectives](
			@IdProductCategories, 
			IIF(@IdZone IS NULL, NULL, CONCAT(',', @IdZone, ',')), 
			IIF(@IdPOIHierarchyLevel1 IS NULL, NULL, CONCAT(',', @IdPOIHierarchyLevel1, ',')),
			IIF(@IdPOIHierarchyLevel2 IS NULL, NULL, CONCAT(',', @IdPOIHierarchyLevel2, ',')),
			@IdProductBrand, @IdCompany, @IdUser) AS SOS
	GROUP BY SOS.[Id], SOS.[IdProductCategory], SOS.[ProductCategoryName]
	ORDER BY SOS.[ProductCategoryName] asc
END
