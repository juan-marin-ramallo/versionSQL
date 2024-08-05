/****** Object:  Procedure [dbo].[GetScheduleProductReportSections]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 24/10/2018
-- Description:	SP para obtener los permisos para personas de interés QUE SE PUEDEN AGENDAR EN CRONOGRAMA DE ACTIVIDADES

-- =============================================
CREATE PROCEDURE [dbo].[GetScheduleProductReportSections]
@IdScheduleProfile [sys].[int]
AS
BEGIN

	SELECT	P.[Id], P.[Name], P.[Description], P.[Order], P.[Deleted], P.[FullDeleted] 
	FROM	[dbo].[ScheduleProfileProductSection] S with(nolock)
			INNER JOIN dbo.[ProductReportSection] P WITH (NOLOCK) ON S.[IdProductReportSection] = P.[Id]
	WHERE	S.[IdScheduleProfile] = @IdScheduleProfile AND P.[Deleted] = 0
	ORDER BY [Order] ASC
END
