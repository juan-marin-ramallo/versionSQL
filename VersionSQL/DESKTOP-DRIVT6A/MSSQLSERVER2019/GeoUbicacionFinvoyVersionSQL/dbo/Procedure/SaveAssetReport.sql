/****** Object:  Procedure [dbo].[SaveAssetReport]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[SaveAssetReport]
	@IdAsset [sys].[INT] = NULL,
	@IdPersonOfInterest [sys].[INT] = NULL,
	@IdPointOfInterest [sys].[INT] = NULL,
	@Description [sys].[VARCHAR](200) = NULL,
	@ReportDateTime [sys].[DATETIME] = NULL,
	@Id [sys].[int] OUT,
	@Notify [sys].[bit] OUT
AS
BEGIN
	SET @Notify = 0
	SET @Id = 0

	IF EXISTS (SELECT 1 FROM [dbo].[Asset] WHERE [id] = @IdAsset) AND EXISTS (SELECT 1 FROM [dbo].[PointOfInterest] WHERE [id] = @IdPointOfInterest)
	BEGIN
		INSERT INTO dbo.[AssetReport]
		        ( [IdAsset] ,
		          [IdPersonOfInterest] ,
		          [IdPointOfInterest] ,
		          [Image] ,
		          [Description] ,
		          [Date]
		        )
		VALUES  ( @IdAsset, 
		          @IdPersonOfInterest, 
		          @IdPointOfInterest, 
		          NULL, 
		          @Description, 
		          @ReportDateTime  
		        )

		SELECT @Id = SCOPE_IDENTITY()

		EXEC [dbo].[SavePointsOfInterestActivity]
				 @IdPersonOfInterest = @IdPersonOfInterest
				,@IdPointOfInterest = @IdPointOfInterest
				,@DateIn = @ReportDateTime
				,@AutomaticValue = 5
	END
END
