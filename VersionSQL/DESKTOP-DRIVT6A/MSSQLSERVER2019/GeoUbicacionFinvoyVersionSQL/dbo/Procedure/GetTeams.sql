/****** Object:  Procedure [dbo].[GetTeams]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 25/10/2012
-- Description:	SP para obtener los equipos
-- =============================================
CREATE PROCEDURE [dbo].[GetTeams]
AS
BEGIN
	SELECT		[Id], [Description]
	FROM		[dbo].[Team]
	ORDER BY	[Description]
END
