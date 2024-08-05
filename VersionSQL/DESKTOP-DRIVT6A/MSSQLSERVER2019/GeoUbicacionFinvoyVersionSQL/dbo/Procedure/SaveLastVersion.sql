/****** Object:  Procedure [dbo].[SaveLastVersion]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 09/09/2016
-- Description:	SP para guardar la ultima version del dispositivo
-- =============================================
CREATE PROCEDURE [dbo].[SaveLastVersion]
(
	 @IdPersonOfInterest [sys].[int]
	,@Version [sys].[varchar](10) = NULL
)
AS
BEGIN
	IF @Version IS NOT NULL
		DECLARE @Now [sys].[datetime]
		SET @Now = GETUTCDATE()

		BEGIN

			IF EXISTS (SELECT 1 FROM [dbo].[PersonOfInterestMobileVersion] WITH (NOLOCK) WHERE [IdPersonOfInterest] = @IdPersonOfInterest)
			BEGIN
				UPDATE	[dbo].[PersonOfInterestMobileVersion]
				SET		[Version] = @Version, [Date] = @Now
				WHERE	[IdPersonOfInterest] = @IdPersonOfInterest
			END
			ELSE
			BEGIN
				INSERT INTO [dbo].[PersonOfInterestMobileVersion]([IdPersonOfInterest], [Version], [Date])
				VALUES		(@IdPersonOfInterest, @Version, @Now)
			END

		END
END
