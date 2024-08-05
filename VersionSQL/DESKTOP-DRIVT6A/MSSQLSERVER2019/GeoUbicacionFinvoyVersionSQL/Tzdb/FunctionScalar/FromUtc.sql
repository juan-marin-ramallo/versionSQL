/****** Object:  ScalarFunction [Tzdb].[FromUtc]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE   FUNCTION [Tzdb].[FromUtc]
(
    @utc DATETIME2
)
RETURNS DATETIME
AS
BEGIN
    DECLARE @Result DATETIME

    IF @utc = '9999-12-31 23:59:59.9966667' OR @utc = '9999-12-31 23:59:59.997'
    BEGIN
        SET @Result = @utc
    END
    ELSE
    BEGIN
        DECLARE @OffsetMinutes INT

        SELECT TOP 1 @OffsetMinutes = [OffsetMinutes]
        FROM [dbo].[SystemTimeZoneDetail] WITH (NOLOCK)
        WHERE [UtcStart] <= @utc AND [UtcEnd] > @utc

        SET @Result = TODATETIMEOFFSET(DATEADD(MINUTE, @OffsetMinutes, @utc), @OffsetMinutes)
    END

    RETURN @Result
END

-- OLD)
--BEGIN
--    DECLARE @OffsetMinutes INT

--	DECLARE @tz [sys].[varchar](50)
--	SET @tz = [dbo].[GetSystemTimeZone]()

--    DECLARE @ZoneId INT
--    SET @ZoneId = [Tzdb].GetZoneId(@tz)

--    SELECT TOP 1 @OffsetMinutes = [OffsetMinutes]
--    FROM [Tzdb].[Intervals] WITH (NOLOCK)
--    WHERE [ZoneId] = @ZoneId
--      AND [UtcStart] <= @utc AND [UtcEnd] > @utc

--    RETURN TODATETIMEOFFSET(DATEADD(MINUTE, @OffsetMinutes, @utc), @OffsetMinutes)
--END
