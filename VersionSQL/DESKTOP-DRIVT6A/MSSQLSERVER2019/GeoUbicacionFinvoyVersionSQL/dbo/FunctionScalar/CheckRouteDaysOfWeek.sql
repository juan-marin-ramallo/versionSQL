/****** Object:  ScalarFunction [dbo].[CheckRouteDaysOfWeek]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 23/06/2015
-- Description:	Función para verificar si los dias seleccionados est[an entre los d[ias marcados para la ruta
-- =============================================
CREATE FUNCTION [dbo].[CheckRouteDaysOfWeek] 
(
	 @IdRoutePointOfInterest [sys].[int]
	,@DaysOfWeek [sys].[varchar](1000) = NULL
)
RETURNS [sys].[bit]
AS
BEGIN
	DECLARE @Result [sys].[BIT]
    DECLARE @Rows [sys].[int]
	SET @Result = 1

	IF NOT EXISTS (SELECT 1	FROM dbo.[RouteDayOfWeek] r WITH (NOLOCK) WHERE r.[IdRoutePointOfInterest] = @IdRoutePointOfInterest AND dbo.CheckValueInList(r.[DayOfWeek], @DaysOfWeek) = 1)
	BEGIN
		SET @Result = 0
    END

	RETURN @Result
END
