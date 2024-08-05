/****** Object:  Procedure [dbo].[GetConfigurationsFiltered]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 10/01/2013
-- Description:	SP para obtener las configuraciones cuyo id se encuentren en la lista pasada por parámetros
-- =============================================
CREATE PROCEDURE [dbo].[GetConfigurationsFiltered]
(
	@Ids [sys].[varchar](200) = NULL
)
AS
BEGIN
	SELECT	[Id], [Name], [Description], [HelpMessage], [Value], [Visible]
	FROM	[dbo].[ConfigurationTranslated] WITH (NOLOCK)
	WHERE	((@Ids IS NULL) OR (dbo.CheckValueInList([Id], @Ids) = 1))
END
