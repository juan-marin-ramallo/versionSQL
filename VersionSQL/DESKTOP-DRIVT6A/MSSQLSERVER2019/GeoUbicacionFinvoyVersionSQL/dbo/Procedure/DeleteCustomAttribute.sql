/****** Object:  Procedure [dbo].[DeleteCustomAttribute]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<John Doe>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[DeleteCustomAttribute]
	@Id int
AS
BEGIN
	UPDATE CustomAttribute
	SET [Deleted] = 1
	WHERE [Id] = @Id

	UPDATE CustomAttributeOption
	SET [Deleted] = 1
	WHERE [IdCustomAttribute] = @Id
	
	UPDATE  [dbo].[FormReportFormatOptions]
	SET		[Deleted] = 1
	WHERE	[IdCustomAttribute] = @Id

	UPDATE  [dbo].[Field]
	SET		[Deleted] = 1
	WHERE	[IdCustomAttribute] = @Id

	DELETE FROM [dbo].[CustomAttributeGroupCustomAttribute]
	WHERE		[IdCustomAttribute] = @Id
END
