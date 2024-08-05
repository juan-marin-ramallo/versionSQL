/****** Object:  Procedure [dbo].[GetProductReportAttributeTypes]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetProductReportAttributeTypes]
AS
BEGIN

	SELECT [Id], [Description]
	FROM dbo.[ProductReportAttributeTypeTranslated] WITH (NOLOCK)
	ORDER BY [Order] ASC

END
