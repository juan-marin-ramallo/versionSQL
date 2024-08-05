/****** Object:  Procedure [dbo].[GetAutomaticReportTypes]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: <Create Date,,>
-- Description:	DEVUELVE TIPOS DE REPORTES PARA ENVIO AUTOAMTICO
-- =============================================
CREATE PROCEDURE [dbo].[GetAutomaticReportTypes]
AS
BEGIN
	
	SELECT SRT.[Id] AS IdType, [Name] AS TypeName, AFT.[Id] AS FileFormatId, AFT.[FileType] AS FileFormatName
	FROM [dbo].[ScheduleReportTypeTranslated] SRT
	INNER JOIN [dbo].[ScheduleReportTypeFile] SRTF ON SRTF.IdScheduleReportType = SRT.Id
	INNER JOIN [dbo].[AvailableFileTypeTranslated] AFT ON AFT.Id = SRTF.IdFileType
	WHERE [Enabled] = 1
	ORDER BY [Order], IdType

END
