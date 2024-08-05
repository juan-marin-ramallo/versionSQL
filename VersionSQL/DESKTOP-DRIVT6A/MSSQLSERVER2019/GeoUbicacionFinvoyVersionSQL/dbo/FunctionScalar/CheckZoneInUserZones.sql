/****** Object:  ScalarFunction [dbo].[CheckZoneInUserZones]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 11/08/2014
-- Description:	Función para verificar si una zona está comprendida dentro de las zonas del usuario
-- =============================================
CREATE FUNCTION [dbo].[CheckZoneInUserZones] 
(
	 @IdZone [sys].[int]
	,@IdUser [sys].[int]
)
RETURNS [sys].[bit]
AS
BEGIN
	DECLARE @Result [sys].[bit]
	SET @Result = 1

	IF EXISTS (SELECT 1 FROM [dbo].[UserZone] WITH (NOLOCK) WHERE [IdUser] = @IdUser)
	BEGIN
		IF @IdZone IS NOT NULL
		BEGIN
			IF @IdZone NOT IN (SELECT [IdZone] FROM [dbo].[UserZone] WITH (NOLOCK) WHERE [IdUser] = @IdUser)
			BEGIN
				SET @Result = 0
			END
		END
		--ELSE
		--BEGIN
		--	SET @Result = 0
		--END
	END

	RETURN @Result
END
