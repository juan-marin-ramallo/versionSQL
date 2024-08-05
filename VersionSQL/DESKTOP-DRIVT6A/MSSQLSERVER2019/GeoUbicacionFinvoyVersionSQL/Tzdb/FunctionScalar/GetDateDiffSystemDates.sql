/****** Object:  ScalarFunction [Tzdb].[GetDateDiffSystemDates]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE   FUNCTION [Tzdb].[GetDateDiffSystemDates]
(
	 @datepart VARCHAR(11)
    ,@first DATETIME2
	,@second DATETIME2
)
RETURNS [sys].[int]
AS
BEGIN
	DECLARE @Result [sys].[int]
    
	DECLARE @firstSystem [sys].[date]
	DECLARE @secondSystem [sys].[date]

	DECLARE @OffsetMinutes INT

    IF @first IS NOT NULL
	BEGIN
		IF @first = '9999-12-31 23:59:59.9966667' OR @first = '9999-12-31 23:59:59.997'
		BEGIN
			SET @firstSystem = @first
		END
		ELSE
		BEGIN
			SELECT TOP 1 @OffsetMinutes = [OffsetMinutes]
			FROM [dbo].[SystemTimeZoneDetail] WITH (NOLOCK)
			WHERE [UtcStart] <= @first AND [UtcEnd] > @first

			SET @firstSystem = TODATETIMEOFFSET(DATEADD(MINUTE, @OffsetMinutes, @first), @OffsetMinutes)
		END
	END

	IF @second IS NOT NULL
	BEGIN
		IF @second = '9999-12-31 23:59:59.9966667' OR @second = '9999-12-31 23:59:59.997'
		BEGIN
			SET @secondSystem = @second
		END
		ELSE
		BEGIN
			SELECT TOP 1 @OffsetMinutes = [OffsetMinutes]
			FROM [dbo].[SystemTimeZoneDetail] WITH (NOLOCK)
			WHERE [UtcStart] <= @second AND [UtcEnd] > @second

			SET @secondSystem = TODATETIMEOFFSET(DATEADD(MINUTE, @OffsetMinutes, @second), @OffsetMinutes)
		END
	END

	SELECT @Result = CASE
        WHEN @datepart IN ('year', 'yy', 'yyyy') THEN DATEDIFF(YEAR, @firstSystem, @secondSystem)
		WHEN @datepart IN ('quarter', 'qq', 'q') THEN DATEDIFF(QUARTER, @firstSystem, @secondSystem)
		WHEN @datepart IN ('month', 'mm', 'm') THEN DATEDIFF(MONTH, @firstSystem, @secondSystem)
		WHEN @datepart IN ('dayofyear', 'dy', '') THEN DATEDIFF(DAYOFYEAR, @firstSystem, @secondSystem)
		WHEN @datepart IN ('day', 'dd', 'd') THEN DATEDIFF(DAY, @firstSystem, @secondSystem)
		WHEN @datepart IN ('week', 'wk', 'ww') THEN DATEDIFF(WEEK, @firstSystem, @secondSystem)
		WHEN @datepart IN ('weekday', 'dw', 'w') THEN DATEDIFF(WEEKDAY, @firstSystem, @secondSystem)
		WHEN @datepart IN ('hour', 'hh') THEN DATEDIFF(HOUR, @firstSystem, @secondSystem)
		WHEN @datepart IN ('minute', 'mi', 'n') THEN DATEDIFF(MINUTE, @firstSystem, @secondSystem)
		WHEN @datepart IN ('second', 'ss', 's') THEN DATEDIFF(SECOND, @firstSystem, @secondSystem)
		WHEN @datepart IN ('millisecond', 'ms') THEN DATEDIFF(MILLISECOND, @firstSystem, @secondSystem)
		WHEN @datepart IN ('microsecond', 'mcs') THEN DATEDIFF(MICROSECOND, @firstSystem, @secondSystem)
		WHEN @datepart IN ('nanosecond', 'ns') THEN DATEDIFF(NANOSECOND, @firstSystem, @secondSystem)
    END

	RETURN @Result
END

-- OLD)
--BEGIN
--	DECLARE @Result [sys].[int]
    
--	DECLARE @tz [sys].[varchar](50)
--	SET @tz = [dbo].[GetSystemTimeZone]()

--	DECLARE @firstSystem [sys].[date]
--	DECLARE @secondSystem [sys].[date]

--	DECLARE @OffsetMinutes INT

--    DECLARE @ZoneId INT
--    SET @ZoneId = [Tzdb].GetZoneId(@tz)

--	IF @first IS NOT NULL
--	BEGIN
--		IF @first = '9999-12-31 23:59:59.9966667'
--		BEGIN
--			SET @firstSystem = @first
--		END
--		ELSE
--		BEGIN
--			SELECT TOP 1 @OffsetMinutes = [OffsetMinutes]
--			FROM [Tzdb].[Intervals] WITH (NOLOCK)
--			WHERE [ZoneId] = @ZoneId
--			  AND [UtcStart] <= @first AND [UtcEnd] > @first

--			SET @firstSystem = TODATETIMEOFFSET(DATEADD(MINUTE, @OffsetMinutes, @first), @OffsetMinutes)
--		END
--	END

--	IF @second IS NOT NULL
--	BEGIN
--		IF @second = '9999-12-31 23:59:59.9966667'
--		BEGIN
--			SET @secondSystem = @second
--		END
--		ELSE
--		BEGIN
--			SELECT TOP 1 @OffsetMinutes = [OffsetMinutes]
--			FROM [Tzdb].[Intervals] WITH (NOLOCK)
--			WHERE [ZoneId] = @ZoneId
--			  AND [UtcStart] <= @second AND [UtcEnd] > @second

--			SET @secondSystem = TODATETIMEOFFSET(DATEADD(MINUTE, @OffsetMinutes, @second), @OffsetMinutes)
--		END
--	END

--	SELECT @Result = CASE
--        WHEN @datepart IN ('year', 'yy', 'yyyy') THEN DATEDIFF(YEAR, @firstSystem, @secondSystem)
--		WHEN @datepart IN ('quarter', 'qq', 'q') THEN DATEDIFF(QUARTER, @firstSystem, @secondSystem)
--		WHEN @datepart IN ('month', 'mm', 'm') THEN DATEDIFF(MONTH, @firstSystem, @secondSystem)
--		WHEN @datepart IN ('dayofyear', 'dy', '') THEN DATEDIFF(DAYOFYEAR, @firstSystem, @secondSystem)
--		WHEN @datepart IN ('day', 'dd', 'd') THEN DATEDIFF(DAY, @firstSystem, @secondSystem)
--		WHEN @datepart IN ('week', 'wk', 'ww') THEN DATEDIFF(WEEK, @firstSystem, @secondSystem)
--		WHEN @datepart IN ('weekday', 'dw', 'w') THEN DATEDIFF(WEEKDAY, @firstSystem, @secondSystem)
--		WHEN @datepart IN ('hour', 'hh') THEN DATEDIFF(HOUR, @firstSystem, @secondSystem)
--		WHEN @datepart IN ('minute', 'mi', 'n') THEN DATEDIFF(MINUTE, @firstSystem, @secondSystem)
--		WHEN @datepart IN ('second', 'ss', 's') THEN DATEDIFF(SECOND, @firstSystem, @secondSystem)
--		WHEN @datepart IN ('millisecond', 'ms') THEN DATEDIFF(MILLISECOND, @firstSystem, @secondSystem)
--		WHEN @datepart IN ('microsecond', 'mcs') THEN DATEDIFF(MICROSECOND, @firstSystem, @secondSystem)
--		WHEN @datepart IN ('nanosecond', 'ns') THEN DATEDIFF(NANOSECOND, @firstSystem, @secondSystem)
--    END

--	RETURN @Result
--END
