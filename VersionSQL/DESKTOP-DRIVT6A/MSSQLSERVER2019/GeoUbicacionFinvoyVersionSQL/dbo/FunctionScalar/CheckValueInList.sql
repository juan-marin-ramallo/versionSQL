/****** Object:  ScalarFunction [dbo].[CheckValueInList]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 30/10/2012
-- Description:	Función para verificar si un valor está comprendido dentro de una lista de opciones
-- =============================================
CREATE FUNCTION [dbo].[CheckValueInList] 
(
	 @Value [sys].[int]
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
