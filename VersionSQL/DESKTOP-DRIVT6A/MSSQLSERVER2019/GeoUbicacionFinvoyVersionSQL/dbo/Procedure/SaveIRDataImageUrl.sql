/****** Object:  Procedure [dbo].[SaveIRDataImageUrl]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author: Cristian Barbarini
-- Create date: 09/06/2022
-- Description: SP para guardar imágenes de nuevas entidades RI
-- =============================================
CREATE PROCEDURE [dbo].[SaveIRDataImageUrl]
(
	@UniqueImageName VARCHAR(256),
	@ShareOfShelfId INT = NULL,
	@MissingProductId INT = NULL,
	@ImageUrl VARCHAR(512),
	@ImageRecUrl VARCHAR(1000) = NULL,
	@ResultCode SMALLINT OUT,
	@AllImages BIT OUT
)
AS
BEGIN
	DECLARE @ResultCodeShareOfShelf SMALLINT = 0, @ResultCodeMissingProduct SMALLINT = 0;
	DECLARE @AllImagesShareOfShelf BIT = 1, @AllImagesMissingProduct BIT = 1;

	IF @ShareOfShelfId IS NOT NULL
	BEGIN
		IF EXISTS(SELECT TOP 1 1 FROM ShareOfShelfImage WHERE IdShareOfShelf = @ShareOfShelfId AND ImageName = @UniqueImageName)
		BEGIN
			UPDATE ShareOfShelfImage SET ImageUrl = @ImageUrl, ImageRecognitionUrl = @ImageRecUrl
			WHERE IdShareOfShelf = @ShareOfShelfId AND ImageName = @UniqueImageName

			SET @AllImagesShareOfShelf = IIF(EXISTS (SELECT TOP 1 1 FROM ShareOfShelfImage WHERE IdShareOfShelf = @ShareOfShelfId AND ImageRecognitionUrl IS NULL), 0, 1)
		END
		ELSE
		BEGIN
			SET @ResultCodeShareOfShelf = 1
		END
	END

	IF @MissingProductId IS NOT NULL
	BEGIN
		IF EXISTS(SELECT TOP 1 1 FROM ProductMissingImage WHERE IdProductMissing = @MissingProductId AND ImageName = @UniqueImageName)
		BEGIN
			UPDATE ProductMissingImage SET ImageUrl = @ImageUrl, ImageRecognitionUrl = @ImageRecUrl
			WHERE IdProductMissing = @MissingProductId AND ImageName = @UniqueImageName

			SET @AllImagesMissingProduct = IIF(EXISTS (SELECT TOP 1 1 FROM ProductMissingImage WHERE IdProductMissing = @MissingProductId AND ImageRecognitionUrl IS NULL), 0, 1)
		END
		ELSE
		BEGIN
			SET @ResultCodeMissingProduct = 1
		END
	END

	SET @ResultCode = IIF(@ResultCodeShareOfShelf = 0 AND @ResultCodeMissingProduct = 0, 0, 1)
	SET @AllImages = IIF(@AllImagesShareOfShelf = 1 AND @AllImagesMissingProduct = 1, 1, 0)
END

-- OLD)
--AS BEGIN
--	DECLARE @AllImagesShareOfShelf BIT = 0, @AllImagesMissingProduct BIT = 0;
--	IF @ShareOfShelfId IS NOT NULL AND EXISTS(SELECT Id FROM ShareOfShelfImage WHERE IdShareOfShelf = @ShareOfShelfId AND ImageName = @UniqueImageName)
--	BEGIN
--		UPDATE ShareOfShelfImage SET ImageUrl = @ImageUrl, ImageRecognitionUrl = @ImageRecUrl
--		WHERE IdShareOfShelf = @ShareOfShelfId AND ImageName = @UniqueImageName

--		SET @ResultCode = 0
--		SET @AllImagesShareOfShelf = IIF(EXISTS (SELECT TOP 1 1 FROM ShareOfShelfImage WHERE IdShareOfShelf = @ShareOfShelfId AND ImageUrl IS NULL), 0, 1)
--	END
--	ELSE BEGIN
--		SET @ResultCode = 1
--		SET @AllImagesShareOfShelf = 1
--	END

--	IF @MissingProductId IS NOT NULL AND EXISTS(SELECT Id FROM ProductMissingImage WHERE IdProductMissing = @MissingProductId AND ImageName = @UniqueImageName)
--	BEGIN
--		UPDATE ProductMissingImage SET ImageUrl = @ImageUrl, ImageRecognitionUrl = @ImageRecUrl
--		WHERE IdProductMissing = @MissingProductId AND ImageName = @UniqueImageName

--		SET @ResultCode = 0
--		SET @AllImagesMissingProduct = IIF(EXISTS (SELECT TOP 1 1 FROM ProductMissingImage WHERE IdProductMissing = @MissingProductId AND ImageUrl IS NULL), 0, 1)
--	END
--	ELSE BEGIN
--		SET @ResultCode = 1
--		SET @AllImagesMissingProduct = 1
--	END

--	SET @AllImages = IIF(@AllImagesShareOfShelf = 1 AND @AllImagesShareOfShelf = 1, 1, 0)
--END
