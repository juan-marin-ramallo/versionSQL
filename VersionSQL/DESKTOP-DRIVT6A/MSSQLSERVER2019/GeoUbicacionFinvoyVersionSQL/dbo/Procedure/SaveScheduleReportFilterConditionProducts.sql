/****** Object:  Procedure [dbo].[SaveScheduleReportFilterConditionProducts]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Franco Barboza
-- Create date: 06/06/2023
-- Description:	SP para guardar productos de
--				una alerta de reportes de tipo formulario
-- =============================================
CREATE PROCEDURE [dbo].[SaveScheduleReportFilterConditionProducts]
	 @IdScheduleReportFilterCondition [sys].[int]
	,@IdProduct [dbo].[IdTableType] READONLY
AS
BEGIN
	INSERT INTO [dbo].[ScheduleReportFilterConditionProducts]([IdScheduleReportFilterCondition], [IdProduct])
	SELECT	@IdScheduleReportFilterCondition, [Id]
	FROM	@IdProduct
END
