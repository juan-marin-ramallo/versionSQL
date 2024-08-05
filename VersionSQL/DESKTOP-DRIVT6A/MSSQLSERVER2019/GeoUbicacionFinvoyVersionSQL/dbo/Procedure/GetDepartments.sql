/****** Object:  Procedure [dbo].[GetDepartments]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 19/10/2012
-- Description:	SP para obtener los departamentos
-- =============================================
CREATE PROCEDURE [dbo].[GetDepartments]
(
	@IdUser [sys].[int] = NULL
)
AS
BEGIN
	SELECT		[Id], [Name], [Latitude], [Longitude]
	FROM		[dbo].[Department]
	WHERE		@IdUser IS NULL OR dbo.CheckDepartmentInUserDepartments([Id], @IdUser) = 1
	ORDER BY	[Name]
END
