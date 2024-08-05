/****** Object:  Procedure [dbo].[UpdateOrderReportAttribute]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: <Create Date,,>
-- Description:	Actualiza atributo personalizado para pedidos
-- =============================================
CREATE PROCEDURE [dbo].[UpdateOrderReportAttribute]
	 @Id int
	,@Name varchar(100)
	,@DefaultValue varchar(MAX) = ''
	,@Order int
	,@Required bit
AS
BEGIN

	IF EXISTS (SELECT 1 FROM [dbo].[OrderReportAttribute] with (nolock) WHERE [Name] = @Name AND [Deleted] = 0 AND @Id <> [Id]) 
		SELECT -1 AS Id;

	ELSE BEGIN
		UPDATE [dbo].[OrderReportAttribute]
		SET [Name] = @Name
			,[DefaultValue] = @DefaultValue
			,[Order] = @Order
			,[Required] = @Required
		WHERE [Id] = @Id

		UPDATE OrderReportAttributeOption
		SET [Deleted] = 1
		WHERE [IdOrderReportAttribute] = @Id

		UPDATE Field
		SET [Name] = @Name
		WHERE [IdOrderReportAttribute] = @Id

		SELECT @Id as Id;
	END
END
