/****** Object:  Procedure [dbo].[SaveProductCategory]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Matias Corso
-- Create date: 12/10/2016
-- Description:	SP para guardar una categoría de producto
-- =============================================
CREATE PROCEDURE [dbo].[SaveProductCategory]
	 @Id [sys].[int] OUTPUT
	,@Name [sys].[varchar](50)
	,@Description [sys].[varchar](250)
	,@IdUser [sys].[int]
	,@Order [sys].[int]
AS
BEGIN

	--ProductCategory Name Duplicated
	IF EXISTS (SELECT 1 FROM ProductCategory WITH (NOLOCK) WHERE [Name] = @Name AND Deleted = 0) SELECT @Id = -1;

	ELSE
	BEGIN
		DECLARE @OrderByName AS [sys].[bit]
		SET @OrderByName = (SELECT [Value] FROM dbo.[Configuration] WHERE IdConfigurationGroup = 2 and [Name] = 'OrderProductCategory')

		DECLARE @Now [sys].[datetime]
		SET @Now = GETUTCDATE()

		INSERT INTO dbo.ProductCategory
				( [Name] ,
				  [Description] ,
				  CreatedDate ,
				  IdUser ,
				  Deleted,
				  EditedDate, 
				  [Order]
				)
		VALUES  ( @Name , -- Name - varchar(50)
				  @Description , -- Description - varchar(250)
				  @Now , -- CreatedDate - datetime
				  @IdUser , -- IdUser - int
				  0,  -- Deleted - bit
				  @Now,
				  @Order
				)

		SELECT @Id = SCOPE_IDENTITY()

		IF @OrderByName = 1 
		BEGIN
		
			UPDATE	dbo.ProductCategory
			SET		[Order] = @Id
			WHERE	Id = @Id

		END

	END

END
