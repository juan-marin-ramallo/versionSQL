/****** Object:  Procedure [dbo].[DeleteScheduleReportFilterConditionsByProductReportSectionId]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 01/08/2022
-- Description:	Elimina las condiciones de alerta
--				de todos los envíos automáticos
--				cuyo id de sección de reporte de
--				productos es el dado por parámetro
-- =============================================
CREATE PROCEDURE [dbo].[DeleteScheduleReportFilterConditionsByProductReportSectionId]
(
	@IdProductReportSection [sys].[int]
)
AS
BEGIN
	DELETE	SRFC
	FROM	[dbo].[ScheduleReportFilterCondition] SRFC
			INNER JOIN [dbo].[ProductReportAttribute] PRA ON SRFC.[IdProductReportAttribute] IS NOT NULL AND PRA.[Id] = SRFC.[IdProductReportAttribute] AND PRA.[IdProductReportSection] = @IdProductReportSection
END
