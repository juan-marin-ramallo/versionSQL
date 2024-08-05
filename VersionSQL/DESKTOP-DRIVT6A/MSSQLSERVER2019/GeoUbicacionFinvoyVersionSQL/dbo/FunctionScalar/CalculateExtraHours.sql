/****** Object:  ScalarFunction [dbo].[CalculateExtraHours]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 26/03/2013
-- Description:	Función para calcular las horas extras de una persona de interés
-- =============================================
CREATE FUNCTION [dbo].[CalculateExtraHours]
(
	 @EntryTime [sys].[datetime] = NULL
--	,@RestEntryTime [sys].[datetime] = NULL
--	,@RestExitTime [sys].[datetime] = NULL
	,@ExitTime [sys].[datetime] = NULL
	,@WorkHours [sys].[time](7) = NULL
--	,@RestHours [sys].[time](7) = NULL
)
--RETURNS [sys].[varchar](9)
RETURNS [sys].[time](7)
AS
BEGIN
	DECLARE @Result [sys].[time](7)
	SET @Result = NULL

	IF @ExitTime IS NOT NULL AND @EntryTime IS NOT NULL
	BEGIN
		IF (@ExitTime - @EntryTime) > CAST(@WorkHours AS [sys].[datetime])
		BEGIN
			SET @Result = CAST(dbo.RoundDateTime((@ExitTime - @EntryTime) - CAST(@WorkHours AS [sys].[datetime])) AS [sys].[time](7))
		END
	END
	ELSE IF @ExitTime IS NULL AND @EntryTime IS NOT NULL AND Tzdb.AreSameSystemDates(@EntryTime, GETUTCDATE()) = 1
	BEGIN
		IF (GETUTCDATE() - @EntryTime) > CAST(@WorkHours AS [sys].[datetime])
		BEGIN
			SET @Result = CAST(dbo.RoundDateTime((GETUTCDATE() - @EntryTime) - CAST(@WorkHours AS [sys].[datetime])) AS [sys].[time](7))
		END
	END

	RETURN @Result

	--DECLARE @Result [sys].[varchar](9)
	--SET @Result = NULL

	--IF @ExitTime IS NOT NULL AND @EntryTime IS NOT NULL
	--BEGIN
	--	IF @RestExitTime IS NULL AND @RestEntryTime IS NULL
	--	BEGIN
	--		IF (@ExitTime - @EntryTime) >= CAST(@WorkHours AS [sys].[datetime])
	--		BEGIN
	--			SET @Result = dbo.ToShortTime(dbo.RoundDateTime((@ExitTime - @EntryTime) - CAST(@WorkHours AS [sys].[datetime])))
	--		END
	--		ELSE 
	--		BEGIN
	--			SET @Result = '-' + dbo.ToShortTime(dbo.RoundDateTime(CAST(@WorkHours AS [sys].[datetime]) - (@ExitTime - @EntryTime)))
	--		END
	--	END
	--	ELSE IF @RestHours IS NULL
	--	BEGIN
	--		IF (@ExitTime - @EntryTime) >= CAST(@WorkHours AS [sys].[datetime])
	--		BEGIN
	--			SET @Result = '-' + dbo.ToShortTime(dbo.RoundDateTime((@ExitTime - @EntryTime) - CAST(@WorkHours AS [sys].[datetime]) + (@RestExitTime - @RestEntryTime)))
	--		END
	--		ELSE
	--		BEGIN
	--			SET @Result = '-' + dbo.ToShortTime(dbo.RoundDateTime(CAST(@WorkHours AS [sys].[datetime]) - (@ExitTime - @EntryTime) + (@RestExitTime - @RestEntryTime)))
	--		END
	--	END
	--	ELSE IF (@RestExitTime - @RestEntryTime) >= CAST(@RestHours AS [sys].[datetime])
	--	BEGIN
	--		IF (@ExitTime - @EntryTime) >= CAST(@WorkHours AS [sys].[datetime])
	--		BEGIN
	--			IF (((@ExitTime - @EntryTime) - CAST(@WorkHours AS [sys].[datetime])) >= (@RestExitTime - @RestEntryTime - CAST(@RestHours AS [sys].[datetime])))
	--			BEGIN
	--				SET @Result = dbo.ToShortTime(dbo.RoundDateTime(((@ExitTime - @EntryTime) - CAST(@WorkHours AS [sys].[datetime])) - (@RestExitTime - @RestEntryTime - CAST(@RestHours AS [sys].[datetime]))))	
	--			END
	--			ELSE
	--			BEGIN
	--				SET @Result = '-' + dbo.ToShortTime(dbo.RoundDateTime((@RestExitTime - @RestEntryTime - CAST(@RestHours AS [sys].[datetime])) - ((@ExitTime - @EntryTime) - CAST(@WorkHours AS [sys].[datetime]))))	
	--			END
	--		END
	--		ELSE
	--		BEGIN
	--			IF ((CAST(@WorkHours AS [sys].[datetime]) - (@ExitTime - @EntryTime)) >= (@RestExitTime - @RestEntryTime - CAST(@RestHours AS [sys].[datetime])))
	--			BEGIN
	--				SET @Result = '-' + dbo.ToShortTime(dbo.RoundDateTime((CAST(@WorkHours AS [sys].[datetime]) - (@ExitTime - @EntryTime)) - (@RestExitTime - @RestEntryTime - CAST(@RestHours AS [sys].[datetime]))))
	--			END
	--			ELSE
	--			BEGIN
	--				SET @Result = '-' + dbo.ToShortTime(dbo.RoundDateTime((@RestExitTime - @RestEntryTime - CAST(@RestHours AS [sys].[datetime])) - (CAST(@WorkHours AS [sys].[datetime]) - (@ExitTime - @EntryTime))))	
	--			END
	--		END
	--	END
	--	ELSE
	--	BEGIN
	--		IF (@ExitTime - @EntryTime) >= CAST(@WorkHours AS [sys].[datetime])
	--		BEGIN
	--			SET @Result = dbo.ToShortTime(dbo.RoundDateTime((@ExitTime - @EntryTime) - CAST(@WorkHours AS [sys].[datetime])))
	--		END
	--		ELSE
	--		BEGIN
	--			SET @Result = '-' + dbo.ToShortTime(dbo.RoundDateTime(CAST(@WorkHours AS [sys].[datetime]) - (@ExitTime - @EntryTime)))
	--		END
	--	END
	--END
	--ELSE IF @ExitTime IS NULL AND @RestExitTime IS NOT NULL AND @EntryTime IS NOT NULL
	--BEGIN
	--	IF (@RestExitTime - @RestEntryTime) >= CAST(@RestHours AS [sys].[datetime])
	--	BEGIN
	--		IF (@RestExitTime - @EntryTime) >= CAST(@WorkHours AS [sys].[datetime])
	--		BEGIN
	--			IF (((@RestExitTime - @EntryTime) - CAST(@WorkHours AS [sys].[datetime])) >= (@RestExitTime - @RestEntryTime - CAST(@RestHours AS [sys].[datetime])))
	--			BEGIN
	--				SET @Result = dbo.ToShortTime(dbo.RoundDateTime(((@RestExitTime - @EntryTime) - CAST(@WorkHours AS [sys].[datetime])) - (@RestExitTime - @RestEntryTime - CAST(@RestHours AS [sys].[datetime]))))
	--			END
	--			ELSE
	--			BEGIN
	--				SET @Result = '-' + dbo.ToShortTime(dbo.RoundDateTime((@RestExitTime - @RestEntryTime - CAST(@RestHours AS [sys].[datetime])) - ((@RestExitTime - @EntryTime) - CAST(@WorkHours AS [sys].[datetime]))))
	--			END
	--		END
	--		ELSE
	--		BEGIN
	--			IF ((CAST(@WorkHours AS [sys].[datetime]) - (@RestExitTime - @EntryTime)) >= (@RestExitTime - @RestEntryTime - CAST(@RestHours AS [sys].[datetime])))
	--			BEGIN
	--				SET @Result = '-' + dbo.ToShortTime(dbo.RoundDateTime((CAST(@WorkHours AS [sys].[datetime]) - (@RestExitTime - @EntryTime)) - (@RestExitTime - @RestEntryTime - CAST(@RestHours AS [sys].[datetime]))))
	--			END
	--			ELSE
	--			BEGIN
	--				SET @Result = '-' + dbo.ToShortTime(dbo.RoundDateTime((@RestExitTime - @RestEntryTime - CAST(@RestHours AS [sys].[datetime])) - (CAST(@WorkHours AS [sys].[datetime]) - (@RestExitTime - @EntryTime))))
	--			END
	--		END
	--	END
	--	ELSE IF (@RestExitTime - @EntryTime) >= CAST(@WorkHours AS [sys].[datetime])
	--	BEGIN
	--		SET @Result = dbo.ToShortTime(dbo.RoundDateTime((@RestExitTime - @EntryTime) - CAST(@WorkHours AS [sys].[datetime])))
	--	END
	--	ELSE
	--	BEGIN
	--		SET @Result = '-' + dbo.ToShortTime(dbo.RoundDateTime(CAST(@WorkHours AS [sys].[datetime]) - (@RestExitTime - @EntryTime)))
	--	END
	--END
	--ELSE IF @ExitTime IS NULL AND @RestEntryTime IS NOT NULL AND @EntryTime IS NOT NULL
	--BEGIN
	--	IF (@RestEntryTime - @EntryTime) >= CAST(@WorkHours AS [sys].[datetime])
	--	BEGIN
	--		SET @Result = dbo.ToShortTime(dbo.RoundDateTime((@RestEntryTime - @EntryTime) - CAST(@WorkHours AS [sys].[datetime])))
	--	END
	--	ELSE
	--	BEGIN
	--		SET @Result = '-' + dbo.ToShortTime(dbo.RoundDateTime(CAST(@WorkHours AS [sys].[datetime]) - (@RestEntryTime - @EntryTime)))
	--	END
	--END

	--RETURN @Result
END
