/****** Object:  Procedure [dbo].[UpdateFile]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 01/09/2015
-- Description:	SP para guardar un mensaje
-- =============================================
CREATE PROCEDURE [dbo].[UpdateFile]
(
	 @IdFile [sys].[INT] = NULL
	 ,@Title [sys].[varchar](500) = NULL
	,@IdPersonsOfInterest [sys].[varchar](MAX) = NULL
)
AS
BEGIN

	UPDATE dbo.[File] 
	SET Title = @Title
	WHERE Id = @IdFile 
	
	INSERT INTO [dbo].[FilePersonOfInterest]([IdFile], [IdPersonOfInterest], [Received], [Read])
	(SELECT @IdFile AS IdFile, S.[Id] AS IdPersonOfInterest, 0 AS Received, 0 AS [Read]
	 FROM	[dbo].[PersonOfInterest] S
	 WHERE	dbo.CheckValueInList(S.[Id], @IdPersonsOfInterest) = 1 AND S.Id NOT IN (SELECT IdPersonOfInterest FROM dbo.FilePersonOfInterest
																						WHERE IdFile = @IdFile)
	)

	DELETE FROM dbo.FilePersonOfInterest 
	WHERE dbo.CheckValueInList([IdPersonOfInterest], @IdPersonsOfInterest) = 0 AND [IdFile] = @IdFile AND IdPersonOfInterest IN (SELECT IdPersonOfInterest FROM dbo.FilePersonOfInterest
																						WHERE IdFile = @IdFile)

END
