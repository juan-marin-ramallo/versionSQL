/****** Object:  Procedure [dbo].[SaveOrderReport]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:GL
-- Create date: <Create Date,,>
-- Description: GUARDA PEDIDOS ENVIADOS DESDE LA APP
-- =============================================
CREATE PROCEDURE [dbo].[SaveOrderReport]
	@Id [sys].[int] OUT
	,@IdPersonOfInterest [sys].[int]
	,@IdPointOfInterest [sys].[int]
	,@ReportDateTime [sys].[datetime]
	,@Comment [sys].[varchar](250) = NULL
	,@Emails [sys].[varchar](500) = NULL
	,@Status [sys].[smallint] = NULL
	,@IdOrderReport [sys].[int] = 0
AS
BEGIN
	SET @Id = 0

	IF EXISTS (SELECT 1 FROM [dbo].[PointOfInterest] WITH (NOLOCK) WHERE [id] = @IdPointOfInterest)
	BEGIN
		IF NOT EXISTS (SELECT 1 FROM [dbo].[OrderReport] WITH (NOLOCK) WHERE [IdPointOfInterest] = @IdPointOfInterest AND [OrderDateTime] = @ReportDateTime AND [IdPersonOfInterest] = @IdPersonOfInterest)
		BEGIN
			IF NOT EXISTS (SELECT 1 FROM [dbo].[OrderReport] WITH (NOLOCK) WHERE [Id] = @IdOrderReport)
			BEGIN
				SET NOCOUNT ON;
				IF @Status IS NULL
				BEGIN
					INSERT INTO [dbo].[OrderReport] ([IdPersonOfInterest], [IdPointOfInterest], [OrderDateTime], [ReceivedDateTime], [Comment], [Emails])
					VALUES (@IdPersonOfInterest, @IdPointOfInterest, @ReportDateTime, GETUTCDATE(), @Comment, @Emails)
				END ELSE
				BEGIN
					INSERT INTO [dbo].[OrderReport] ([IdPersonOfInterest], [IdPointOfInterest], [OrderDateTime], [ReceivedDateTime], [Comment], [Emails], [Status])
					VALUES (@IdPersonOfInterest, @IdPointOfInterest, @ReportDateTime, GETUTCDATE(), @Comment, @Emails, @Status)
				END

				SELECT @Id = SCOPE_IDENTITY()
 
				EXEC [dbo].[SavePointsOfInterestActivity]
					@IdPersonOfInterest = @IdPersonOfInterest
					,@IdPointOfInterest = @IdPointOfInterest
					,@DateIn = @ReportDateTime
					,@AutomaticValue = 12
			END
			ELSE BEGIN
				UPDATE [dbo].[OrderReport] SET [OrderTotalQuantity] = 0 WHERE [Id] = @IdOrderReport
				SELECT @Id = @IdOrderReport
			END
		END
	END
END
