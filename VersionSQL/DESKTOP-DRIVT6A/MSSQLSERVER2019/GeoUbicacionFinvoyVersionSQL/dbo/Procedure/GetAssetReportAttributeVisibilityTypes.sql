/****** Object:  Procedure [dbo].[GetAssetReportAttributeVisibilityTypes]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 11/02/2022
-- Description:	Devuelve los tipos de visibilidad
--				disponibles para los atributos
--				en reporte de activos
-- =============================================
CREATE PROCEDURE [dbo].[GetAssetReportAttributeVisibilityTypes]
AS
BEGIN
	SELECT	[Id], [Description]
	FROM	[dbo].[AssetReportAttributeVisibilityTypeTranslated] WITH (NOLOCK)
END
