/****** Object:  Procedure [dbo].[SaveOrderReportAttributeOption]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: <Create Date,,>
-- Description:	Guarda opcion para atributo personalizado de tipo  multiple opcion en pedidos
-- =============================================
Create PROCEDURE [dbo].[SaveOrderReportAttributeOption]
	 @IdOrderReportAttribute int
	,@Text varchar(100)
	,@IsDefault bit
AS
BEGIN
	
	INSERT INTO [dbo].[OrderReportAttributeOption] ([IdOrderReportAttribute], [Text], [IsDefault], [Deleted])
	VALUES (@IdOrderReportAttribute, @Text, @IsDefault, 0)

END
