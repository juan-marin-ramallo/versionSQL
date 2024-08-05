/****** Object:  Procedure [dbo].[GetProductReportConfigurations]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetProductReportConfigurations]
AS
BEGIN
	
	SELECT [Id], [Name], [ShowInProductReport]
	FROM [dbo].[ProductReportConfigurationTranslated] WITH (NOLOCK)
	ORDER BY [Order] ASC

END
