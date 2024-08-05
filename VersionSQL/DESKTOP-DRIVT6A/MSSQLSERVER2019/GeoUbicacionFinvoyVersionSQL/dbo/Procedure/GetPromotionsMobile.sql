/****** Object:  Procedure [dbo].[GetPromotionsMobile]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Gaston Legnani
-- Create date: 27/07/2016
-- Description:	SP para obtener las promociones por punto usadas en los servicios mobile
-- =============================================
CREATE PROCEDURE [dbo].[GetPromotionsMobile]
	@IdPointOfInterest [sys].[int]
AS
BEGIN
	
	SELECT		PRO.[Id], PRO.[Name],PRO.[StartDate], PRO.[EndDate], PRO.[Description], PRO.[FileName], PRO.[Deleted], PRO.MD5Checksum
	
	FROM		[dbo].[Promotion] PRO
				INNER JOIN [dbo].[PromotionPointOfInterest] PP ON PRO.[Id] = PP.[IdPromotion] 
	
	WHERE		PP.[IdPointOfInterest] = @IdPointOfInterest
	
	GROUP BY	PRO.[Id], PRO.[Name],PRO.[StartDate], PRO.[EndDate], PRO.[Description], PRO.[FileName], PRO.[Deleted], PRO.MD5Checksum
	
	ORDER BY	PRO.[Id] DESC
END
