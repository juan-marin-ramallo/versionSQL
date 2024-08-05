/****** Object:  Procedure [dbo].[GetPersonOfInterestFiles]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 28/09/2015
-- Description:	SP para obtener los archivos y marcarlos como recibidos
-- =============================================
CREATE PROCEDURE [dbo].[GetPersonOfInterestFiles]
(
	 @IdPersonOfInterest [sys].[int],
	 @LastModifiedDate [sys].[datetime] = NULL
)
AS
BEGIN
	SELECT		FPI.[Id],  F.[Date] AS Date, F.[FileName] AS Name, F.[Url], F.[IdUser], U.[Name] AS UserName,
				U.[LastName] AS UserLastName, F.[Deleted], F.[Title]
	FROM		[dbo].[File] F
				INNER JOIN [dbo].[User] U ON U.[Id] = F.[IdUser]
				INNER JOIN [dbo].[FilePersonOfInterest] FPI ON FPI.[IdFile] = F.[Id]
	WHERE		((@LastModifiedDate IS NULL) OR (F.[Date] >= @LastModifiedDate))
				AND  FPI.[IdPersonOfInterest] = @IdPersonOfInterest
	ORDER BY	[Date] DESC

	UPDATE [dbo].[FilePersonOfInterest]
		SET [Received] = 1
			,[ReceivedDate] = GETUTCDATE()
		WHERE [IdPersonOfInterest]=  @IdPersonOfInterest and [Received] = 0
		AND (SELECT COUNT (1)
			FROM [dbo].[File] F
			WHERE [IdFile] = F.[Id]
			AND ((@LastModifiedDate IS NULL) OR (F.[Date] >= @LastModifiedDate)))>0
END
