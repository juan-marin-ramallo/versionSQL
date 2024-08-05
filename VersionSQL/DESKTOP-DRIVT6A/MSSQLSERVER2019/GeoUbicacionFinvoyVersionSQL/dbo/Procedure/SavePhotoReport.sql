/****** Object:  Procedure [dbo].[SavePhotoReport]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[SavePhotoReport]
	@IdPersonOfInterest [sys].[int],
	@IdPointOfInterest [sys].[int],
	@ReportDateTime [sys].[datetime],
	@ImageName [sys].[varchar](100) = NULL,
	@ImageEncoded [sys].[image] = NULL,
	@ImageUrl [sys].[varchar](5000) = NULL,
	@ImageName2 [sys].[varchar](100) = NULL,
	@ImageEncoded2 [sys].[image] = NULL,
	@ImageUrl2 [sys].[varchar](5000) = NULL,
	@Comments VARCHAR(1000) = NULL,
	@ImageNameAfter [sys].[varchar](100) = NULL,
	@ImageEncodedAfter [sys].[image] = NULL,
	@ImageUrlAfter [sys].[varchar](5000) = NULL,
	@ImageName2After [sys].[varchar](100) = NULL,
	@ImageEncoded2After [sys].[image] = NULL,
	@ImageUrl2After [sys].[varchar](5000) = NULL,
	@CommentsAfter VARCHAR(1000) = NULL,
	@Id [sys].[int] OUT
AS
BEGIN

	SET @Id = 0

		IF NOT EXISTS ( SELECT 1 
					FROM [dbo].[PhotoReport] PR WITH (NOLOCK)
					WHERE PR.[IdPersonOfInterest] = @IdPersonOfInterest AND
						  PR.[IdPointOfInterest] = @IdPointOfInterest AND 
						  PR.[ReportDate] = @ReportDateTime)
		BEGIN
		
			SET NOCOUNT ON;
			
			INSERT INTO		[dbo].[PhotoReport] ([IdPersonOfInterest], [IdPointOfInterest], 
							[ReportDate], [ReceivedDate],
							[Comments], [ImageName1], [ImageEncoded1], [ImageUrl1], [ImageName2], [ImageEncoded2], [ImageUrl2],
							[CommentsAfter], [ImageName1After], [ImageEncoded1After], [ImageUrl1After], [ImageName2After], [ImageEncoded2After], [ImageUrl2After])
			VALUES			(@IdPersonOfInterest, @IdPointOfInterest, @ReportDateTime, GETUTCDATE(), @Comments,
							@ImageName, @ImageEncoded, @ImageUrl, @ImageName2, @ImageEncoded2, @ImageUrl2,
							@CommentsAfter, @ImageNameAfter, @ImageEncodedAfter, @ImageUrlAfter, @ImageName2After, @ImageEncoded2After, @ImageUrl2After)

			SELECT @Id = SCOPE_IDENTITY()

			EXEC [dbo].[SavePointsOfInterestActivity]
				 @IdPersonOfInterest = @IdPersonOfInterest
				,@IdPointOfInterest = @IdPointOfInterest
				,@DateIn = @ReportDateTime
				,@AutomaticValue = 9
	END
END
