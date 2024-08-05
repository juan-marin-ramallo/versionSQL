/****** Object:  Procedure [dbo].[GetChatContactsByUserId]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 01/03/2018
-- Description:	SP para obtener los contactos de chat excepto el recibido por parámetros.
-- =============================================
CREATE PROCEDURE [dbo].[GetChatContactsByUserId]
(
	@IdUser [sys].[int]
)
AS
BEGIN
	SELECT	[Id], [UserId], [DisplayName], [ImageLink], [IdPersonOfInterest]
	FROM	[dbo].[ChatUser] WITH (NOLOCK)
	WHERE	([IdUser] IS NULL OR [IdUser] <> @IdUser)
			AND [Deleted] = 0
END
