/****** Object:  Procedure [dbo].[GetCatalogPointOfInterestIds]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetCatalogPointOfInterestIds]
	@IdCatalog [int]
AS
BEGIN
	
	SELECT Id
	FROM PointOfInterest P
	JOIN CatalogPointOfInterest CP ON CP.[IdPointOfInterest] = P.[Id]
	WHERE CP.[IdCatalog] = @IdCatalog

END
