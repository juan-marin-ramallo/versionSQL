/****** Object:  Procedure [dbo].[SavePointOfInterest]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 25/09/2012
-- Description:	SP para guardar un punto de interés
-- =============================================
CREATE PROCEDURE [dbo].[SavePointOfInterest]
(
	 @Id [sys].[int] OUTPUT
	,@Result [sys].[smallint] OUTPUT
	,@Name [sys].[varchar](100)
	,@Address [sys].[varchar](250) = NULL
	,@Latitude [sys].[decimal](25, 20)
	,@Longitude [sys].[decimal](25, 20)
	,@Radius [sys].[int]
	,@MinElapsedTimeForVisit [sys].[int]
	,@IdDepartment [sys].[int] = NULL
	,@Identifier [sys].[varchar](50) = NULL
	,@ContactName [sys].[varchar](50) = NULL
	,@ContactPhoneNumber [sys].[varchar](50) = NULL
	,@NFCTagId [sys].[varchar](20) = NULL
	,@HierarchyLevel1Id [sys].[int] = NULL
	,@HierarchyLevel2Id [sys].[int] = NULL
	,@ImageUrl [sys].[varchar](2000) = NULL
	,@Emails VARCHAR(1000) = NULL
)
AS
BEGIN

	DECLARE @ExistingIdentifier [sys].[varchar](50)
	SET @ExistingIdentifier = (SELECT P.[Identifier] FROM [dbo].[PointOfInterest] P WITH(NOLOCK) WHERE P.[Deleted] = 0 AND P.[Identifier] = @Identifier)

	IF @ExistingIdentifier IS NULL
	BEGIN

		INSERT INTO [dbo].[PointOfInterest]([Name], [Address], [Latitude], [Longitude], [Radius], [MinElapsedTimeForVisit], 
					[IdDepartment], [Deleted], LatLong, [Identifier], [ContactName], [ContactPhoneNumber], [NFCTagId],
					[GrandfatherId], [FatherId], [CreatedDate], [ImageUrl], [Emails])
	
		VALUES		(@Name, @Address, @Latitude, @Longitude, @Radius, @MinElapsedTimeForVisit, @IdDepartment, 0,
					GEOGRAPHY::STPointFromText('POINT(' + CAST(@Longitude AS VARCHAR(25)) + ' ' + CAST(@Latitude AS VARCHAR(25)) + ')', 4326),
					@Identifier, @ContactName, @ContactPhoneNumber, @NFCTagId, @HierarchyLevel1Id, @HierarchyLevel2Id, GETUTCDATE(), @ImageUrl, @Emails)
	
		SELECT @Id = SCOPE_IDENTITY()
		SET @Result = 1

		INSERT INTO dbo.PointOfInterestZone
		SELECT @Id, Z.[Id]
		FROM [dbo].[ZoneTranslated] Z  WITH (NOLOCK)
		WHERE Z.[ApplyToAllPointOfInterest] = 1

	END
	ELSE IF @ExistingIdentifier = @Identifier
	BEGIN
		SET @Result = 2
	END
END
