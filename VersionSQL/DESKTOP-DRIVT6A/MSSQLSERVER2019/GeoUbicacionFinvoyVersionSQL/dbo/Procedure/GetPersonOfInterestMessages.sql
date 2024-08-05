/****** Object:  Procedure [dbo].[GetPersonOfInterestMessages]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Juan Sobral
-- Create date: 12/03/2014
-- Description:	SP para obtener los mensajes y marcarlos como enviados
-- =============================================
CREATE PROCEDURE [dbo].[GetPersonOfInterestMessages]
(
	 @IdPersonOfInterest [sys].[int],
	 @LastModifiedDate [sys].[datetime] = NULL
)
AS
BEGIN
	SELECT		M.[Id],  M.[TheoricalSentDate] AS Date, M.[Importance], M.[Subject], M.[Message], 
				M.[IdUser], U.[Name] AS UserName,
				U.[LastName] AS UserLastName, M.[ModifiedDate], M.[Deleted], M.[AllowReply]
	
	FROM		[dbo].[Message] M
				INNER JOIN [dbo].[User] U ON U.[Id] = M.[IdUser]
				INNER JOIN [dbo].[MessagePersonOfInterest] MPI ON MPI.[IdMessage] = M.[Id]
	
	WHERE		((@LastModifiedDate IS NULL) OR (M.[Date] >= @LastModifiedDate) 
				OR (M.TheoricalSentDate IS NOT NULL AND M.TheoricalSentDate >= @LastModifiedDate) 
				OR (M.ModifiedDate IS NOT NULL AND M.ModifiedDate >= @LastModifiedDate))
				AND  MPI.[IdPersonOfInterest] = @IdPersonOfInterest
	
	ORDER BY	[Date] DESC

	UPDATE [dbo].[MessagePersonOfInterest]
		SET [Received] = 1
			,[ReceivedDate] = GETUTCDATE()
		WHERE [IdPersonOfInterest]=  @IdPersonOfInterest AND [Received] = 0
		AND (SELECT COUNT (1)
			FROM [dbo].[Message] M
			WHERE [IdMessage] = M.[Id]
			AND((@LastModifiedDate IS NULL) OR (M.[Date] >= @LastModifiedDate) 
				OR (M.TheoricalSentDate IS NOT NULL AND M.TheoricalSentDate >= @LastModifiedDate) 
				OR (M.ModifiedDate IS NOT NULL AND M.ModifiedDate >= @LastModifiedDate)))>0
END
