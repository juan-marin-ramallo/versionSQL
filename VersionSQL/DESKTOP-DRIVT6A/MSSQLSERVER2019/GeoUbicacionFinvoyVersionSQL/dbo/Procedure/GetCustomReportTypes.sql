/****** Object:  Procedure [dbo].[GetCustomReportTypes]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetCustomReportTypes]
(
	@IdUser [sys].[int] = NULL
)
AS
BEGIN
	
	SELECT CRT.[Id] AS IdType, CRT.[Name] AS TypeName
	
	FROM CustomReportTypeTranslated CRT WITH (NOLOCK)
	LEFT JOIN [dbo].[PermissionTranslated] P WITH (NOLOCK) ON P.[Id] = CRT.[IdPermission]
	
	WHERE CRT.[Enabled] = 1 
	AND (CRT.[IdPermission] IS NULL OR EXISTS (SELECT 1 FROM [dbo].[UserPermission] UP WHERE UP.[IdUser] = @IdUser AND UP.[IdPermission] = P.[Id]))
	ORDER BY CRT.[Order]

END
