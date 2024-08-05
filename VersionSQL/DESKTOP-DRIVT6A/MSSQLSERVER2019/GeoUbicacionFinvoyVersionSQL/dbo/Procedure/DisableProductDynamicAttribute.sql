/****** Object:  Procedure [dbo].[DisableProductDynamicAttribute]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 04/11/2020
-- Description:	SP para desactivar un atributo dinamico de productos
-- =============================================
CREATE PROCEDURE [dbo].[DisableProductDynamicAttribute]
(
	 @Id [sys].[int],
	 @IdUser [sys].[int] = 1
)
AS
BEGIN
BEGIN TRANSACTION;

    SAVE TRANSACTION DisableCompleted;
	BEGIN TRY

	DECLARE @Now [sys].[datetime]
	SET @Now = GETUTCDATE()

	DECLARE @ColumnName [sys].[varchar](50) = NULL

	UPDATE	[dbo].[ProductDynamicAttribute]
	SET		[Disabled] = 1, [EditedDate] = GETUTCDATE(), [IdUser] = @IdUser
	WHERE	Id = @Id

	set @ColumnName = (SELECT ColumnName FROM [dbo].[ProductDynamicAttribute] WITH (NOLOCK) WHERE Id = @Id)

	--Elimino TODOS LOS VALORES PARA PRODUCTOS DE ESA COLUMNA
	DECLARE @sqlText [sys].[varchar](150)
	SET @sqlText = N'UPDATE dbo.[ProductDynamicAttributeValue] set ' + @ColumnName + ' = NULL'
	Exec (@sqlText) 
	
	SELECT @Id as Id

	END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION DisableCompleted; -- rollback to DisableCompleted
			SELECT 0 as Id
        END
    END CATCH
    COMMIT TRANSACTION 
	

END
