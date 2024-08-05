/****** Object:  Procedure [dbo].[UpdatePersonOfInterest]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 25/09/2012
-- Description:	SP para actualizar un repositor
-- =============================================
CREATE PROCEDURE [dbo].[UpdatePersonOfInterest]
(
	 @Id [sys].[int]
	,@Name [sys].[varchar](50)
	,@LastName [sys].[varchar](50)
	,@Identifier [sys].[varchar](20) = NULL
	,@MobilePhoneNumber [sys].[varchar](20) = NULL
	,@MobileIMEI [sys].[varchar](40)
	,@Status [sys].[char](1)
	,@Type [sys].[char](1) = NULL
	,@IdDepartment [sys].[int] = NULL
	,@Pin [sys].[varchar](4) = NULL
	,@UpdateAvatar [sys].bit
	,@Avatar [sys].[varbinary](MAX) = NULL
	,@Result [sys].[smallint] OUTPUT
	,@DeviceId [sys].[varchar](50)
	,@Email [sys].[VARCHAR](255) = NULL
	,@IdUser [sys].[int]
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
	
	DECLARE @ExistingStatus [sys].[char](1)
	DECLARE @LicencesAllowed [sys].[bit] = 1

	SET @ExistingMobilePhoneNumber = (SELECT TOP (1) 1 FROM [dbo].[PersonOfInterest] S WITH(NOLOCK) WHERE S.Id <> @Id AND S.Deleted = 0 AND S.MobilePhoneNumber = @MobilePhoneNumber)
	SET @ExistingMobileIMEI = (SELECT TOP (1) 1 FROM [dbo].[PersonOfInterest] S WITH(NOLOCK) WHERE S.Id <> @Id AND S.Deleted = 0 AND S.MobileIMEI = @MobileIMEI)
	SET @ExistingIdentifier = (SELECT TOP (1) 1 FROM [dbo].[PersonOfInterest] S WITH(NOLOCK) WHERE S.Id <> @Id AND S.Deleted = 0 AND S.Identifier = @Identifier)

    IF EXISTS (SELECT TOP (1) 1 FROM [dbo].[Configuration] C WITH (NOLOCK) WHERE [Id] = 4089 AND [Value] = '1') -- Chilean Regulation Compliance
    BEGIN
        SET @ExistingEmail = (SELECT TOP (1) 1 FROM [dbo].[PersonOfInterest] S WITH(NOLOCK) WHERE S.Id <> @Id AND S.Deleted = 0 AND @Email IS NOT NULL AND S.Email = @Email)
    END

	SET @MaxPersonsOfInterestCount = (SELECT PC.[Value] FROM [dbo].[PackageConfigurationTranslated] PC WITH(NOLOCK) WHERE PC.Id = 1)
	SET @PersonsOfInterestCount = (SELECT Count(1) FROM	[dbo].[AvailablePersonOfInterest] A
									WHERE	NOT EXISTS (SELECT 1 FROM [dbo].[User] WITH(NOLOCK) WHERE [SuperAdmin] = 1 AND [IdPersonOfInterest] IS NOT NULL)
											OR [Id] NOT IN (SELECT [IdPersonOfInterest] FROM [dbo].[User] WITH(NOLOCK) WHERE [SuperAdmin] = 1))
	SET @ExistingStatus = (SELECT [Status] FROM [dbo].[PersonOfInterest] S WITH(NOLOCK) WHERE [Id] = @Id)

	IF @ExistingMobilePhoneNumber IS NULL AND @ExistingMobileIMEI IS NULL AND @ExistingIdentifier IS NULL AND @ExistingEmail IS NULL
		BEGIN

			IF @ExistingStatus = 'D' AND @Status = 'H' --Estoy activando uno que estaba deshabilitado. Tengo que revisar licencias
			BEGIN
				IF @PersonsOfInterestCount >= @MaxPersonsOfInterestCount
				BEGIN
					SET @LicencesAllowed = 0			
					SET @Result = -1
					SET @ResultMessage = (SELECT CONVERT([sys].[varchar], PC.Value) AS ErrorMessage 
											FROM [dbo].[PackageConfigurationTranslated] PC WITH(NOLOCK) WHERE PC.Id = 1)
				END
			END
			IF @LicencesAllowed = 1
			BEGIN
				UPDATE	[dbo].[PersonOfInterest]
				SET		 [Name] = @Name
						,[LastName] = @LastName
						,[Identifier] = @Identifier
						,[MobilePhoneNumber] = @MobilePhoneNumber
						,[MobileIMEI] = @MobileIMEI
						,[Status] = @Status
						,[Type] = @Type
						,[IdDepartment] = @IdDepartment
						,[Pin] = CASE WHEN @Pin IS NOT NULL THEN @Pin ELSE [Pin] END
						,[PinDate] = CASE WHEN @Pin IS NOT NULL AND ([Pin] IS NULL OR [Pin] <> @Pin) THEN GETUTCDATE() ELSE [PinDate] END
						,[Email] = @Email
						,[Pending] = 0
				WHERE	[Id] = @Id

				IF @UpdateAvatar = 1
				BEGIN
					UPDATE [dbo].[PersonOfInterest]
					SET [Avatar] = @Avatar
					WHERE [Id] = @Id
				END

				SET @Result = 0

				IF @DeviceId = 0
				BEGIN
					UPDATE	[dbo].[PersonOfInterest]
					SET [DeviceId] = NULL
					WHERE	[Id] = @Id

					SET @Result = 0
				END

				IF @Pin IS NOT NULL
				BEGIN
					DECLARE @StoredProcedureText [sys].[varchar](5000)
					SET @StoredProcedureText = dbo.GetCommonTextTranslated('Controller_StoredProcedure')

					INSERT INTO dbo.AuditLog
					        ( IdUser ,
					          Date ,
					          Entity ,
					          Action ,
					          ControllerName ,
					          ActionName ,
					          ResultData
					        )
					VALUES  ( @IdUser , -- IdUser - int
					          GETUTCDATE() , -- Date - datetime
					          44 , -- Entity - int
					          2 , -- Action - int
					          @StoredProcedureText , -- ControllerName - varchar(50)
					          'UpdatePersonPin' , -- ActionName - varchar(100)
					          NULL  -- ResultData - varchar(max)
					        )
				END

				DELETE FROM [dbo].[PersonCustomAttributeValue] WHERE [IdPersonOfInterest] IN (SELECT DISTINCT [Id] FROM PersonOfInterest peoi INNER JOIN @DataAttributeValues pcav on peoi.[Identifier] = pcav.[PersonOfInterestIdentifier])
				INSERT INTO [dbo].[PersonCustomAttributeValue] ([IdPersonCustomAttribute], [Value], [IdPersonOfInterest])
				SELECT pcav.[IdPersonCustomAttribute], pcav.[Value], pr.[Id]
				FROM @DataAttributeValues pcav
				INNER JOIN [dbo].[PersonOfInterest] pr ON pcav.[PersonOfInterestIdentifier] = pr.[Identifier]
			END
		END
	ELSE
	BEGIN
		SET @Result  = 0
		IF @ExistingIdentifier IS NOT NULL
		BEGIN
			SET @Result  = @Result + 1
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
