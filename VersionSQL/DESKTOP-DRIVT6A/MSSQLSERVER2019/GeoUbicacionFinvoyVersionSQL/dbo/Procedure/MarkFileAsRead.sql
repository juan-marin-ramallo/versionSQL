/****** Object:  Procedure [dbo].[MarkFileAsRead]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 28/09/2014
-- Description:	SP para marcar un archivo como leido
-- =============================================
CREATE PROCEDURE [dbo].[MarkFileAsRead]
(
	 @IdPersonOfInterest [sys].[int],
	 @IdFile [sys].[int],
	 @ReadDate [sys].[datetime] = NULL
)
AS
BEGIN
	
	DECLARE @ReadDateAux [sys].[datetime]
	IF @ReadDate IS NOT NULL
	BEGIN
		SET @ReadDateAux = @ReadDate
	END
	ELSE
	BEGIN
		SET @ReadDateAux = GETUTCDATE()
	END


	UPDATE	[dbo].[FilePersonOfInterest]
	SET		[Read] = 1
			,[ReadDate] = @ReadDateAux
	WHERE	[Id] = @IdFile
			AND [IdPersonOfInterest] = @IdPersonOfInterest
END
