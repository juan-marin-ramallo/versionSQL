/****** Object:  Procedure [dbo].[GetExcelFormatFormReportById]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 27/07/2017
-- Description:	SP para obtener los formatos de excels para las tareas
-- =============================================
CREATE PROCEDURE [dbo].[GetExcelFormatFormReportById]	
	 @IdFormat [sys].[int]
AS
BEGIN

	SELECT f.[Id], f.[Name]  as FormatFormReportName
			, e.[Id] as IdFormatOption, e.[Name] as FormatOptionName, e.IdCustomAttribute

	FROM	[dbo].[FormReportFormatElementTranslated] f WITH (NOLOCK)
			INNER JOIN [dbo].[FormReportFormatElementOptions] fe WITH (NOLOCK) on f.[Id] = fe.IdFormatElement
			INNER JOIN [dbo].[FormReportFormatOptionsTranslated] e WITH (NOLOCK) ON fe.IdFormatOptions = e.[Id]

	WHERE f.[Id] = @IdFormat and e.Deleted = 0
	ORDER BY f.[Id], e.[Id]
	
END
