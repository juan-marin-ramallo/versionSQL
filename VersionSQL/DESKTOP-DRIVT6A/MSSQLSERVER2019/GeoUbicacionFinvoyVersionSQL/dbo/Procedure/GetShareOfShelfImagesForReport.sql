/****** Object:  Procedure [dbo].[GetShareOfShelfImagesForReport]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 09/09/2021
-- Description:	SP para obtener el reporte de
--				Share of Shelf junto a sus
--				imágenes y presentar en reporte
-- =============================================
CREATE PROCEDURE [dbo].[GetShareOfShelfImagesForReport]
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

	SELECT		SOS.[Id], SOS.[Date],
				SOS.PointOfInterestId, SOS.PointOfInterestName, SOS.PointOfInterestIdentifier,
				SOS.PersonOfInterestId, SOS.PersonOfInterestName, SOS.PersonOfInterestLastName, SOS.PersonOfInterestIdentifier,
				SOS.[IsManual], SOS.[ValidationImage],
				SI.Id AS [ImageId], SI.ImageUrl, SI.ImageName
	FROM		[dbo].[GetShareOfShelfReport](@DateFrom, @DateTo, @IdProductCategorySOS, @IdProduct, @IdProductCategories, @IdProductBrand, @IdCompany, @IdPointOfInterest, @IdPersonOfInterest, @IsManual, @IdUser) AS SOS
					INNER JOIN [dbo].[ShareOfShelfImage] SI ON SOS.Id = SI.IdShareOfShelf
	GROUP BY	SOS.[Id], SOS.[Date],
				SOS.PointOfInterestId, SOS.PointOfInterestName, SOS.PointOfInterestIdentifier,
				SOS.PersonOfInterestId, SOS.PersonOfInterestName, SOS.PersonOfInterestLastName, SOS.PersonOfInterestIdentifier,
				SOS.[IsManual], SOS.[ValidationImage],
				SI.Id, SI.ImageUrl, SI.ImageName
	ORDER BY	SOS.Date ASC, SOS.PointOfInterestIdentifier ASC, SOS.PointOfInterestName ASC, SOS.[Id] ASC, SI.Id ASC
END
