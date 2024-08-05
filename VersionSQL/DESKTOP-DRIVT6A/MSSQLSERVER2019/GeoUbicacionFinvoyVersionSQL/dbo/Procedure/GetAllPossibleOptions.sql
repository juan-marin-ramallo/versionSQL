/****** Object:  Procedure [dbo].[GetAllPossibleOptions]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		gl
-- Create date: 20/07/2017
-- Description:	SP para obtener LAS POSIBLES OPCIONES DE FORMATO
-- =============================================
CREATE PROCEDURE [dbo].[GetAllPossibleOptions]
(
	@FormatId [sys].[int] = NULL
)
AS
BEGIN
	SELECT		FRFO.[IdCustomAttribute] AS IdCustomAttribute, FRFO.[Id], FRFO.[Name]
	
	FROM		[dbo].[FormReportFormatOptionsTranslated] FRFO WITH (NOLOCK)
	
	WHERE		FRFO.[Deleted] = 0
	
	ORDER BY	FRFO.[Id]
END
