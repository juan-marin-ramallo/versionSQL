/****** Object:  Procedure [dbo].[GetAssetImage]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetAssetImage]
	@Id [sys].[int]
AS
BEGIN

	SELECT	[ImageArray]
	FROM	dbo.Asset
	WHERE	[Id] = @Id
END
