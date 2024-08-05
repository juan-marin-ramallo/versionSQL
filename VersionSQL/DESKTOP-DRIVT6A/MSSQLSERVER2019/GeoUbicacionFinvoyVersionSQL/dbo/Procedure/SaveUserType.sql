/****** Object:  Procedure [dbo].[SaveUserType]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 13/07/2017
-- Description:	SP para agregar un tipo de usuario
-- =============================================
CREATE PROCEDURE [dbo].[SaveUserType]
(
	 @Description [sys].[varchar](100),
	 @Id [sys].[int] OUTPUT
)
AS
BEGIN

	SET @Id  = 0

	INSERT INTO [dbo].[UserType]([Description])
	VALUES (@Description)

	SET @Id = SCOPE_IDENTITY()

END
