/****** Object:  Procedure [dbo].[GetPin]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE  PROCEDURE [dbo].[GetPin]
(
	 @Imei [sys].[varchar](40),
	 @Mac [sys].[varchar](40) = NULL,
	 @Result [sys].[smallint] OUT,
	 @Pin [sys].[varchar](4) OUT,
	 @PinDate [sys].[DateTime] OUT
)
AS

BEGIN
	DECLARE @PersonOfInterestId [sys].[INT]
    SET @PersonOfInterestId = NULL
	SET @Pin = NULL
	SET @PinDate = NULL

	SELECT	TOP 1 @PersonOfInterestId = Id, @Pin = Pin, @PinDate = PinDate
	FROM	[dbo].[PersonOfInterest] WITH (NOLOCK)
	WHERE	(([MobileIMEI] LIKE '%' + @Imei + '%' OR [MobileIMEI] LIKE '%' + @Mac + '%' ) AND
				[Status] = 'H' AND
				[Deleted] = 0 AND
				[Pending] = 0 )

	IF @PersonOfInterestId IS NULL
	BEGIN
		SET @Result = 1
	END
	ELSE 
	BEGIN 
		SET @Result = 0
	END

END
