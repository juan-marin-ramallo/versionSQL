/****** Object:  Procedure [dbo].[SaveZone]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Leo Repetto
-- Create date: 25/09/2012
-- Description:	SP para guardar una Zona
-- =============================================
CREATE PROCEDURE [dbo].[SaveZone]
(

	 @Id [sys].[int]OUTPUT
	,@Description [sys].[varchar](50)
	,@Date [sys].[Datetime]
	,@PointOfInterestId [sys].[varchar](max) = NULL
	,@PersonOfInterestId [sys].[varchar](max) = NULL

)
AS
BEGIN

	--Zone Description Duplicated
	IF EXISTS (SELECT 1 FROM [ZoneTranslated] WITH (NOLOCK) WHERE [Description] = @Description) SELECT @Id = -1;

	ELSE
	BEGIN 

		INSERT INTO [dbo].[Zone](Description, Date, ApplyToAllPointOfInterest, ApplyToAllPersonOfInterest)
		VALUES (@Description, @Date, 0, 0)

		SET @Id = SCOPE_IDENTITY()

		INSERT INTO [dbo].[PointOfInterestZone]([IdZone], [IdPointOfInterest])
		(SELECT @Id AS IdZone, P.[Id] AS [IdPointOfInterest]
		FROM	[dbo].[PointOfInterest] P
		WHERE	P.[Deleted] = 0 AND (dbo.CheckValueInList(P.[Id], @PointOfInterestId) = 1))

		INSERT INTO [dbo].[PersonOfInterestZone]([IdZone], [IdPersonOfInterest])
		(SELECT @Id AS IdZone, P.[Id] AS [IdPersonOfInterest]
		FROM	[dbo].[PersonOfInterest] P
		WHERE	P.[Deleted] = 0 AND (dbo.CheckValueInList(P.[Id], @PersonOfInterestId) = 1))

	END

END
