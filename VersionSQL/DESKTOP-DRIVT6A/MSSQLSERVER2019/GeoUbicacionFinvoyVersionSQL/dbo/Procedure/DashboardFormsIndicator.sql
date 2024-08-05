/****** Object:  Procedure [dbo].[DashboardFormsIndicator]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		NR
-- Create date: 11/10/2019
-- Description:	SP para obtener indicador de tareas
-- =============================================
CREATE PROCEDURE [dbo].[DashboardFormsIndicator]
	@DateFrom [sys].[datetime]
	,@DateTo [sys].[datetime]
	,@IdPersonsOfInterest [sys].[varchar](max) = NULL
	,@IdPointsOfInterest [sys].[varchar](max) = NULL
	,@IncludeAutomaticVisits [sys].[bit] = 1	
	,@IdUser [sys].[int] = NULL
AS
BEGIN
	SELECT	COUNT (FormId) as FormsCount, Count(f.[CompletedFormId]) as CompletedCount
	FROM	[dbo].[FormsReportFiltered](@DateFrom,@DateTo,@IdPersonsOfInterest,@IdPointsOfInterest,@IncludeAutomaticVisits,@IdUser) f
	
END
