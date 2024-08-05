/****** Object:  Procedure [dbo].[DeleteForm]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Diego Cáceres
-- Create date: 08/10/2014
-- Description:	SP para eliminar un formulario
-- =============================================
CREATE PROCEDURE [dbo].[DeleteForm] 
	@Id [sys].[int]
AS
BEGIN
	UPDATE	[dbo].[Form]
	SET		[Deleted] = 1, [DeletedDate] = GETUTCDATE()
	WHERE	[Id] = @Id
END
