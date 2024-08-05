/****** Object:  Procedure [dbo].[SaveShareOfShelfImageUrl]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		FS
-- Create date: 10/05/2019
-- Description:	SP para obtener id de imagen 
-- =============================================
CREATE PROCEDURE [dbo].[SaveShareOfShelfImageUrl]
    @Id [sys].[INT],
	@ImageUrl [sys].VARCHAR(512),
	@ImageRecUrl [sys].VARCHAR(1000) = NULL,
	@ResultCode [sys].[SMALLINT] OUT
AS
BEGIN
	IF EXISTS (SELECT 1 FROM dbo.[ShareOfShelfImage] WHERE Id = @Id)
	BEGIN
		UPDATE dbo.[ShareOfShelfImage] 
		SET [ImageUrl] = @ImageUrl, [ImageRecognitionUrl] = @ImageRecUrl
		WHERE [Id] = @Id

		SET @ResultCode = 0
	END
	ELSE 
	BEGIN
		SET @ResultCode = 1
    END
END;
