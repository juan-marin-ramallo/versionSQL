/****** Object:  ScalarFunction [dbo].[GetSystemTimeZone]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 24/01/2018
-- Description:	Función para obtener la zona horaria a utilizar en el sistema
-- =============================================
CREATE FUNCTION [dbo].[GetSystemTimeZone]()
RETURNS [sys].[varchar](50)
AS
BEGIN
	DECLARE @SystemTimeZone [sys].[varchar](50)
	SELECT @SystemTimeZone = [Value] FROM [dbo].[ConfigurationTranslated] WITH (NOLOCK) WHERE [Id] = 1070 --ZonaHorariaSistema
	
	RETURN @SystemTimeZone
END
