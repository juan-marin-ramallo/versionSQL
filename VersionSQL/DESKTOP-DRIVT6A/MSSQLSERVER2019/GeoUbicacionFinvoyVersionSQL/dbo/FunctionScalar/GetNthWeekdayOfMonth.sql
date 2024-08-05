/****** Object:  ScalarFunction [dbo].[GetNthWeekdayOfMonth]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 30/06/2015
-- Description:	Devuelve la fecha para el enesimo dia de la semana de un mes. Por ejemplo para el mes 12 cuando cae el segundo lunes.
-- =============================================
CREATE FUNCTION [dbo].[GetNthWeekdayOfMonth]
(
    @TheDate DATETIME,
    @TheWeekday TINYINT,
    @TheNth SMALLINT
)
RETURNS DATETIME
AS
BEGIN
    RETURN  (
        SELECT  theDate + DATEADD(DAY, DATEDIFF(DAY, @theDate, 0), @theDate)
        FROM    (
                SELECT  DATEADD(DAY, 7 * @TheNth - 7 * SIGN(SIGN(@TheNth) + 1) +(@TheWeekday + 6 - DATEDIFF(DAY, '17530101',
				 DATEADD(MONTH, DATEDIFF(MONTH, @TheNth, @TheDate), '19000101')) % 7) % 7, DATEADD(MONTH, DATEDIFF(MONTH, @TheNth, @TheDate), '19000101')) AS TheDate
                WHERE   @TheWeekday BETWEEN 1 AND 7
                        AND @TheNth IN (-5, -4, -3, -2, -1, 1, 2, 3, 4, 5)
                ) AS d
        WHERE   DATEDIFF(MONTH, TheDate, @TheDate) = 0
        )
END
