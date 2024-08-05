/****** Object:  ScalarFunction [dbo].[CheckUserInPersonOfInterestZones]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE FUNCTION [dbo].[CheckUserInPersonOfInterestZones] 
(
	 @IdPersonOfInterest [sys].[int]
	,@IdUser [sys].[int]
)
RETURNS [sys].[bit]
AS
BEGIN

	DECLARE @Result [sys].[bit]
	SET @Result = 1
	
	DECLARE @IdPersonOfUserLocal [sys].[INT]
	SET     @IdPersonOfUserLocal = (SELECT [IdPersonOfInterest] 
									FROM dbo.[User] WITH (NOLOCK) 
									WHERE [Id] = @IdUser)
	
	IF @IdPersonOfUserLocal IS NULL OR @IdPersonOfUserLocal <> @IdPersonOfInterest
	BEGIN
		IF EXISTS (SELECT 1 
			       FROM [dbo].[PersonOfInterestZone] WITH (NOLOCK) 
				   WHERE [IdPersonOfInterest] = @IdPersonOfInterest)
		BEGIN
			IF  EXISTS (SELECT 1 
						FROM [dbo].[UserZone] WITH (NOLOCK) 
						WHERE [IdUser] = @IdUser)
			BEGIN
				IF NOT EXISTS (SELECT 1 
							   FROM [dbo].[PersonOfInterestZone] PZ WITH (NOLOCK) 
							   INNER JOIN [dbo].[UserZone] UZ WITH (NOLOCK) ON PZ.[IdZone] = UZ.[IdZone] 
							   WHERE PZ.[IdPersonOfInterest] = @IdPersonOfInterest AND UZ.[IdUser] = @IdUser)
				BEGIN
					SET @Result = 0
				END
			END
		END
	END

	RETURN @Result

END
