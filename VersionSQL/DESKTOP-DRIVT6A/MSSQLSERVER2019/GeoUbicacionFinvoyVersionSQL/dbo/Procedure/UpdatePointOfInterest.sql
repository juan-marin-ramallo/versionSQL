/****** Object:  Procedure [dbo].[UpdatePointOfInterest]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 25/09/2012
-- Description:	SP para actualizar un punto de interés
-- =============================================
CREATE PROCEDURE [dbo].[UpdatePointOfInterest]
(
	 @Id [sys].[int]
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
	,@IdUser [sys].[int] = NULL
	,@NFCTagId [sys].[varchar](20) = NULL
	,@HierarchyLevel1Id [sys].[int] = NULL
	,@HierarchyLevel2Id [sys].[int] = NULL
	,@ChangeImage bit = NULL
	,@ImageUrl [sys].[varchar](2000) = NULL
	,@Emails VARCHAR(1000) = NULL
	,@Result [sys].[smallint] OUTPUT
)
AS
BEGIN

	DECLARE @ActualLatitude [sys].[decimal](25, 20)
	DECLARE @ActualLongitude [sys].[decimal](25, 20)

	SELECT	@ActualLatitude = [Latitude], @ActualLongitude = [Longitude]
	FROM	[dbo].[PointOfInterest] WITH (NOLOCK)
	WHERE	[Id] = @Id

	DECLARE @ExistingIdentifier [sys].[varchar](50)
	SET @ExistingIdentifier = (SELECT P.[Identifier] FROM [dbo].[PointOfInterest] P WITH (NOLOCK) WHERE P.[Id] <> @Id 
								AND P.[Deleted] = 0 AND P.[Identifier] = @Identifier)

	IF @ExistingIdentifier IS NULL
	BEGIN
		--Verifico si hubo cambios de latitud y/o longitud
		IF @ActualLatitude <> @Latitude OR @ActualLongitude <> @Longitude
		BEGIN
			UPDATE	[dbo].[PointOfInterest]
			SET		[Name] = @Name
					,[Address] = @Address
					,[Latitude] = @Latitude
					,[Longitude] = @Longitude
					,[Radius] = @Radius
					,[MinElapsedTimeForVisit] = @MinElapsedTimeForVisit
					,[IdDepartment] = @IdDepartment
					,Latlong=GEOGRAPHY::STPointFromText('POINT(' + CAST(@Longitude AS VARCHAR(25)) + ' ' + CAST(@Latitude AS VARCHAR(25)) + ')', 4326)
					,[Identifier]=@Identifier
					,[LocationChangeDate] = GETUTCDATE()
					,[LocationChangeUser] = @IdUser
					,[ContactName] = @ContactName
					,[ContactPhoneNumber] = @ContactPhoneNumber
					,[NFCTagId] = CASE WHEN @NFCTagId IS NOT NULL THEN @NFCTagId ELSE [NFCTagId] END
					,[GrandfatherId] = @HierarchyLevel1Id
					,[FatherId] = @HierarchyLevel2Id
					,[EditedDate] = GETUTCDATE(),
					[Emails] = @Emails
			WHERE	[Id] = @Id

			SET @Result = 1
		END
		ELSE
		BEGIN
			UPDATE	[dbo].[PointOfInterest]
			SET		[Name] = @Name
					,[Address] = @Address
					,[Latitude] = @Latitude
					,[Longitude] = @Longitude
					,[Radius] = @Radius
					,[MinElapsedTimeForVisit] = @MinElapsedTimeForVisit
					,[IdDepartment] = @IdDepartment
					,Latlong=GEOGRAPHY::STPointFromText('POINT(' + CAST(@Longitude AS VARCHAR(25)) + ' ' + CAST(@Latitude AS VARCHAR(25)) + ')', 4326)
					,[Identifier]=@Identifier
					,[ContactName] = @ContactName
					,[ContactPhoneNumber] = @ContactPhoneNumber
					,[NFCTagId] = CASE WHEN @NFCTagId IS NOT NULL THEN @NFCTagId ELSE [NFCTagId] END
					,[GrandfatherId] = @HierarchyLevel1Id
					,[FatherId] = @HierarchyLevel2Id
					,[EditedDate] = GETUTCDATE(),
					[Emails] = @Emails
			WHERE	[Id] = @Id

			SET @Result = 1

		END
	END
	ELSE IF @ExistingIdentifier = @Identifier
	BEGIN
		SET @Result = 2
	END

	IF @ChangeImage = 1
	BEGIN
		UPDATE	[dbo].[PointOfInterest]
		SET		[ImageUrl] = @ImageUrl
		WHERE	[Id] = @Id
	END
END
