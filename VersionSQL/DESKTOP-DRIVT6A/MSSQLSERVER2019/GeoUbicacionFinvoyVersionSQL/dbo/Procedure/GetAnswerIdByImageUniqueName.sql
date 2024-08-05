/****** Object:  Procedure [dbo].[GetAnswerIdByImageUniqueName]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Diego Cáceres
-- Create date: 31/10/2014
-- Description:	SP para obtener el id de una respuesta imagen por su nombre
-- =============================================
CREATE PROCEDURE [dbo].[GetAnswerIdByImageUniqueName] 
	@ImageUniqueName [sys].[varchar] (100)
AS
BEGIN

	SELECT A.[Id] AS AnswerId
	FROM [dbo].[Answer] A WITH(NOLOCK)
	WHERE A.[ImageName] = @ImageUniqueName
END
