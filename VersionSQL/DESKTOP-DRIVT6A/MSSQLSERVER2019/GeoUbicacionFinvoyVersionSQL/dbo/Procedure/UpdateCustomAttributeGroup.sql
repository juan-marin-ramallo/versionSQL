/****** Object:  Procedure [dbo].[UpdateCustomAttributeGroup]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[UpdateCustomAttributeGroup]
	 @Id [sys].[int]
	,@Name [sys].[varchar](100)
AS
BEGIN

	UPDATE	[dbo].[CustomAttributeGroup]
	SET		[Name] = @Name 
	WHERE	[Id] = @Id

END
