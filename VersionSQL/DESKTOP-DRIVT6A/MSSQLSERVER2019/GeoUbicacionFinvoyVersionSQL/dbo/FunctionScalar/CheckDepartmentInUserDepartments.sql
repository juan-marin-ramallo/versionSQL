/****** Object:  ScalarFunction [dbo].[CheckDepartmentInUserDepartments]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 07/01/2013
-- Description:	Función para verificar si un departamento está comprendido dentro de los departamentos del usuario
-- =============================================
CREATE FUNCTION [dbo].[CheckDepartmentInUserDepartments] 
(
	 @IdDepartment [sys].[int]
	,@IdUser [sys].[int]
)
RETURNS [sys].[bit]
AS
BEGIN
	DECLARE @Result [sys].[bit]
	SET @Result = 1

	IF EXISTS (SELECT 1 FROM [dbo].[UserDepartment] WITH (NOLOCK) WHERE [IdUser] = @IdUser)
	BEGIN
		IF @IdDepartment IS NOT NULL
		BEGIN
			IF @IdDepartment NOT IN (SELECT [IdDepartment] FROM [dbo].[UserDepartment] WITH (NOLOCK) WHERE [IdUser] = @IdUser)
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
