/****** Object:  Procedure [dbo].[GetAllConfigurations]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 29/06/2015
-- Description:	SP para obtener todas las configuraciones para uso interno en procesos
-- =============================================
CREATE PROCEDURE [dbo].[GetAllConfigurations]
AS
BEGIN
	SELECT	[Id], [Name], [Description], [Value], [Visible]
	FROM	[dbo].[ConfigurationTranslated] WITH (NOLOCK)
END
