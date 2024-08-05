/****** Object:  Procedure [dbo].[GetAllFormatFormReport]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		gl
-- Create date: 20/07/2017
-- Description:	SP para obtener los formatos de exportación del reporte de tareas (excel)
-- =============================================
CREATE PROCEDURE [dbo].[GetAllFormatFormReport]
(
	@FormatId [sys].[int] = NULL
)
AS
BEGIN
	SELECT		FRF.[Name] AS NameFormat, FRF.[Id] AS IdFormatElement,
				FRFO.[IdCustomAttribute] AS IdCustomAttribute, FRFO.[Id] AS IdFormatOption, FRFO.[Name] AS NameFormatOption
	
	FROM		[dbo].[FormReportFormatElementTranslated] FRF WITH (NOLOCK)
				INNER JOIN [dbo].[FormReportFormatElementOptions] FRFE WITH (NOLOCK) ON FRF.[Id] = FRFE.[IdFormatElement]
				INNER JOIN [dbo].[FormReportFormatOptionsTranslated] FRFO WITH (NOLOCK) ON FRFE.[IdFormatOptions] = FRFO.[Id]
	
	WHERE		((@FormatId IS NULL) OR (FRF.[Id] = @FormatId)) AND
				FRFO.[Deleted] = 0
	
	ORDER BY	FRF.[Id], FRFE.[IdFormatOptions]
END
