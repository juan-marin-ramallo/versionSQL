/****** Object:  ScalarFunction [dbo].[RoundDateTime]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 19/03/2013
-- Description:	Función para redondear una fecha/hora en segundos
-- =============================================
CREATE FUNCTION [dbo].[RoundDateTime] 
(
	@DateTimeValue [sys].[datetime]
)
RETURNS [sys].[datetime]
AS
BEGIN
	RETURN DATEADD(MI, DATEDIFF(MI, 0, DATEADD(S, 30, @DateTimeValue)), 0)
END
