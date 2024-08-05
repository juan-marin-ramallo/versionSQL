/****** Object:  Procedure [dbo].[GetShareOfShelfRecomendedImageCount]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 22/11/2021
-- Description:	SP para obtener cantidad de imagenes recomendadas para toma de Share of shelf
-- =============================================
CREATE PROCEDURE [dbo].[GetShareOfShelfRecomendedImageCount]
(
	 @IdPointOfInterest [sys].[int]
	,@IdProductCategory [sys].[int]
)
AS
BEGIN
	SELECT TOP 1 gr2.ImageCount
	FROM (
		SELECT TOP 3 gr.ImageCount, COUNT(gr.Id) as Times
		FROM (
			SELECT s.IdPointOfInterest, p.IdProductCategory, s.Id, COUNT (i.id) as ImageCount
			FROM dbo.ShareOfShelfReport s
				INNER JOIN dbo.ShareOfShelfProductCategory p on s.Id = p.IdShareOfShelf
				INNER JOIN dbo.ShareOfShelfImage i on s.Id = i.IdShareOfShelf
			where s.IdPointOfInterest = @IdPointOfInterest AND p.IdProductCategory = @IdProductCategory
			GROUP BY s.IdPointOfInterest, p.IdProductCategory, s.Id
			HAVING COUNT(i.id) > 0
		) AS gr
		GROUP BY gr.ImageCount
		ORDER BY gr.ImageCount desc
	) as gr2
	ORDER BY gr2.Times DESC, gr2.ImageCount desc
END
