/****** Object:  Procedure [dbo].[SaveImageMediaUrl]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 12/10/2018
-- Description:	SP para guardar LA URL DE UNA IMAGEN SEGUN SU ID
-- =============================================
CREATE PROCEDURE [dbo].[SaveImageMediaUrl]

    @IdAnswer [sys].[int],
	@ImageUrl [sys].[varchar](5000),	
	@ResultCode [sys].[smallint] OUT

AS
BEGIN
	
	UPDATE 	[dbo].[Answer]
	SET [ImageUrl] = @ImageUrl
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
