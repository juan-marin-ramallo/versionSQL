/****** Object:  Procedure [dbo].[GetShareOfShelfReportImages]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 27/03/2019
-- Description:	SP para obtener el reporte Share of shelf
-- =============================================
CREATE PROCEDURE [dbo].[GetShareOfShelfReportImages]
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
	SELECT SOS.[Id], SI. Id AS [ImageId], SI.ImageUrl, SI.ImageName
	FROM dbo.[GetShareOfShelfReport](@DateFrom,@DateTo,@IdProductCategorySOS,@IdProduct,@IdProductCategories,@IdProductBrand,@IdCompany,@IdPointOfInterest,@IdPersonOfInterest,@IsManual,@IdUser) AS SOS
		INNER JOIN dbo.ShareOfShelfImage SI ON SOS.Id = SI.IdShareOfShelf
	GROUP BY SOS.[Id], SOS.[Date], SI. Id, SI.ImageUrl, SI.ImageName
	ORDER BY	SOS.[Date] DESC, SOS.[Id] DESC, SI.Id ASC
END
