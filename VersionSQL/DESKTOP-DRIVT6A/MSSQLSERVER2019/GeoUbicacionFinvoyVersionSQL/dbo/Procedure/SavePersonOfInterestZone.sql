/****** Object:  Procedure [dbo].[SavePersonOfInterestZone]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 16/11/2015
-- Description:	SP para guardar las zonas de una persona de interés
-- =============================================
CREATE PROCEDURE [dbo].[SavePersonOfInterestZone]
(
	 @IdPersonOfInterest [sys].[int]
	,@IdZones [sys].[varchar](1000) = NULL
	,@IsUpdate [sys].[bit] = NULL
)
AS
BEGIN
	INSERT INTO [dbo].[PersonOfInterestZone](IdPersonOfInterest, IdZone)
	(SELECT	@IdPersonOfInterest, Z.[Id]
	FROM	[dbo].[ZoneTranslated] Z WITH (NOLOCK)
	WHERE	dbo.CheckValueInList(Z.[Id], @IdZones) = 1 AND (Z.ApplyToAllPersonOfInterest = 0 OR Z.ApplyToAllPersonOfInterest IS NULL))

	IF NOT EXISTS (SELECT 1 FROM [dbo].[PersonOfInterestZone] WITH (NOLOCK) WHERE 
			[IdPersonOfInterest] = @IdPersonOfInterest AND
			[IdZone] in (select [Id] FROM dbo.[ZoneTranslated] WITH (NOLOCK) WHERE [ApplyToAllPersonOfInterest] = 1))
	BEGIN

		INSERT INTO [dbo].[PersonOfInterestZone](IdPersonOfInterest, IdZone)
		(SELECT	@IdPersonOfInterest, Z.[Id]
		FROM	[dbo].[ZoneTranslated] Z WITH (NOLOCK)
		WHERE	Z.[ApplyToAllPersonOfInterest] = 1) 

	END
END
