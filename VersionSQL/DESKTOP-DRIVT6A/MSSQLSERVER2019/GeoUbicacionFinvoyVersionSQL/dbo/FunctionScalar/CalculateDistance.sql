/****** Object:  ScalarFunction [dbo].[CalculateDistance]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 29/11/2013
-- Description:	Función para calcular la distancia entre dos coordenadas
-- =============================================
CREATE FUNCTION [dbo].[CalculateDistance]
(
	@lat1 [sys].decimal(25,20),
	@lng1 [sys].decimal(25,20),
	@lat2 [sys].decimal(25,20),
	@lng2 [sys].decimal(25,20)
)
RETURNS [sys].[float]
AS
BEGIN
	RETURN [dbo].[ToGeography](@lat1, @lng1).STDistance([dbo].[ToGeography](@lat2, @lng2))
END
