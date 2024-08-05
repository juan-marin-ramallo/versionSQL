/****** Object:  Procedure [dbo].[SaveAssetReportDynamic]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SaveAssetReportDynamic]
	 @IdAsset [sys].[INT] = NULL
	,@IdPersonOfInterest [sys].[INT] = NULL
	,@IdPointOfInterest [sys].[INT] = NULL
	,@ReportDateTime [sys].[DATETIME] = NULL
	,@Id [sys].[int] OUT
	,@Notify [sys].[bit] OUT
AS
BEGIN
	
	SET @Notify = 0
	SET @Id = 0

	IF EXISTS (SELECT 1 FROM [dbo].[Asset] WITH (NOLOCK) WHERE [id] = @IdAsset) 
		AND EXISTS (SELECT 1 FROM [dbo].[PointOfInterest] WITH (NOLOCK) WHERE [id] = @IdPointOfInterest)
	BEGIN
		INSERT INTO dbo.[AssetReportDynamic]
		        ( [IdAsset],
		          [IdPersonOfInterest],
		          [IdPointOfInterest],
		          [Date]
		        )
		VALUES  ( @IdAsset, 
		          @IdPersonOfInterest, 
		          @IdPointOfInterest, 
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
