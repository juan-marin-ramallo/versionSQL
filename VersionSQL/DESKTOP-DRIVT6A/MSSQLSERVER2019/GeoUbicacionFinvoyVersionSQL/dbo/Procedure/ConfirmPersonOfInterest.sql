/****** Object:  Procedure [dbo].[ConfirmPersonOfInterest]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 08/11/2013
-- Description:	SP para confirmar una persona de interes
-- =============================================
CREATE PROCEDURE [dbo].[ConfirmPersonOfInterest]
(
	 @Id [sys].[int]
	,@Name [sys].[varchar](50)
	,@LastName [sys].[varchar](50)
	,@Identifier [sys].[varchar](20)
	,@MobilePhoneNumber [sys].[varchar](20) = NULL
	,@MobileIMEI [sys].[varchar](40)
	,@Status [sys].[char](1)
	,@Type [sys].[char](1) = NULL
	,@IdDepartment [sys].[int] = NULL
	,@Result [sys].[smallint] OUTPUT
)
AS
BEGIN
	DECLARE @ExistingMobilePhoneNumber [sys].[varchar](20)
	DECLARE @ExistingMobileIMEI [sys].[varchar](40)
	
	SET @ExistingMobilePhoneNumber = (SELECT S.MobilePhoneNumber FROM [dbo].[PersonOfInterest] S WHERE S.Id <> @Id AND S.Deleted = 0 AND S.MobilePhoneNumber = @MobilePhoneNumber)
	SET @ExistingMobileIMEI = (SELECT S.MobileIMEI FROM [dbo].[PersonOfInterest] S WHERE S.Id <> @Id AND S.Deleted = 0 AND S.MobileIMEI LIKE '%' + @MobileIMEI + '%')
	
	IF @ExistingMobilePhoneNumber IS NULL AND @ExistingMobileIMEI IS NULL
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
					,[Pending] = 0
			WHERE	[Id] = @Id
			
			SET @Result = 1
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
END
