/****** Object:  Procedure [dbo].[UpdateUserType]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 13/07/2017
-- Description:	SP para ACTUALIZAR un tipo de usuario
-- =============================================
CREATE PROCEDURE [dbo].[UpdateUserType]
(
	 @Description [sys].[varchar](100),
	 @Id [sys].[int]
)
AS
BEGIN

	UPDATE	[dbo].[UserType]
	SET		[Description] = @Description
	WHERE	[Id] = @Id

END
