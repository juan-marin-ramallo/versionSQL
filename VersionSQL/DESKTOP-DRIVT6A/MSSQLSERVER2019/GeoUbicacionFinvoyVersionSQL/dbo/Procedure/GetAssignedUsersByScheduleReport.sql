/****** Object:  Procedure [dbo].[GetAssignedUsersByScheduleReport]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 23/04/2019
-- Description:	SP para obtener LOS USUARIOS de un REPORTE AUTOMATICO dado
-- =============================================
CREATE PROCEDURE [dbo].[GetAssignedUsersByScheduleReport]
	
	@IdScheduleReport [sys].[INT]
AS
BEGIN

	SELECT		U.[Id] AS UserId, U.[Name] AS UserName
			
	FROM		[dbo].[ScheduleReportUser] AF WITH(NOLOCK)
				INNER JOIN [dbo].[User] U WITH(NOLOCK) ON U.[Id] = AF.[IdUser]

	WHERE		AF.[IdScheduleReport] = @IdScheduleReport  AND U.[Status] = 'H'
	
	GROUP BY	U.[Id], U.[Name]
	ORDER BY 	U.[Id]
	
END
