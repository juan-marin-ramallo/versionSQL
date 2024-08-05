/****** Object:  Procedure [dbo].[UpdateProductDynamicAttribute]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: <Create Date,,>
-- Description:	<aCTUALIZAR ATRIBUTO DINAMICA DE PRODUCTOS>
-- =============================================
CREATE PROCEDURE [dbo].[UpdateProductDynamicAttribute]
	 @Id int
	,@Name varchar(100)
	,@IdValueType int
	,@Description varchar(250) = NULL
	,@IdUser [sys].[int] = 1
AS
BEGIN
	DECLARE @Now [sys].[datetime]
	SET @Now = GETUTCDATE()

	IF EXISTS (SELECT 1 FROM [dbo].[ProductDynamicAttribute] WHERE [Name] = @Name AND @Id <> [Id]) 
		SELECT -1 AS Id;

	ELSE BEGIN
		UPDATE [dbo].[ProductDynamicAttribute]
		SET [Name] = @Name, [IdValueType] = @IdValueType, [Description] = @Description,
			[EditedDate] = GETUTCDATE(), [IdUser] = @IdUser
		WHERE [Id] = @Id

		IF ((select count(1) from ProductDynamicAttributeValue) > 0)
		BEGIN
			UPDATE	[dbo].[ProductPointOfInterestChangeLog] 
			SET		[LastUpdatedDate] = @Now
		END

		SELECT @Id as Id;
	END
END
