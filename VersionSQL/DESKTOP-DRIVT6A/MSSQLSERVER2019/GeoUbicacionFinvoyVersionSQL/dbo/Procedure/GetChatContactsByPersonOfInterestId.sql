/****** Object:  Procedure [dbo].[GetChatContactsByPersonOfInterestId]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 05/03/2018
-- Description:	SP para obtener los contactos de chat excepto el recibido por parámetros.
-- =============================================
CREATE PROCEDURE [dbo].[GetChatContactsByPersonOfInterestId]
(
	@IdPersonOfInterest [sys].[int]
)
AS
BEGIN
	SELECT	[Id], [UserId], [DisplayName], [ImageLink]
	FROM	[dbo].[ChatUser] WITH (NOLOCK)
	WHERE	([IdPersonOfInterest] IS NULL OR [IdPersonOfInterest] <> @IdPersonOfInterest)
			AND [Deleted] = 0
END
