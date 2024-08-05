/****** Object:  Procedure [dbo].[DeletePowerpointMarkupsFormReport]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 08/06/2017
-- Description:	SP para eliminar un formato powerpoint para el form report
-- =============================================
CREATE PROCEDURE [dbo].[DeletePowerpointMarkupsFormReport]	
	 @IdMarkup [sys].[int]
AS
BEGIN

	DELETE e
	FROM [dbo].[PowerpointMarkupFormReportElement] e
			INNER JOIN [dbo].[PowerpointMarkupFormReport] f ON f.Id = e.IdPowerpointMarkupFormReport
	WHERE f.Id = @IdMarkup
	
	DELETE [dbo].[PowerpointMarkupFormReport]
	WHERE Id = @IdMarkup	
END
