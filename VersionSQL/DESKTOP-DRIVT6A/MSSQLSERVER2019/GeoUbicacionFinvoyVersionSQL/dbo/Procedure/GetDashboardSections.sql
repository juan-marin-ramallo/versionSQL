/****** Object:  Procedure [dbo].[GetDashboardSections]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		FS
-- Create date: 21/10/19
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetDashboardSections]
AS
BEGIN
	SET NOCOUNT ON;

    SELECT D.[Id], D.[Name], D.[Description], D.[ImageName], D.[IdPermission], D.[PartialView]
	FROM dbo.[DashboardSectionTranslated] D WITH (NOLOCK)
	ORDER BY D.[Name] ASC
END
