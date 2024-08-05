/****** Object:  Procedure [dbo].[UpdateProductReportConfiguration]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<John Doe>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UpdateProductReportConfiguration]
	 @Id [sys].[int]
	,@ShowInProductReport [sys].[bit]
AS
BEGIN

	UPDATE [dbo].[ProductReportConfiguration]
	SET [ShowInProductReport] = @ShowInProductReport
	WHERE [Id] = @Id
	
	SELECT @Id

END
