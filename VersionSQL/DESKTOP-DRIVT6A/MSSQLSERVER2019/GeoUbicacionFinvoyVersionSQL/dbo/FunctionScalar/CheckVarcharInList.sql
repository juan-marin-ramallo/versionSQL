/****** Object:  ScalarFunction [dbo].[CheckVarcharInList]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 06/11/2013
-- Description:	Función para verificar si un valor está comprendido dentro de una lista de opciones
-- =============================================
CREATE FUNCTION [dbo].[CheckVarcharInList] 
(
	 @Value [sys].[varchar](MAX)
	,@Choices [sys].[varchar](MAX) = NULL
)
RETURNS [sys].[bit]
AS
BEGIN
	DECLARE @Result [sys].[bit]
	SET @Result = 0

	IF CHARINDEX(',' + @Value + ',', @Choices) > 0
	BEGIN
		SET @Result = 1
	END

	RETURN @Result
END
