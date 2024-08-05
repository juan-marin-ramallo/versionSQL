/****** Object:  Procedure [dbo].[DeletePromotionPointOfInterest]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 25/07/2016
-- Description:	SP para eliminar una promoción comercial de un punto de interés
-- =============================================
CREATE PROCEDURE [dbo].[DeletePromotionPointOfInterest](
	@IdPromotion [sys].[int]
   ,@IdPointOfInterest [sys].[int]
)
AS 
BEGIN
	DELETE FROM [dbo].[PromotionPointOfInterest]
	WHERE [IdPromotion] = @IdPromotion AND [IdPointOfInterest] = @IdPointOfInterest
END
