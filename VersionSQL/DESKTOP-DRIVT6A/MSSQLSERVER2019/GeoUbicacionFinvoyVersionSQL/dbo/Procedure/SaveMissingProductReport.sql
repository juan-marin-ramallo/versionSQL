/****** Object:  Procedure [dbo].[SaveMissingProductReport]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[SaveMissingProductReport]
	@IdProducts VARCHAR(MAX) = NULL,
	@IdPersonOfInterest INT,
	@IdPointOfInterest INT,
	@ReportDateTime DATETIME,
	@MissingConfirmation BIT = NULL,
	@ShortageTypeId INT = NULL,
	@Id int OUTPUT,
	@Images ImageTableType READONLY,
	@IsManual BIT = NULL
AS
BEGIN
	DECLARE @Now DATETIME
	SET @Now = GETUTCDATE()

	INSERT INTO ProductMissingPointOfInterest (IdPointOfInterest, IdPersonOfInterest, Date, ReceivedDate, MissingConfirmation, IdProductMissingType, Deleted, IsManual)
	VALUES (@IdPointOfInterest, @IdPersonOfInterest, @ReportDateTime, @Now, @MissingConfirmation, @ShortageTypeId, 0, @IsManual)

	SET @Id = SCOPE_IDENTITY()

	IF @IdProducts IS NOT NULL
	BEGIN
		INSERT INTO ProductMissingReport(IdMissingProductPoi,IdProduct)
		SELECT @Id AS IdMissingProductPoi, P.Id AS IdProduct
		FROM Product P WITH (NOLOCK)
		WHERE P.Deleted = 0 AND (dbo.CheckValueInList(P.Id, @IdProducts) = 1)
	END

	INSERT INTO ProductMissingImage
	(
		IdProductMissing,
		ImageName,
		ImageUrl
	)
	SELECT  @Id, i.ImageName, NULL
	FROM @Images i

	IF EXISTS (SELECT 1 FROM ProductMissingPointOfInterest WITH (NOLOCK) WHERE IdPointOfInterest = @IdPointOfInterest AND
		IdPersonOfInterest = @IdPersonOfInterest AND Tzdb.AreSameSystemDates(Date, @ReportDateTime) = 1 AND
		IdProductMissingType = @ShortageTypeId
		AND Deleted = 0
		AND Id <> @Id)
	BEGIN
		SET NOCOUNT ON;
		UPDATE ProductMissingPointOfInterest
		SET Deleted = 1
		WHERE IdPointOfInterest = @IdPointOfInterest AND
		IdPersonOfInterest = @IdPersonOfInterest AND Tzdb.AreSameSystemDates(Date, @ReportDateTime) = 1 AND
		IdProductMissingType = @ShortageTypeId AND Deleted = 0 AND Id <> @Id
	END

	EXEC SavePointsOfInterestActivity
		@IdPersonOfInterest = @IdPersonOfInterest,
		@IdPointOfInterest = @IdPointOfInterest,
		@DateIn = @ReportDateTime,
		@AutomaticValue = 10
END
