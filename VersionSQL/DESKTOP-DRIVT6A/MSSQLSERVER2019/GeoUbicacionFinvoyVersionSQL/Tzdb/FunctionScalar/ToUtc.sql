/****** Object:  ScalarFunction [Tzdb].[ToUtc]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE   FUNCTION [Tzdb].[ToUtc]
(
    @local DATETIME2
)
RETURNS DATETIME
AS
BEGIN
    DECLARE @Result DATETIME

    IF @local = '9999-12-31 23:59:59.9966667' OR @local = '9999-12-31 23:59:59.997'
    BEGIN
        SET @Result = @local
    END
    ELSE
    BEGIN
        DECLARE @OffsetMinutes INT

        SELECT TOP 1 @OffsetMinutes = [OffsetMinutes]
        FROM [dbo].[SystemTimeZoneDetail] WITH (NOLOCK)
        WHERE [LocalStart] <= @local AND [LocalEnd] > @local
        ORDER BY [UtcStart]

        IF @OffsetMinutes IS NULL
        BEGIN
            DECLARE @tz [sys].[varchar](50)
            SET @tz = [dbo].[GetSystemTimeZone]()

            SET @local = DATEADD(MINUTE, CASE @tz WHEN 'Australia/Lord_Howe' THEN 30 ELSE 60 END, @local)
            SELECT TOP 1 @OffsetMinutes = [OffsetMinutes]
            FROM [dbo].[SystemTimeZoneDetail] WITH (NOLOCK)
            WHERE [LocalStart] <= @local AND [LocalEnd] > @local
        END

        SET @Result = TODATETIMEOFFSET(DATEADD(MINUTE, -@OffsetMinutes, @local), 0)
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
--    FROM [Tzdb].[Intervals]
--    WHERE [ZoneId] = @ZoneId
--        AND [LocalStart] <= @local AND [LocalEnd] > @local
--    ORDER BY [UtcStart]

--    IF @OffsetMinutes IS NULL
--    BEGIN
--        SET @local = DATEADD(MINUTE, CASE @tz WHEN 'Australia/Lord_Howe' THEN 30 ELSE 60 END, @local)
--        SELECT TOP 1 @OffsetMinutes = [OffsetMinutes]
--        FROM [Tzdb].[Intervals]
--        WHERE [ZoneId] = @ZoneId
--          AND [LocalStart] <= @local AND [LocalEnd] > @local
--    END

--    RETURN TODATETIMEOFFSET(DATEADD(MINUTE, -@OffsetMinutes, @local), 0)
--END
