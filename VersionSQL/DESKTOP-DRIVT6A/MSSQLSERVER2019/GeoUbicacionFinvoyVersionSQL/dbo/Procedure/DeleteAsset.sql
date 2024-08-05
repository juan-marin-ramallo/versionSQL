/****** Object:  Procedure [dbo].[DeleteAsset]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[DeleteAsset]
	@Id [sys].[int]
AS 
BEGIN
    SET NOCOUNT ON;
    UPDATE	dbo.Asset
	SET		[Deleted] = 1
	WHERE	[Id] = @Id

	--DELETE FROM [dbo].[NotificationStockCounter]
	--WHERE [IdProduct] = @Id
END
