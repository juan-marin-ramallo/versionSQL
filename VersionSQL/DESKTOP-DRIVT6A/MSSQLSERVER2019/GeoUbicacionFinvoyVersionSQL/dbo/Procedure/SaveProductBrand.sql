/****** Object:  Procedure [dbo].[SaveProductBrand]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		FS
-- Create date: 18/03/19
-- Description:	SP para guardar una marcas
-- =============================================
CREATE PROCEDURE [dbo].[SaveProductBrand]
	 @Id [sys].[int] OUTPUT
	,@IdCompany [sys].[int]
	,@Name [sys].[VARCHAR](50)
	,@Identifier [sys].[VARCHAR](50) = null
	,@Description [sys].[VARCHAR](512) = null
	,@ImageName [sys].[VARCHAR](256) = null
	,@IsSubBrand [sys].[bit]
	,@IdFather [sys].[INT] = null
AS
BEGIN

	IF @Identifier IS NOT NULL AND EXISTS (SELECT 1 FROM dbo.[ProductBrand] WITH (NOLOCK) WHERE [Identifier] = @Identifier AND Deleted = 0)
	BEGIN
		SET @Id = -2
    END
	ELSE
	BEGIN
		INSERT INTO [dbo].[ProductBrand](
		   [IdCompany]
			  ,[Name]
			  ,[Identifier]
			  ,[Description]
			  ,[ImageName]
			  ,[IsSubBrand]
			  ,[IdFather]
		) VALUES (
			 @IdCompany
			,@Name
			,@Identifier
			,@Description
			,@ImageName
			,@IsSubBrand
			,@IdFather
		)

		SET @Id = SCOPE_IDENTITY()
	END
    
END
