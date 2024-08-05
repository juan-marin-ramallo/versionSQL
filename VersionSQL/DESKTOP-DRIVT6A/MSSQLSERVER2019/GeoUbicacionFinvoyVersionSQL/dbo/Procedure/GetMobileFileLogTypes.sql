/****** Object:  Procedure [dbo].[GetMobileFileLogTypes]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 03/12/2020
-- Description:	SP para obtener los tipos de archivos de log
-- =============================================
CREATE PROCEDURE [dbo].[GetMobileFileLogTypes]
AS
BEGIN
	SELECT	[Id], [Description]
	FROM	[dbo].[MobileFileLogTypeTranslated] WITH (NOLOCK)
END
