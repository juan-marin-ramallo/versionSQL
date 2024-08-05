/****** Object:  Procedure [dbo].[MarkMessageAsRead]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Juan Sobral
-- Create date: 12/03/2014
-- Description:	SP para marcar un mensaje como leido
-- =============================================
CREATE PROCEDURE [dbo].[MarkMessageAsRead]
(
	 @IdPersonOfInterest [sys].[int],
	 @MessageId [sys].[int],
	 @ReadDate [sys].[datetime] = NULL,
	 @UpdatedRows [sys].[int] OUT
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

	UPDATE	[dbo].[MessagePersonOfInterest]
	SET		[Read] = 1,
			[ReadDate] = @ReadDateAux
	WHERE	[IdMessage]= @MessageId
			AND [IdPersonOfInterest] = @IdPersonOfInterest

	SET @UpdatedRows = @@ROWCOUNT
END
