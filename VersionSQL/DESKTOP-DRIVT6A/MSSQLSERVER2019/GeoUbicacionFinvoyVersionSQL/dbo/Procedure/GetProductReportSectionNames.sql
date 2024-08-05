/****** Object:  Procedure [dbo].[GetProductReportSectionNames]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetProductReportSectionNames]
AS
BEGIN
	
	SELECT S.[Id], S.[Name]
	FROM [dbo].[ProductReportSection] AS S
	WHERE S.[FullDeleted] = 0

END
