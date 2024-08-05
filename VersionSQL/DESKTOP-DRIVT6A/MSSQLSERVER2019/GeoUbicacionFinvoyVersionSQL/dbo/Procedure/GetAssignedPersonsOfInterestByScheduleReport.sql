/****** Object:  Procedure [dbo].[GetAssignedPersonsOfInterestByScheduleReport]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 23/04/2019
-- Description:	SP para obtener las personas de interes de un REPORTE AUTOMATICO dado
-- =============================================
CREATE PROCEDURE [dbo].[GetAssignedPersonsOfInterestByScheduleReport]
	
	@IdScheduleReport [sys].[INT]
    ,@IdUser [sys].[INT] = NULL
AS
BEGIN

	SELECT		P.[Id] AS PersonOfInterestId, P.[Name] AS PersonOfInterestName, 
				P.[LastName] AS PersonOfInterestLastName
				
	FROM		[dbo].[ScheduleReportPersonOfInterest] AF WITH(NOLOCK)
				INNER JOIN [dbo].[PersonOfInterest] P WITH(NOLOCK) ON P.[Id] = AF.[IdPersonOfInterest]
				
	WHERE		AF.[IdScheduleReport] = @IdScheduleReport AND P.Deleted = 0 AND 
				((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(P.[Id], @IdUser) = 1)) AND
                ((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1))
                
	GROUP BY	P.[Id], P.[Name], P.[LastName]
	
	ORDER BY 	P.[Id]
END
