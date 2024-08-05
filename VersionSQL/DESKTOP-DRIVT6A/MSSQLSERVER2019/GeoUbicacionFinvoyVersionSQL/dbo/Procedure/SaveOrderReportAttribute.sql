/****** Object:  Procedure [dbo].[SaveOrderReportAttribute]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: <Create Date,,>
-- Description:	Guarda atributo para pedidos personalizado
-- =============================================
CREATE PROCEDURE [dbo].[SaveOrderReportAttribute]
	 @Id int OUTPUT
	,@Name varchar(100)
	,@IdType int
	,@DefaultValue varchar(MAX) = ''
	,@Order int
	,@Required bit
	,@IdUser int
AS
BEGIN
	
	INSERT INTO [dbo].[OrderReportAttribute] ([Name], [IdType], [DefaultValue], [Order], [Required],[IdUser], [CreatedDate], [Enabled], [Deleted])
	
	VALUES (@Name, @IdType, @DefaultValue, @Order, @Required, @IdUser, GETUTCDATE(), 1, 0)

	SET @Id = SCOPE_IDENTITY()

	INSERT INTO [dbo].[Field]([Name], [IdFieldGroup], [Order], [IdOrderReportAttribute])
	VALUES (@Name, 14, 80, @Id)

END
