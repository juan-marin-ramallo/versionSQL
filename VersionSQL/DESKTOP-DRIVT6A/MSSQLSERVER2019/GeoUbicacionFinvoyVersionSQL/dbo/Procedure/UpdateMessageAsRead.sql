/****** Object:  Procedure [dbo].[UpdateMessageAsRead]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 06/02/2013
-- Description:	SP para marcar un mensaje como leído
-- =============================================
CREATE PROCEDURE [dbo].[UpdateMessageAsRead]
(
	 @IdMessage [sys].[int]
	,@IdPersonOfInterest [sys].[int]
	,@ReadDate [sys].[datetime]
)
AS
BEGIN
	UPDATE	[dbo].[MessagePersonOfInterest]
	SET		 [Read] = 1
			,[ReadDate] = @ReadDate
	WHERE	[IdMessage] = @IdMessage AND
			[IdPersonOfInterest] = @IdPersonOfInterest
END
