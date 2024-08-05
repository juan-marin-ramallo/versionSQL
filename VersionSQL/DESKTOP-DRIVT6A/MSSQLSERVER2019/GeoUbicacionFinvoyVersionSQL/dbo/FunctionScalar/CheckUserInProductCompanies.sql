/****** Object:  ScalarFunction [dbo].[CheckUserInProductCompanies]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE FUNCTION [dbo].[CheckUserInProductCompanies] 
(
 @IdProductBrand [sys].[int]
,@IdUser [sys].[int]
)
RETURNS [sys].[bit]
AS
BEGIN
	
	DECLARE @Result [sys].[bit]
	SET @Result = 1

	DECLARE @IdCompany [sys].[INT]
	SET     @IdCompany = (SELECT [IdCompany] 
								FROM dbo.[ProductBrand] WITH (NOLOCK) 
								WHERE [Id] = @IdProductBrand)

	IF EXISTS (SELECT 1 
			       FROM [dbo].[UserCompany] WITH (NOLOCK) 
				   WHERE [IdUser] = @IdUser) --Si el usuario no tiene compañias asociadas puede ver todos los productos
	BEGIN
		IF @IdCompany IS NULL --Si el usuario tiene compañias asociadas y el producto NO, no lo puedo mostrar
		BEGIN
			SET @Result = 0
		END
		ELSE
		BEGIN
			IF NOT EXISTS (SELECT 1 
							FROM [dbo].[UserCompany] UC WITH (NOLOCK) 
							WHERE UC.[IdUser] = @IdUser AND UC.[IdCompany] = @IdCompany)
			BEGIN
				SET @Result = 0
			END
			
		END
	END

	RETURN @Result

END
