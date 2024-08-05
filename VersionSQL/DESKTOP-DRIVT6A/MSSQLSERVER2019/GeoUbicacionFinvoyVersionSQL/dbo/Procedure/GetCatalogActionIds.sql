/****** Object:  Procedure [dbo].[GetCatalogActionIds]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetCatalogActionIds]
	@IdCatalog [int]
AS
BEGIN
	
	SELECT CP.[IdPersonOfInterestPermission] as Id, P.[Description]
	FROM CatalogPersonOfInterestPermission CP 
	join PersonOfInterestPermission P on P.Id = CP.[IdPersonOfInterestPermission]
	WHERE CP.[IdCatalog] = @IdCatalog

END
