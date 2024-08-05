/****** Object:  ScalarFunction [dbo].[GetWeekdayAndNths]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 30/06/2015
-- Description:	Devuelve para una fecha la ocurrencia de ese dia en el mes, quarter o año. Por ejemplo segundo lunes del mes correspondiente o decimo lunes del año.
-- =============================================
CREATE FUNCTION [dbo].[GetWeekdayAndNths]
(
    @TheDate DATETIME,
    @TheType CHAR(1)
)
RETURNS [sys].INT
BEGIN
RETURN (   
SELECT  1 +(theDelta - 1) / 7 AS Beginning
            FROM    (
                    SELECT CASE UPPER(@TheType)
                                WHEN 'M' THEN DATEADD(MONTH, DATEDIFF(MONTH, -53690, @TheDate), -53659)
                                WHEN 'Q' THEN DATEADD(QUARTER, DATEDIFF(QUARTER, -53690, @TheDate), -53600)
                                WHEN 'Y' THEN DATEADD(YEAR, DATEDIFF(YEAR, -53690, @TheDate), -53325)
                            END AS thePeriod,
                            CASE UPPER(@TheType)
                                WHEN 'M' THEN DATEPART(DAY, @TheDate)
                                WHEN 'Q' THEN DATEDIFF(DAY, DATEADD(QUARTER, DATEDIFF(QUARTER, 0, @TheDate), 0), DATEADD(QUARTER, DATEDIFF(QUARTER, -53690, @TheDate), -53600))
                                WHEN 'Y' THEN DATEPART(DAYOFYEAR, @TheDate)
                            END AS theDelta
                    ) AS d
            WHERE   UPPER(@theType) IN('Y', 'Q', 'M')
        )

END
