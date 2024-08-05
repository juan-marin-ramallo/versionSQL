/****** Object:  Procedure [dbo].[GetUnreadMessages]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 06/02/2013
-- Description:	SP para obtener los mensajes sin leer de un reponedor
-- =============================================
CREATE PROCEDURE [dbo].[GetUnreadMessages]
(
	@IdPersonOfInterest [sys].[int]
)
AS
BEGIN
	SELECT		M.[Id], M.[Date], M.[Importance], M.[Subject], M.[Message], M.[IdUser], U.[Name] AS UserName, U.[LastName] AS UserLastName
	FROM		[dbo].[MessagePersonOfInterest] MS
				INNER JOIN [dbo].[PersonOfInterest] S ON S.[Id] = MS.[IdPersonOfInterest]
				INNER JOIN [dbo].[Message] M ON M.[Id] = MS.[IdMessage]
				INNER JOIN [dbo].[User] U ON U.[Id] = M.[IdUser]
	WHERE		MS.[IdPersonOfInterest] = @IdPersonOfInterest AND
				MS.[Received] = 0
	GROUP BY	M.[Id], M.[Date], M.[Importance], M.[Subject], M.[Message], M.[IdUser], U.[Name], U.[LastName]
	ORDER BY	[Date]
END
