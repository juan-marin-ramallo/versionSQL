/****** Object:  Procedure [dbo].[UpdateZone]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Leo Repetto
-- Create date: 25/09/2012
-- Description:	SP para actualizar una Zona
-- =============================================
CREATE PROCEDURE [dbo].[UpdateZone]
(
	 @Id [sys].[int]
	,@Description [sys].[varchar](50)
	,@Date [sys].[Datetime]
	,@IdPersonsOfInterest [sys].[varchar](max) = NULL
	,@IdPointsOfInterest [sys].[varchar](max) = NULL
	,@UpdateDescriptionOnly [sys].[BIT] = 0
)
AS
BEGIN

	--Zone Description Duplicated
	IF EXISTS (SELECT 1 FROM [ZoneTranslated] WITH (NOLOCK) WHERE [Description] = @Description AND @Id != Id) SELECT -1 AS Id;

	ELSE
	BEGIN 

		UPDATE	[dbo].[Zone]
		SET		[Description] = @Description, [Date] = @Date
		WHERE	[Id] = @Id

		IF @UpdateDescriptionOnly = 0
		BEGIN
			IF @IdPointsOfInterest IS NOT NULL
			BEGIN 
 				DELETE FROM [dbo].[PointOfInterestZone]
 				WHERE [IdZone] = @Id AND dbo.CheckValueInList([IdPointOfInterest], @IdPointsOfInterest) = 0
			END
			ELSE
			BEGIN
				DELETE FROM [dbo].[PointOfInterestZone]
 				WHERE [IdZone] = @Id 
			END

			INSERT INTO [dbo].[PointOfInterestZone]([IdZone], [IdPointOfInterest])
 			(SELECT @Id AS IdZone, P.[Id] AS IdPointOfInterest
 			 FROM	[dbo].[PointOfInterest] P
 			 WHERE	((dbo.CheckValueInList(P.[Id], @IdPointsOfInterest) = 1))
 					AND P.[Deleted] = 0 AND P.[Id] NOT IN ( SELECT PP.[IdPointOfInterest] 
 										FROM [dbo].[PointOfInterestZone] PP 
 										WHERE PP.[IdZone] = @Id))

			IF @IdPersonsOfInterest IS NOT NULL
			BEGIN 
 				DELETE FROM [dbo].[PersonOfInterestZone]
 				WHERE [IdZone] = @Id AND dbo.CheckValueInList([IdPersonOfInterest], @IdPersonsOfInterest) = 0
			END
			ELSE
			BEGIN
				DELETE FROM [dbo].[PersonOfInterestZone]
 				WHERE [IdZone] = @Id 
			END

			INSERT INTO [dbo].[PersonOfInterestZone]([IdZone], [IdPersonOfInterest])
 			(SELECT @Id AS IdZone, P.[Id] AS IdPersonOfInterest
 			 FROM	[dbo].[PersonOfInterest] P
 			 WHERE	((dbo.CheckValueInList(P.[Id], @IdPersonsOfInterest) = 1))
 					AND P.[Deleted] = 0 AND P.[Id] NOT IN ( SELECT PP.[IdPersonOfInterest] 
 										FROM [dbo].[PersonOfInterestZone] PP 
 										WHERE PP.[IdZone] = @Id))
		END

		SELECT @Id as Id;

	END

END
