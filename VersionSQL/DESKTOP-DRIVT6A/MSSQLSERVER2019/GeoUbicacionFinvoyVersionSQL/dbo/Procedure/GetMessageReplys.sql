/****** Object:  Procedure [dbo].[GetMessageReplys]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 30/01/2013
-- Description:	SP para obtener los mensajes
-- =============================================
CREATE PROCEDURE [dbo].[GetMessageReplys]
(
	 @IdMessage [int]
	 ,@IdPersonsOfInterest [varchar](max) = null
)
AS
BEGIN
	SELECT		M.[Id], M.[Date], M.[Message], P.[Id] as PersonId, P.[Name] as PersonName, P.[LastName] as PersonLastName		
	FROM		[dbo].[MessageReply] M
				INNER JOIN [dbo].[PersonOfInterest] P ON P.[Id] = M.[IdPersonOfInterest]
	WHERE		M.[IdMessage] = @IdMessage
				AND (@IdPersonsOfInterest IS NULL OR dbo.CheckValueInList(M.[IdPersonOfInterest], @IdPersonsOfInterest) = 1)	
	GROUP BY	M.[Id], M.[Date], M.[Message], P.[Id], P.[Name], P.[LastName]
	ORDER BY	M.[Date] DESC
END
