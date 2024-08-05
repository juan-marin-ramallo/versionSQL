/****** Object:  Procedure [dbo].[GetTotalFileSize]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Gaston Legnani
-- Create date: 30/09/2015
-- Description:	SP para obtener tamaño total de los archivos subidos
-- =============================================
CREATE PROCEDURE [dbo].[GetTotalFileSize]

AS
BEGIN
	SELECT		SUM(F.[Size]) AS TotalSize
	FROM		[dbo].[File] F
	WHERE		F.[Deleted] = 0
END
