/****** Object:  Procedure [dbo].[DeleteFile]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 01/09/2015
-- Description:	SP para eliminar un archivo
-- =============================================
create PROCEDURE [dbo].[DeleteFile]
(
	 @IdFile [sys].[INT] = NULL
)
AS
BEGIN

	UPDATE dbo.[File] 
	SET Deleted = 'True'
	WHERE Id = @IdFile 
	
	

END
