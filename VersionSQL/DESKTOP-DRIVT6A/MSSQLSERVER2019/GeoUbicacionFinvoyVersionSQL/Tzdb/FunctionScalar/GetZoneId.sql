/****** Object:  ScalarFunction [Tzdb].[GetZoneId]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE FUNCTION [Tzdb].[GetZoneId]
(
    @tz varchar(50)
)
RETURNS int
AS
BEGIN
    DECLARE @ZoneId int

    SELECT TOP 1 @ZoneId = l.[CanonicalZoneId]
    FROM [Tzdb].[Zones] z WITH (NOLOCK)
    JOIN [Tzdb].[Links] l WITH (NOLOCK) on z.[Id] = l.[LinkZoneId]
    WHERE z.[Name] = @tz

    IF @ZoneId IS NULL
    SELECT TOP 1 @ZoneId = [Id]
    FROM [Tzdb].[Zones] WITH (NOLOCK)
    WHERE [Name] = @tz

    RETURN @ZoneId
END
