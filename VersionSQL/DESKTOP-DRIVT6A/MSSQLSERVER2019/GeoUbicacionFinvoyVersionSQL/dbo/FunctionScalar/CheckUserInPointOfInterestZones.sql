/****** Object:  ScalarFunction [dbo].[CheckUserInPointOfInterestZones]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE FUNCTION [dbo].[CheckUserInPointOfInterestZones] 
(
@IdPointOfInterest [sys].[int]
,@IdUser [sys].[int]
)
RETURNS [sys].[bit]
AS
BEGIN
DECLARE @Result [sys].[bit]
SET @Result = 1

IF EXISTS (SELECT 1 FROM [dbo].[PointOfInterestZone] WITH (NOLOCK) WHERE [IdPointOfInterest] = @IdPointOfInterest)
BEGIN
IF  EXISTS (SELECT 1 FROM [dbo].[UserZone] WITH (NOLOCK) WHERE [IdUser] = @IdUser)
BEGIN
IF NOT Exists (SELECT 1 FROM [dbo].[PointOfInterestZone] PZ WITH (NOLOCK) INNER JOIN [dbo].[UserZone] UZ WITH (NOLOCK) ON PZ.[IdZone] = UZ.[IdZone] WHERE PZ.[IdPointOfInterest] = @IdPointOfInterest AND UZ.[IdUser] = @IdUser)
BEGIN
SET @Result = 0
END
END
--ELSE
--BEGIN
--	SET @Result = 0
--END
END

RETURN @Result
END
