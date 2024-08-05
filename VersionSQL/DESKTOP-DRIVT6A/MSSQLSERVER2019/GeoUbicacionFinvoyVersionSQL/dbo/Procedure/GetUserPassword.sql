/****** Object:  Procedure [dbo].[GetUserPassword]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetUserPassword]
	@Id int
AS
BEGIN
	
	SELECT [Password]
	FROM [dbo].[User]
	WHERE [Id] = @Id

END
