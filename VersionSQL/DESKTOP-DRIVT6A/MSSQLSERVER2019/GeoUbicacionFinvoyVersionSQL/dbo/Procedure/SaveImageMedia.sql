/****** Object:  Procedure [dbo].[SaveImageMedia]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Diego Cáceres
-- Create date: 28/10/2014
-- Description:	SP para guardar el array de una imagen segun su id
-- =============================================
CREATE PROCEDURE [dbo].[SaveImageMedia]

    @IdAnswer [sys].[int],
	@ImageArray [sys].[image],	
	@ResultCode [sys].[smallint] OUT

AS
BEGIN
	
	UPDATE 	[dbo].[Answer]
	SET [ImageEncoded] = @ImageArray
	WHERE [Id] = @IdAnswer
	
	IF @@ROWCOUNT > 0 
	BEGIN
		SELECT @ResultCode = 0
	END
	ELSE
	BEGIN
		SELECT @ResultCode = -2
	END
	
END
