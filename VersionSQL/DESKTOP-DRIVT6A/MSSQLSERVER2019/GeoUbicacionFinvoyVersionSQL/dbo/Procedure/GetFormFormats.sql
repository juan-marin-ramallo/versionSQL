/****** Object:  Procedure [dbo].[GetFormFormats]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Gaston Legnani
-- Create date: 20/07/2017
-- Description:	SP para obtener los formatos para exportar excel
-- =============================================
CREATE PROCEDURE [dbo].[GetFormFormats]
AS
BEGIN
	SELECT	[Id], [Name]
	FROM	[dbo].[FormReportFormatElementTranslated] WITH (NOLOCK)
END
