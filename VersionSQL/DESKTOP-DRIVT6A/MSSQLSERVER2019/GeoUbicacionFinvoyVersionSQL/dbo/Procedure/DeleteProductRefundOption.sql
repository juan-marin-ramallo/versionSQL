/****** Object:  Procedure [dbo].[DeleteProductRefundOption]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 05/08/2016
-- Description:	SP para eliminar un motivo de DEVOLUCION
-- =============================================
CREATE PROCEDURE [dbo].[DeleteProductRefundOption]
(
	 @ProNoDeletedCount [sys].[int] OUTPUT, 
	 @Id [sys].[int]
)
AS
BEGIN

	SELECT @ProNoDeletedCount = COUNT(1)
	FROM ProductRefundOptions
	WHERE Deleted = 0;

	IF(@ProNoDeletedCount > 1)
	BEGIN
		UPDATE	[dbo].[ProductRefundOptions]
		SET		[EditedDate] = GETUTCDATE(),
				[Deleted] = 1
		WHERE	 [Id] = @Id
	END

END
