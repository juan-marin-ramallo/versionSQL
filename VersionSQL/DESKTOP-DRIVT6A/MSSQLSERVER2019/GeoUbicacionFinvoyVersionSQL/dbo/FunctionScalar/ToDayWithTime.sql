/****** Object:  ScalarFunction [dbo].[ToDayWithTime]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 27/03/2013
-- Description:	Función para obtener un día y hora en formato corto
-- =============================================
CREATE FUNCTION [dbo].[ToDayWithTime]
(
	@Seconds [sys].[int]
)
RETURNS [sys].[varchar](20)
AS
BEGIN
	RETURN CAST(@Seconds / (24 * 60 * 60) AS [sys].[varchar](10)) + 'd ' + CONVERT([sys].[varchar], DATEADD(SS, @Seconds, 0), 108)
END
