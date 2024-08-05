/****** Object:  Procedure [dbo].[SavePersonOfInterest]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 25/09/2012
-- Description:	SP para guardar un repositor
-- =============================================
CREATE PROCEDURE [dbo].[SavePersonOfInterest]
(
	 @Id [sys].[int] OUTPUT
	,@Name [sys].[varchar](50)
	,@LastName [sys].[varchar](50)
	,@Identifier [sys].[varchar](20) = NULL
	,@MobilePhoneNumber [sys].[varchar](20) = NULL
	,@MobileIMEI [sys].[varchar](40)
	,@Status [sys].[char](1)
	,@Type [sys].[char](1) = NULL
	,@IdDepartment [sys].[int] = NULL
	,@Pending [sys].[bit] = 0
	,@Pin [sys].[varchar](4) = NULL
	,@Avatar [sys].[varbinary](MAX) = NULL
	,@Email [sys].[VARCHAR](255) = NULL
	,@Result [sys].[smallint] OUTPUT
	,@ResultMessage [sys].[varchar](200) OUTPUT
	,@DataAttributeValues [PersonCustomAttributeValueTableType] READONLY
)
AS
BEGIN
	DECLARE @MaxPersonsOfInterestCount [sys].[int]
	DECLARE @PersonsOfInterestCount [sys].[int]
	DECLARE @ExistingMobilePhoneNumber [sys].[bit]
	DECLARE @ExistingIdentifier [sys].[bit]
	DECLARE @ExistingMobileIMEI [sys].[bit]
	DECLARE @ExistingEmail [sys].[bit] = NULL
	
	SET @MaxPersonsOfInterestCount = (SELECT PC.[Value] FROM [dbo].[PackageConfigurationTranslated] PC WITH(NOLOCK) WHERE PC.Id = 1)
	SET @PersonsOfInterestCount = (SELECT Count(1) FROM	[dbo].[AvailablePersonOfInterest] A
									WHERE	NOT EXISTS (SELECT 1 FROM [dbo].[User] WITH(NOLOCK) WHERE [SuperAdmin] = 1 AND [IdPersonOfInterest] IS NOT NULL)
											OR [Id] NOT IN (SELECT [IdPersonOfInterest] FROM [dbo].[User] WITH(NOLOCK) WHERE [SuperAdmin] = 1))
	
	IF @PersonsOfInterestCount < @MaxPersonsOfInterestCount
		BEGIN
			SET @ExistingMobilePhoneNumber = (SELECT TOP (1) 1 FROM [dbo].[PersonOfInterest] S WITH(NOLOCK) WHERE S.Deleted = 0 AND S.MobilePhoneNumber = @MobilePhoneNumber)
			SET @ExistingMobileIMEI = (SELECT TOP (1) 1 FROM [dbo].[PersonOfInterest] S WITH(NOLOCK) WHERE S.Deleted = 0 AND S.MobileIMEI = @MobileIMEI)
			SET @ExistingIdentifier = (SELECT TOP (1) 1 FROM [dbo].[PersonOfInterest] S WITH(NOLOCK) WHERE S.Deleted = 0 AND S.Identifier = @Identifier)
			
            IF EXISTS (SELECT TOP (1) 1 FROM [dbo].[Configuration] C WITH (NOLOCK) WHERE [Id] = 4089 AND [Value] = '1') -- Chilean Regulation Compliance
            BEGIN
                SET @ExistingEmail = (SELECT TOP (1) 1 FROM [dbo].[PersonOfInterest] S WITH(NOLOCK) WHERE S.Deleted = 0 AND @Email IS NOT NULL AND S.Email = @Email)
            END
	
			IF @ExistingMobilePhoneNumber IS NULL AND @ExistingMobileIMEI IS NULL AND @ExistingIdentifier IS NULL AND @ExistingEmail IS NULL
				BEGIN
					INSERT INTO [dbo].[PersonOfInterest]([Name], [LastName], [Identifier], 
								[MobilePhoneNumber], [MobileIMEI], [Status], [Type], [IdDepartment], 
								[Deleted], [Pending], [Pin], [PinDate], [Avatar], [Email])
					VALUES		(@Name, @LastName, @Identifier, @MobilePhoneNumber, @MobileIMEI, @Status, 
								@Type, @IdDepartment, 0, @Pending, @Pin, GETUTCDATE(), @Avatar, @Email)

					SELECT @Id = SCOPE_IDENTITY()
					SET @Result = 0

					INSERT INTO dbo.PersonOfInterestZone([IdPersonOfInterest], [IdZone])
					SELECT @Id, Z.[Id]
					FROM [dbo].[ZoneTranslated] Z WITH (NOLOCK)
					WHERE Z.[ApplyToAllPersonOfInterest]= 1

					DELETE FROM [dbo].[PersonCustomAttributeValue] WHERE [IdPersonOfInterest] IN (SELECT DISTINCT [Id] FROM PersonOfInterest peoi INNER JOIN @DataAttributeValues pcav on peoi.[Identifier] = pcav.[PersonOfInterestIdentifier])
					INSERT INTO [dbo].[PersonCustomAttributeValue] ([IdPersonCustomAttribute], [Value], [IdPersonOfInterest])
					SELECT pcav.[IdPersonCustomAttribute], pcav.[Value], pr.[Id]
					FROM @DataAttributeValues pcav
					INNER JOIN [dbo].[PersonOfInterest] pr ON pcav.[PersonOfInterestIdentifier] = pr.[Identifier]
				END
			ELSE
			BEGIN 
				SET @Result = 0
				IF @ExistingIdentifier IS NOT NULL
				BEGIN
					SET @Result = @Result + 1
				END
				IF @ExistingMobileIMEI IS NOT NULL
				BEGIN
					SET @Result = @Result + 2
				END
				IF @ExistingMobilePhoneNumber IS NOT NULL
				BEGIN
					SET @Result = @Result + 4
				END
                IF @ExistingEmail IS NOT NULL
				BEGIN
					SET @Result = @Result + 8
				END
			END
		END
	ELSE
		BEGIN
			SET @Result = -1
			SET @ResultMessage = (SELECT CONVERT([sys].[varchar], PC.Value) AS ErrorMessage 
									FROM [dbo].[PackageConfigurationTranslated] PC WITH(NOLOCK) WHERE PC.Id = 1)
		END
END
