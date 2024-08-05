/****** Object:  Procedure [dbo].[UpdateScheduleReportFilterConditions]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 12/04/2019
-- Description:	SP para actualizar las condiciones
--				de alerta para un envio
--				automatico de reporte
-- =============================================
CREATE PROCEDURE [dbo].[UpdateScheduleReportFilterConditions]
(
	 @IdScheduleReport [sys].[int]
	,@FilterConditions [dbo].[ScheduleReportFilterConditionTableType] READONLY
)
AS
BEGIN
	IF EXISTS (SELECT TOP (1) 1 FROM @FilterConditions)
	BEGIN
		UPDATE	SRFC
		SET		SRFC.[IdQuestion] = FC.[IdQuestion], SRFC.[IdProduct] = FC.[IdProduct], SRFC.[IdProductReportAttribute] = FC.[IdProductReportAttribute],
				SRFC.[ConditionType] = FC.[ConditionType], SRFC.[ConditionValue] = FC.[ConditionValue]
		FROM	[dbo].[ScheduleReportFilterCondition] SRFC
				INNER JOIN @FilterConditions FC ON FC.[Id] IS NOT NULL AND FC.[Id] = SRFC.[Id]
		WHERE	SRFC.[IdScheduleReport] = @IdScheduleReport

		DELETE
		FROM	[dbo].[ScheduleReportFilterCondition]
		WHERE	[IdScheduleReport] = @IdScheduleReport
				AND [Id] NOT IN (SELECT FC.[Id] FROM @FilterConditions FC WHERE FC.[Id] IS NOT NULL)

		INSERT INTO [dbo].[ScheduleReportFilterCondition]([IdScheduleReport], [IdQuestion], [IdProduct], [IdProductReportAttribute], [ConditionType], [ConditionValue])
		SELECT	@IdScheduleReport, [IdQuestion], [IdProduct], [IdProductReportAttribute], [ConditionType], [ConditionValue]
		FROM	@FilterConditions
		WHERE	[Id] IS NULL
	END
	ELSE
	BEGIN
		DELETE
		FROM	[dbo].[ScheduleReportFilterCondition]
		WHERE	[IdScheduleReport] = @IdScheduleReport
	END
END
