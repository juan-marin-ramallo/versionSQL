/****** Object:  Procedure [dbo].[SavePersonOfInterestFromMobile]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 20/11/2017
-- Description:	SP para guardar una persona de interes desde mobile
-- =============================================
CREATE PROCEDURE [dbo].[SavePersonOfInterestFromMobile]
(
	 @Id [sys].[int] OUTPUT
	,@Name [sys].[varchar](50)
	,@LastName [sys].[varchar](50)
	,@Identifier [sys].[varchar](20) = NULL
	,@MobilePhoneNumber [sys].[varchar](20) = NULL
	,@MobileIMEI [sys].[varchar](40) = NULL
	,@Status [sys].[char](1)
	,@Type [sys].[char](1) = NULL
	,@IdDepartment [sys].[int] = NULL
	,@Pending [sys].[bit] = 0
	,@MobileMAC [sys].[varchar](40) = NULL
	,@Email [sys].[VARCHAR](255) = NULL
	,@Result [sys].[smallint] OUTPUT
	,@ResultMessage [sys].[varchar](200) OUTPUT
)
AS
BEGIN
	DECLARE @MaxPersonsOfInterestCount [sys].[int]
	DECLARE @PersonsOfInterestCount [sys].[int]
	DECLARE @ExistingMobilePhoneNumber [sys].[varchar](20)
	DECLARE @ExistingIdentifier [sys].[varchar](20)
	DECLARE @ExistingMobileIMEI [sys].[varchar](40)
	
	SET @MaxPersonsOfInterestCount = (SELECT PC.[Value] FROM [dbo].[PackageConfigurationTranslated] PC WITH(NOLOCK) WHERE PC.Id = 1)
	SET @PersonsOfInterestCount = (SELECT Count(1) FROM	[dbo].[AvailablePersonOfInterest] A
									WHERE	NOT EXISTS (SELECT 1 FROM [dbo].[User] WITH(NOLOCK) WHERE [SuperAdmin] = 1 AND [IdPersonOfInterest] IS NOT NULL)
											OR [Id] NOT IN (SELECT [IdPersonOfInterest] FROM [dbo].[User] WITH(NOLOCK) WHERE [SuperAdmin] = 1))
	

	--Si está configurado para usar MAC tengo que guardar la MAC en lugar del IMEI
	IF EXISTS (SELECT 1 FROM [dbo].[ConfigurationTranslated] C WITH(NOLOCK) WHERE C.[Id] = 1053 AND C.[Value] = '1')
	BEGIN
		--Se usa MAC
		SET @MobileIMEI = @MobileMAC
	END


	IF @PersonsOfInterestCount < @MaxPersonsOfInterestCount
		BEGIN
			SET @ExistingMobilePhoneNumber = (SELECT S.MobilePhoneNumber FROM [dbo].[PersonOfInterest] S WITH(NOLOCK) WHERE S.Deleted = 0 AND S.MobilePhoneNumber = @MobilePhoneNumber)
			SET @ExistingMobileIMEI = (SELECT S.MobileIMEI FROM [dbo].[PersonOfInterest] S WITH(NOLOCK) WHERE S.Deleted = 0 AND S.MobileIMEI = @MobileIMEI)
			SET @ExistingIdentifier = (SELECT S.Identifier FROM [dbo].[PersonOfInterest] S WITH(NOLOCK) WHERE S.Deleted = 0 AND S.Identifier = @Identifier)
	
			IF @ExistingMobilePhoneNumber IS NULL AND @ExistingMobileIMEI IS NULL AND @ExistingIdentifier IS NULL
				BEGIN
					INSERT INTO [dbo].[PersonOfInterest]([Name], [LastName], [Identifier], [MobilePhoneNumber], [MobileIMEI], [Status], [Type], [IdDepartment], [Email], [Deleted], [Pending])
					VALUES (@Name, @LastName, @Identifier, @MobilePhoneNumber, @MobileIMEI, @Status, @Type, @IdDepartment, @Email, 0, @Pending)
			
					SELECT @Id = SCOPE_IDENTITY()
					SET @Result = 1

					INSERT INTO dbo.PersonOfInterestZone
					SELECT @Id, Z.[Id]
					FROM [dbo].[ZoneTranslated] Z WITH (NOLOCK)
					WHERE Z.[ApplyToAllPersonOfInterest]= 1
				END
			ELSE IF @ExistingMobilePhoneNumber = @MobilePhoneNumber AND @ExistingMobileIMEI = @MobileIMEI
				BEGIN
					SET @Result = 2
				END
			ELSE IF @ExistingMobilePhoneNumber = @MobilePhoneNumber
				BEGIN
					SET @Result = 3
				END
			ELSE IF @ExistingMobileIMEI = @MobileIMEI
				BEGIN
					SET @Result = 4
				END
			ELSE IF @ExistingIdentifier = @Identifier
				BEGIN
					SET @Result = 5
				END
		END
	ELSE
		BEGIN
			SET @Result = -1
			SET @ResultMessage = (SELECT CONVERT([sys].[varchar], PC.Value) AS ErrorMessage 
									FROM [dbo].[PackageConfigurationTranslated] PC WITH(NOLOCK) WHERE PC.Id = 1)
		END


END
