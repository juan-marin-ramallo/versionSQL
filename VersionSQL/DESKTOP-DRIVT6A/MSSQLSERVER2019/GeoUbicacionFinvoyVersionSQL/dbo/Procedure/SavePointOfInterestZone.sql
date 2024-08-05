/****** Object:  Procedure [dbo].[SavePointOfInterestZone]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 18/08/2014
-- Description:	SP para guardar las zonas de un punto de interés
-- =============================================
CREATE PROCEDURE [dbo].[SavePointOfInterestZone]
(
	 @IdPointOfInterest [sys].[int]
	,@IdZones [sys].[varchar](1000) = NULL
	,@IsUpdate [sys].[bit] = NULL
)
AS
BEGIN
	INSERT INTO [dbo].[PointOfInterestZone](IdPointOfInterest, IdZone)
	(SELECT	@IdPointOfInterest, Z.[Id]
	FROM	[dbo].[ZoneTranslated] Z  WITH (NOLOCK)
	WHERE	dbo.CheckValueInList(Z.[Id], @IdZones) = 1  AND (Z.ApplyToAllPointOfInterest = 0))

	IF NOT EXISTS (SELECT 1 FROM [dbo].[PointOfInterestZone] WITH (NOLOCK) WHERE 
			 [IdPointOfInterest] = @IdPointOfInterest AND
			[IdZone] in (select [Id] FROM dbo.[ZoneTranslated] WITH (NOLOCK) WHERE [ApplyToAllPointOfInterest] = 1))
	BEGIN
		INSERT INTO [dbo].[PointOfInterestZone]([IdPointOfInterest], IdZone)
		SELECT	@IdPointOfInterest, Z.[Id]
		FROM	[dbo].[ZoneTranslated] Z WITH (NOLOCK)
		WHERE	Z.[ApplyToAllPointOfInterest] = 1
	END
END
