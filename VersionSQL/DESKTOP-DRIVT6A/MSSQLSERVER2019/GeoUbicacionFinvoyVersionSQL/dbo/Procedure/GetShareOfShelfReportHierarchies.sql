/****** Object:  Procedure [dbo].[GetShareOfShelfReportHierarchies]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 27/03/2019
-- Description:	SP para obtener el reporte Share of shelf
-- =============================================
CREATE PROCEDURE [dbo].[GetShareOfShelfReportHierarchies]
(
	 @DateFrom [sys].[datetime]
	,@DateTo [sys].[datetime]
	,@IdProductCategorySOS [sys].[int]
	,@IdProduct [sys].[varchar](max) = NULL
	,@IdProductCategories [sys].[varchar](max) = NULL
	,@IdProductBrand [sys].[varchar](max) = NULL
	,@IdCompany [sys].[varchar](max) = NULL	
	,@IdPointOfInterest [sys].[varchar](max) = NULL
	,@IdPersonOfInterest [sys].[varchar](max) = NULL
	,@IsManual [sys].[bit] = NULL
	,@IdUser [sys].INT = NULL
)
AS
BEGIN
	SELECT SOS.[Id], H.Id AS [HierarchyId], H.[Name] AS [HierarchyName]
	FROM dbo.[GetShareOfShelfReport](@DateFrom,@DateTo,@IdProductCategorySOS,@IdProduct,@IdProductCategories,@IdProductBrand,@IdCompany,@IdPointOfInterest,@IdPersonOfInterest,@IsManual,@IdUser) AS SOS
		INNER JOIN dbo.[ShareOfShelfProductCategory] SOSH ON SOS.Id = SOSH.IdShareOfShelf
		INNER JOIN dbo.[ProductCategory] H ON SOSH.IdProductCategory = H.Id
	GROUP BY SOS.[Id], SOS.[Date], H.Id, H.[Name]
	ORDER BY	SOS.[Date] ASC, SOS.[Id] DESC, H.Id ASC
END
