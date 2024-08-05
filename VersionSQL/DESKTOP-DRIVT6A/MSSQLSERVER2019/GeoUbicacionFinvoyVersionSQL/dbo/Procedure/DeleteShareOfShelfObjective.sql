/****** Object:  Procedure [dbo].[DeleteShareOfShelfObjective]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[DeleteShareOfShelfObjective]
	-- Add the parameters for the stored procedure here
	@Id [sys].[int] 
AS
BEGIN
	SET NOCOUNT ON;

    UPDATE [dbo].[ShareOfShelfObjective]
	SET [Deleted] = 1
	WHERE Id = @Id
END
