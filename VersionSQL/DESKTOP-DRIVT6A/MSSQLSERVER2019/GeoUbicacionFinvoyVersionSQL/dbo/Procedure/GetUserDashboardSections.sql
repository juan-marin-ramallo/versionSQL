/****** Object:  Procedure [dbo].[GetUserDashboardSections]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		FS
-- Create date: 21/10/19
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetUserDashboardSections]
	@IdUser [sys].[int]
AS
BEGIN
	SET NOCOUNT ON;

    SELECT D.[Id] AS IdDashboardSection, D.[Name], D.[Description], D.[IdPermission], D.[PartialView], Ud.Id, UD.Size, UD.Position, UD.IdDateRange, DR.[DatePart], DR.[Number], DR.FromBeginning, DR.[ToEnd]
	FROM dbo.[UserDashboardSection] UD WITH(NOLOCK)
		INNER JOIN dbo.[DashboardSectionTranslated] D WITH (NOLOCK) ON UD.IdDashboardSection = D.Id
		INNER JOIN dbo.[DateRange] DR WITH(NOLOCK) ON UD.IdDateRange = DR.Id
		LEFT OUTER JOIN dbo.[UserPermission] UP WITH (NOLOCK) ON UD.IdUser = UP.IdUser AND D.IdPermission = UP.IdPermission
	WHERE UD.IdUser = @IdUser AND
		(D.IdPermission IS NULL OR UP.IdPermission IS NOT NULL)
	ORDER BY UD.[Position] ASC
END
