/****** Object:  Procedure [dbo].[EnablePendingAsset]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[EnablePendingAsset]
	@Id int
AS
BEGIN
	
	UPDATE Asset
	SET [Pending] = 0
	WHERE [Id] = @Id

END
