/****** Object:  ScalarFunction [dbo].[CheckCharValueInList]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 08/02/2013
-- Description:	Función para verificar si un valor de tipo char está comprendido dentro de una lista de opciones
-- =============================================
CREATE FUNCTION [dbo].[CheckCharValueInList] 
(
	 @Value [sys].[char]
	,@Choices [sys].[varchar](MAX) = NULL
)
RETURNS [sys].[bit]
AS
BEGIN
	DECLARE @Result [sys].[bit]
	SET @Result = 0

	IF CHARINDEX(',' + CAST(@Value AS [sys].[varchar](10)) + ',', @Choices) > 0
	BEGIN
		SET @Result = 1
	END

	RETURN @Result
END
