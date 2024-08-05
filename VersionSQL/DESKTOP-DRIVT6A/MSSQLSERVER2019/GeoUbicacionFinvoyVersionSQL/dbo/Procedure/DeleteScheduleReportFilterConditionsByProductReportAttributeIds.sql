/****** Object:  Procedure [dbo].[DeleteScheduleReportFilterConditionsByProductReportAttributeIds]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 01/08/2022
-- Description:	Elimina las condiciones de alerta
--				de todos los envíos automáticos
--				cuyo id de atributo de reporte de
--				producto esté en una lista de Ids
-- =============================================
CREATE PROCEDURE [dbo].[DeleteScheduleReportFilterConditionsByProductReportAttributeIds]
(
	@Ids [dbo].IdTableType READONLY
)
AS
BEGIN
	DELETE	SRFC
	FROM	[dbo].[ScheduleReportFilterCondition] SRFC
			INNER JOIN @Ids I ON SRFC.[IdProductReportAttribute] IS NOT NULL AND I.[Id] = SRFC.[IdProductReportAttribute]
END
