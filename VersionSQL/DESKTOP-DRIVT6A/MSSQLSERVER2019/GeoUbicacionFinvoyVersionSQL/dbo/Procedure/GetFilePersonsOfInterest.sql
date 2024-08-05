/****** Object:  Procedure [dbo].[GetFilePersonsOfInterest]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 04/09/2015
-- Description:	SP para obtener las personas de interés de un archivo
-- =============================================
CREATE PROCEDURE [dbo].[GetFilePersonsOfInterest]
(
	@IdFile [sys].[int]
)
AS
BEGIN
	SELECT		FP.[IdFile],FP.[IdPersonOfInterest]
	FROM		[dbo].[FilePersonOfInterest] FP WITH (NOLOCK)
				INNER JOIN dbo.PersonOfInterest P WITH (NOLOCK) ON FP.IdPersonOfInterest = P.Id
	WHERE		FP.[IdFile] = @IdFile AND p.Deleted = 'False'
END
