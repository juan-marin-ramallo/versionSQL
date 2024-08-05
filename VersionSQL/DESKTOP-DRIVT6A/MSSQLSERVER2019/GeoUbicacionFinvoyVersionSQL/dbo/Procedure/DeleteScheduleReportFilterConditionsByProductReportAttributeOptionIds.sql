/****** Object:  Procedure [dbo].[DeleteScheduleReportFilterConditionsByProductReportAttributeOptionIds]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 01/08/2022
-- Description:	Elimina las condiciones de alerta
--				de todos los envíos automáticos
--				cuyo id de atributo de reporte de
--				producto es el dado por parámetros
--				y además tengan los id de opciones
--				en una lista de Ids dada
-- =============================================
CREATE PROCEDURE [dbo].[DeleteScheduleReportFilterConditionsByProductReportAttributeOptionIds]
(
	 @IdProductReportAttribute [sys].[int]
	,@OptionIds [dbo].IdTableType READONLY
)
AS
BEGIN
	DELETE	SRFC
	FROM	[dbo].[ScheduleReportFilterCondition] SRFC
			INNER JOIN @OptionIds I ON SRFC.[ConditionValue] IS NOT NULL AND CAST(I.[Id] AS [sys].[varchar](50)) = SRFC.[ConditionValue]
	WHERE	SRFC.[IdProductReportAttribute] = @IdProductReportAttribute
END
