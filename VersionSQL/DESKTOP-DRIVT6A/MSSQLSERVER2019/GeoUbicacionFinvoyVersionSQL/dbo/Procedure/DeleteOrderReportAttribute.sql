/****** Object:  Procedure [dbo].[DeleteOrderReportAttribute]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: <Create Date,,>
-- Description:	Elimina atributo personalizado para pedidos
-- =============================================
CREATE PROCEDURE [dbo].[DeleteOrderReportAttribute]
	@Id int
AS
BEGIN
	
	UPDATE [dbo].[OrderReportAttribute]
	SET [Deleted] = 1
	WHERE [Id] = @Id

	UPDATE [dbo].[OrderReportAttributeOption]
	SET [Deleted] = 1
	WHERE [IdOrderReportAttribute] = @Id

	UPDATE  [dbo].[Field]
	SET		[Deleted] = 1,
			[FullDeleted] = 1
	WHERE	[IdOrderReportAttribute] = @Id


END
