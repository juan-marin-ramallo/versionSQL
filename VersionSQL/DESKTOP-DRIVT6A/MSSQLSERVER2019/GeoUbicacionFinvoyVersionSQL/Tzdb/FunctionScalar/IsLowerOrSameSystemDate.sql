/****** Object:  ScalarFunction [Tzdb].[IsLowerOrSameSystemDate]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE   FUNCTION [Tzdb].[IsLowerOrSameSystemDate]
(
     @first DATETIME2
	,@second DATETIME2
)
RETURNS [sys].[bit]
AS
BEGIN
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

	RETURN CASE WHEN @firstSystem <= @secondSystem THEN 1 ELSE 0 END
END

-- OLD)
--BEGIN
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

--	RETURN CASE WHEN @firstSystem <= @secondSystem THEN 1 ELSE 0 END
--END
