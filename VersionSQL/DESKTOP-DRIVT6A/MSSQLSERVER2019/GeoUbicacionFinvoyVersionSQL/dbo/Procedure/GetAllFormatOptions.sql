/****** Object:  Procedure [dbo].[GetAllFormatOptions]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 13/11/2017
-- Description:	SP para obtener todlas opciones disponibles
-- =============================================
CREATE PROCEDURE [dbo].[GetAllFormatOptions]

AS
BEGIN
	SELECT		FRF.[Id],FRF.[Name], FRF.[IdCustomAttribute], FRFO.[IdFormatElement]
	
	FROM		[dbo].[FormReportFormatOptionsTranslated] FRF WITH (NOLOCK)
				INNER JOIN [dbo].[FormReportFormatElementOptions] FRFO WITH (NOLOCK) ON FRFO.[IdFormatOptions] = FRF.[Id]
	
	WHERE		FRF.[Deleted] = 0
	
	ORDER BY	FRFO.[IdFormatElement], FRF.[Id]
END
