/****** Object:  Procedure [dbo].[UpdateProductCategory]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Matias Corso
-- Create date: 12/10/2016
-- Description:	SP para actualizar una categoría de producto
-- =============================================
CREATE PROCEDURE [dbo].[UpdateProductCategory]
(
	 @Id [sys].[int]
	,@Name [sys].[varchar](50)
	,@Description [sys].[varchar](250)
	,@Order [sys].[int]
)
AS
BEGIN
	--ProductCategory Name Duplicated
	IF EXISTS (SELECT 1 FROM [dbo].[ProductCategory] with (nolock) WHERE [Name] = @Name AND Deleted = 0 AND @Id != Id) SELECT -1 AS Id;

	ELSE
	BEGIN
		DECLARE @Now [sys].[datetime]
		SET @Now = GETUTCDATE()

		UPDATE	[dbo].[ProductCategory]	
		SET		[Name] = @Name,
				[Description] = @Description,
				[EditedDate] = @Now,
				[Order] = @Order	
		WHERE	[Id] = @Id

		SELECT @Id as Id;

		--Cambio para que actuailce el cambio de categoria como una diferencia de productos.
		IF EXISTS (SELECT 1 FROM [dbo].[ProductCategoryList] with (nolock) WHERE [IdProductCategory] = @Id) 
		BEGIN
			UPDATE	[dbo].[ProductPointOfInterestChangeLog] 
			SET		[LastUpdatedDate] = @Now
		END
	END

END
