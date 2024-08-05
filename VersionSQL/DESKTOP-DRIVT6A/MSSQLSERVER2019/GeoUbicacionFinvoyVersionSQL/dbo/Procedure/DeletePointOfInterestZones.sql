/****** Object:  Procedure [dbo].[DeletePointOfInterestZones]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 15/08/2014
-- Description:	SP para eliminar las zonas de un punto de interés
-- =============================================
CREATE PROCEDURE [dbo].[DeletePointOfInterestZones]
(
	 @IdPointOfInterest [sys].[int]
)
AS
BEGIN
	DELETE FROM	[dbo].[PointOfInterestZone]
	WHERE		IdPointOfInterest = @IdPointOfInterest
END
