/****** Object:  Procedure [dbo].[GetConfigurationsPT]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Leo Repeto
-- Create date: 28/06/2014
-- Description:	SP para obtener las configuraciones
-- =============================================
CREATE PROCEDURE [dbo].[GetConfigurationsPT]
AS
BEGIN
	SELECT	[Id], [Name], [DescriptionPT], [Value], [Visible]
	FROM	[dbo].[ConfigurationTranslated] WITH (NOLOCK)

END
