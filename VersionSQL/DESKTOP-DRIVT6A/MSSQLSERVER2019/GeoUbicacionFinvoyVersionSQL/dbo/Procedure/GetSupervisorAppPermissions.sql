/****** Object:  Procedure [dbo].[GetSupervisorAppPermissions]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetSupervisorAppPermissions]
AS
BEGIN
	
	SELECT [Id], [Description]
	FROM [dbo].[SupervisorAppPermission]
	WHERE [Enabled] = 1
	ORDER BY [Order] ASC

END
