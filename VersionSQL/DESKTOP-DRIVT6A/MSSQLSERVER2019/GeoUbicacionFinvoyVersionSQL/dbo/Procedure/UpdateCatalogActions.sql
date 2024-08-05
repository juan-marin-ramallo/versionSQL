/****** Object:  Procedure [dbo].[UpdateCatalogActions]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UpdateCatalogActions]
	 @IdCatalog [int],
	 @IdActions [varchar](max) = NULL
AS
BEGIN

	DELETE FROM [dbo].[CatalogPersonOfInterestPermission]
	WHERE [IdCatalog] = @IdCatalog AND (@IdActions IS NULL OR dbo.CheckValueInList(IdPersonOfInterestPermission, @IdActions) = 0)

	INSERT INTO [dbo].[CatalogPersonOfInterestPermission]([IdCatalog], [IdPersonOfInterestPermission])
	SELECT  @IdCatalog AS IdCatalog, P.[Id] AS IdPersonOfInterestPermission
	FROM	dbo.[PersonOfInterestPermission] P
		LEFT OUTER JOIN dbo.[CatalogPersonOfInterestPermission] CP ON P.Id = CP.IdPersonOfInterestPermission AND CP.IdCatalog = @IdCatalog
	WHERE   CP.Id IS NULL AND (dbo.CheckValueInList(P.[Id], @IdActions) = 1)

END
