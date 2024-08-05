/****** Object:  Procedure [dbo].[SavePointOfInterestFromMobile]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 25/09/2012
-- Description:	SP para guardar un punto de interés desde el celular
-- =============================================
CREATE PROCEDURE [dbo].[SavePointOfInterestFromMobile]
(
	 @Id [sys].[int] OUTPUT
	,@Result [sys].[smallint] OUTPUT
	,@Name [sys].[varchar](100)
	,@Latitude [sys].[decimal](25, 20)
	,@Longitude [sys].[decimal](25, 20)
	,@Identifier [sys].[varchar](50) = NULL
	,@ImageUrl [sys].[varchar](2000) = NULL
	,@Address [sys].[varchar](250) = NULL
	,@ContactName [sys].[varchar](50) = NULL
	,@ContactNumber [sys].[varchar](50) = NULL
	,@Emails [sys].[varchar](1000) = NULL
	,@IdDepartment [sys].[int] = NULL
	,@IdZone [sys].[int] = NULL
	,@IdHierarchy1 [sys].[int] = NULL
	,@IdHierarchy2 [sys].[int] = NULL
	,@Attributes [dbo].[CustomAttributeTableType] READONLY
	,@IdPersonOfInterest [sys].[INT]
    ,@AutoConfirm [sys].[BIT] = 0
)
AS
BEGIN

	DECLARE @ExistingIdentifier [sys].[varchar](50)
	DECLARE @Radius [sys].[int]
	DECLARE @MinElapsedTimeForVisit [sys].[int]
	SET @Id = 0

	--SET @ExistingIdentifier = (SELECT P.[Identifier] FROM [dbo].[PointOfInterest] P WITH(NOLOCK) WHERE P.[Deleted] = 0 AND P.[Identifier] = @Identifier)
	SET @Radius = (SELECT C.[Value] FROM [dbo].[ConfigurationTranslated] C WITH(NOLOCK) WHERE C.[Id] = 1)
	SET @MinElapsedTimeForVisit =(SELECT C.[Value] FROM [dbo].[ConfigurationTranslated] C WITH(NOLOCK) WHERE C.[Id] = 11)

	IF NOT EXISTS (SELECT 1 FROM [dbo].[PointOfInterest] WITH(NOLOCK) WHERE [Name] = @Name
					AND [Latitude] = @Latitude and [Longitude] = @Longitude)
	BEGIN

		INSERT INTO [dbo].[PointOfInterest]([Name], [Address], [Latitude], [Longitude], [Radius], [MinElapsedTimeForVisit], 
					[IdDepartment], [Deleted], LatLong, [Identifier], [ContactName], [ContactPhoneNumber], [Emails], [NFCTagId],
					[GrandfatherId], [FatherId], [Pending], [ImageUrl], [IdPersonOfInterest], [CreatedDate])
	
		VALUES		(@Name, @Address, @Latitude, @Longitude, @Radius, @MinElapsedTimeForVisit,
					@IdDepartment, IIF(@AutoConfirm = 1, 0,1), GEOGRAPHY::STPointFromText('POINT(' + CAST(@Longitude AS VARCHAR(25)) + ' ' + CAST(@Latitude AS VARCHAR(25)) + ')', 4326),
					@Identifier, @ContactName, @ContactNumber, @Emails, NULL, 
					@IdHierarchy1, @IdHierarchy2, IIF(@AutoConfirm = 1, 0,1), @ImageUrl, @IdPersonOfInterest, GETUTCDATE())
	
		SET @Id = SCOPE_IDENTITY()

		DECLARE @InsertedZones TABLE (IdZone [sys].[int])

		INSERT INTO dbo.PointOfInterestZone
		OUTPUT INSERTED.IdZone INTO @InsertedZones(IdZone)
		SELECT @Id, Z.[Id]
		FROM [dbo].[ZoneTranslated] Z  WITH (NOLOCK)
		WHERE Z.[ApplyToAllPointOfInterest] = 1

		IF @IdZone IS NOT NULL AND EXISTS (SELECT 1 FROM [dbo].[ZoneTranslated] Z  WITH (NOLOCK) WHERE Z.[ApplyToAllPointOfInterest] = 0)
			AND NOT EXISTS (SELECT 1 FROM @InsertedZones WHERE IdZone = @IdZone)
		BEGIN
			INSERT INTO dbo.[PointOfInterestZone](IdPointOfInterest, IdZone)
			VALUES (@Id, @IdZone)
		END

		INSERT INTO [dbo].[CustomAttributeValue]([IdCustomAttribute], [IdPointOfInterest], [Value], [IdCustomAttributeOption])
		SELECT A.[IdCustomAttribute], @Id, IIF(A.[IdOption] IS NULL, A.[Value], NULL), A.[IdOption]
		FROM @Attributes A
	END
		
	SET @Result = 1
END
