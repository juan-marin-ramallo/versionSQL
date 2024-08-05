/****** Object:  Procedure [dbo].[LoginMobile]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Juan Sobral
-- Create date: 10/03/2014
-- Description:	SP para login de mobile
-- =============================================
CREATE PROCEDURE [dbo].[LoginMobile]
(
	 @Imei [sys].[varchar](40) = NULL,
	 @Mac [sys].[varchar](40) = NULL,
	 @SystemDateTime [sys].[DateTime] OUT,
	 @PersonOfInterestFullName [sys].[varchar](150) OUT,
	 @Result [sys].[smallint] OUT,
	 @Pin [sys].[varchar](4) OUT,
	 @PinDate [sys].[DateTime] OUT
)
AS

BEGIN
	DECLARE @PersonOfInterestId [sys].[INT]
    SET @PersonOfInterestId = NULL
	SET @PersonOfInterestFullName = NULL
	SET @Pin = NULL
	SET @PinDate = NULL

    DECLARE @Status [sys].[char](1)
    SET @Status = NULL
    DECLARE @Pending [sys].[bit]
    SET @Pending = NULL


	SELECT	TOP 1 @PersonOfInterestId = Id, @PersonOfInterestFullName = CONCAT([Name],' ',[LastName], '-', [Identifier])
							, @Pin = Pin, @PinDate = PinDate, @Status = [Status], @Pending = [Pending]
	FROM	[dbo].[PersonOfInterest] WITH (NOLOCK)
	WHERE	(([MobileIMEI] LIKE '%' + @Imei + '%' OR [MobileIMEI] LIKE '%' + @Mac + '%' ) AND
				--[Status] = 'H'AND
				[Deleted] = 0 )
				AND NOT EXISTS (SELECT 1 FROM [dbo].[CustomerValidation] WITH (NOLOCK) WHERE [BlockedMobile] = 1)	

	IF @PersonOfInterestId IS NULL -- Does not exist
	BEGIN
		SET @Result = 1
	END
    ELSE IF @Status <> 'H' OR @Pending = 1 -- Inactive
    BEGIN
        SET @Result = 2
    END
	ELSE 
	BEGIN
		-- DECLARE @IsEnabled bit = (SELECT CAST(
		-- 	CASE WHEN EXISTS(SELECT 1 FROM PersonOfInterest WITH (NOLOCK) WHERE Id = @PersonOfInterestId AND [Status] = 'H') 
		-- 	THEN 1 ELSE 0 END AS BIT))

		-- IF @IsEnabled = 1
		-- BEGIN 
			SET @SystemDateTime = GETUTCDATE()
			SET @Result = 0
			SELECT @PersonOfInterestId
		-- END
		-- ELSE
		-- BEGIN
		-- 	SET @Result = 2
		-- END
	END
END
