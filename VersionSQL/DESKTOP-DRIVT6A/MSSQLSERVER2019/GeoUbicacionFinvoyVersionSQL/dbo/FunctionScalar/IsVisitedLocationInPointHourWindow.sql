/****** Object:  ScalarFunction [dbo].[IsVisitedLocationInPointHourWindow]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[IsVisitedLocationInPointHourWindow] 
(
	 @IdPointOfInterest int
	,@LocationInDate datetime
	,@LocationOutDate datetime
)
RETURNS bit
AS
BEGIN
	DECLARE @LocationInDateSystem [sys].[datetime]
    DECLARE @LocationOutDateSystem [sys].[datetime]
    
	DECLARE @LocationInDateSystemTime [sys].[time]
    DECLARE @LocationOutDateSystemTime [sys].[TIME]
    
	SET @LocationInDateSystem = Tzdb.FromUtc(@LocationInDate)
	SET @LocationOutDateSystem = Tzdb.FromUtc(@LocationOutDate)
    
	SET @LocationInDateSystemTime = CAST(@LocationInDateSystem AS [sys].[time])
	SET @LocationOutDateSystemTime = CAST(@LocationOutDateSystem AS [sys].[time])

	DECLARE @IsInHourWindow bit = 0 
	
	IF [dbo].GetConfigurationUseHoursWindow() = 0 
			OR (NOT EXISTS 
				(SELECT 1
					FROM [dbo].[PointOfInterestHourWindow] HW WITH (NOLOCK)
					WHERE HW.[IdPointOfInterest] = @IdPointOfInterest)							
			OR
			EXISTS 
				(SELECT 1
					FROM [dbo].[PointOfInterestHourWindow] HW WITH (NOLOCK)
					WHERE HW.[IdPointOfInterest] = @IdPointOfInterest
					AND DATEPART(WEEKDAY, @LocationInDateSystem) = HW.[IdDayOfWeek]
					AND ((@LocationInDateSystemTime < HW.[FromHour] AND @LocationOutDateSystemTime > HW.[FromHour])
						OR (@LocationInDateSystemTime > HW.[FromHour] AND @LocationInDateSystemTime < HW.[ToHour])))
			)
		
	BEGIN
		SET @IsInHourWindow = 1
	END
	ELSE
	BEGIN
		SET @IsInHourWindow = 0
	END				 

	--SELECT @IsInHourWindow = 
	--CASE WHEN 
	--	([dbo].GetConfigurationUseHoursWindow() = 0 
	--		OR (NOT EXISTS 
	--			(SELECT 1
	--				FROM [dbo].[PointOfInterestHourWindow] HW
	--				WHERE HW.[IdPointOfInterest] = @IdPointOfInterest)							
	--		OR
	--		EXISTS 
	--			(SELECT 1
	--				FROM [dbo].[PointOfInterestHourWindow] HW
	--				WHERE HW.[IdPointOfInterest] = @IdPointOfInterest
	--				AND DATEPART(WEEKDAY, @LocationInDate) = HW.[IdDayOfWeek]
	--				AND ((CAST(@LocationInDate AS TIME) < HW.[FromHour] AND CAST(@LocationOutDate AS TIME) > HW.[FromHour])
	--					OR (CAST(@LocationInDate AS TIME) > HW.[FromHour] AND CAST(@LocationInDate AS TIME) < HW.[ToHour])))
	--		)
	--	)					
	--	THEN CAST(1 AS BIT) 
	--	ELSE CAST(0 AS BIT) 
	--END

	RETURN @IsInHourWindow
END
