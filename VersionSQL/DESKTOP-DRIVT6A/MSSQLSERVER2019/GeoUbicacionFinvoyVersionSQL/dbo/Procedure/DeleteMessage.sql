/****** Object:  Procedure [dbo].[DeleteMessage]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 09/11/2015
-- Description:	SP para eliminar un aviso
-- =============================================
CREATE PROCEDURE [dbo].[DeleteMessage]
(
	 @IdMessage [sys].[int]
)
AS
BEGIN
	
	UPDATE	[dbo].[Message]
	SET ModifiedDate = GETUTCDATE(), Deleted = 1
	WHERE		[Id] = @IdMessage
END
