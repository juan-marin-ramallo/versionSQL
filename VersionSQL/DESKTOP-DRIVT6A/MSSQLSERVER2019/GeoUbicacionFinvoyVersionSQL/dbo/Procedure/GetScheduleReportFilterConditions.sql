/****** Object:  Procedure [dbo].[GetScheduleReportFilterConditions]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 26/07/2022
-- Description:	SP para obtener las condiciones
--				de alerta de un envío automático
--				de reporte dado
-- =============================================
CREATE PROCEDURE [dbo].[GetScheduleReportFilterConditions]
(
	@IdScheduleReport [sys].[int]
)
AS
BEGIN
	SELECT	SRFC.[Id], SRFC.[IdScheduleReport],
			SRFC.[IdQuestion], Q.[Text] AS QuestionText, Q.[Type] AS QuestionTypeCode, QO.[Id] AS IdQuestionOption, QO.[Text] AS QuestionOptionText,
			SRFC.[IdProduct], P.[Identifier] AS ProductIdentificer, P.[Name] AS ProductName,
			SRFC.[IdProductReportAttribute], PRA.[Name] AS ProductReportAttributeName, PRA.[IdType] AS ProductReportAttributeTypeId, PRAO.[Id] AS IdProductReportAttributeOption, PRAO.[Text] AS ProductReportAttributeOptionText,
			SRFC.[ConditionType], SRFC.[ConditionValue]
	FROM	[dbo].[ScheduleReportFilterCondition] SRFC
			LEFT OUTER JOIN [dbo].[Question] Q ON Q.[Id] = SRFC.[IdQuestion]
			LEFT OUTER JOIN [dbo].[QuestionOption] QO ON QO.[IdQuestion] = Q.[Id] AND Q.[Type] = 'MO' AND SRFC.[ConditionValue] IS NOT NULL AND CAST(QO.[Id] AS [sys].[varchar](50)) = SRFC.[ConditionValue]
			LEFT OUTER JOIN [dbo].[Product] P ON P.[Id] = SRFC.[IdProduct]
			LEFT OUTER JOIN [dbo].[ProductReportAttribute] PRA ON PRA.[Id] = SRFC.[IdProductReportAttribute]
			LEFT OUTER JOIN [dbo].[ProductReportAttributeOption] PRAO ON PRAO.[IdProductReportAttribute] = PRA.[Id] AND PRA.[IdType] = 7 AND SRFC.[ConditionValue] IS NOT NULL AND CAST(PRAO.[Id] AS [sys].[varchar](50)) = SRFC.[ConditionValue]
	WHERE	SRFC.[IdScheduleReport] = @IdScheduleReport
END
