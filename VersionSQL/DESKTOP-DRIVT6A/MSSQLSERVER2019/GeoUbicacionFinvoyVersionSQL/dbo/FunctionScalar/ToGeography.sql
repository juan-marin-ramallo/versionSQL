/****** Object:  ScalarFunction [dbo].[ToGeography]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 29/11/2013
-- Description:	Función para obtener una coordenada en formato Geography
-- =============================================
CREATE FUNCTION [dbo].[ToGeography]
(
	@lat [sys].decimal(25,20),
	@lng [sys].decimal(25,20)
)
RETURNS [sys].[geography]
AS
BEGIN
	RETURN GEOGRAPHY::STPointFromText('POINT(' + CAST(@lng AS VARCHAR(25)) + ' ' + CAST(@lat AS VARCHAR(25)) + ')', 4326)
END
