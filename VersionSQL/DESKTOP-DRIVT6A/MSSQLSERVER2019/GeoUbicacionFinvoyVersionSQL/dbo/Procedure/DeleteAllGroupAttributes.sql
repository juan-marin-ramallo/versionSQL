/****** Object:  Procedure [dbo].[DeleteAllGroupAttributes]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[DeleteAllGroupAttributes]
	 @IdCustomAttributeGroup [sys].[int]
AS
BEGIN

	DELETE FROM [dbo].[CustomAttributeGroupCustomAttribute]
	WHERE		[IdCustomAttributeGroup] = @IdCustomAttributeGroup

END
