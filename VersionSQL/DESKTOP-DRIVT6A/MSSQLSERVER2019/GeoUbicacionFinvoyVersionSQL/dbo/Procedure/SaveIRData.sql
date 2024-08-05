/****** Object:  Procedure [dbo].[SaveIRData]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author: Cristian Barbarini
-- Create date: 09/06/2022 11:00:00
-- Description: SP para guardar nueva entidad de RI
-- =============================================
CREATE PROCEDURE [dbo].[SaveIRData]
(
	@PointOfInterestId INT,
	@PersonOfInterestId INT,
	@Date DATETIME,
	@ProductCategoryId INT,
	@ShareOfShelfId INT = NULL,
	@MissingProductId INT = NULL,
	@Id int OUTPUT,
	@Images ImageTableType READONLY
)
AS BEGIN
	INSERT INTO IRData VALUES(@PointOfInterestId, @PersonOfInterestId, GETDATE(), @Date, @ProductCategoryId, @ShareOfShelfId, @MissingProductId, 0)
	SET @Id = SCOPE_IDENTITY()

	INSERT INTO IRDataImage
	(
		IdIRData,
		ImageName
	)
	SELECT  @Id, i.ImageName
	FROM @Images i
END
