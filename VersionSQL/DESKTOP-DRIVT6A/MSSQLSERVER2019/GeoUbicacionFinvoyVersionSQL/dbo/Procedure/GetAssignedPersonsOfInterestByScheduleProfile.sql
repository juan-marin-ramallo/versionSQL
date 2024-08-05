/****** Object:  Procedure [dbo].[GetAssignedPersonsOfInterestByScheduleProfile]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 26/10/018
-- Description:	SP para obtener las personas de interes PARA UN CRONOGRAMA DE ACTIVIDADES
-- =============================================
CREATE PROCEDURE [dbo].[GetAssignedPersonsOfInterestByScheduleProfile]
	
	 @IdScheduleProfile [sys].[INT]
    ,@IdUser [sys].[INT] = NULL
AS
BEGIN

	SELECT		P.[Id] AS PersonOfInterestId, P.[Name] AS PersonOfInterestName, 
				P.[LastName] AS PersonOfInterestLastName, P.[Identifier] AS PersonOfInterestIdentifier
				
	FROM		[dbo].[ScheduleProfileAssignation] SPA WITH(NOLOCK)
				INNER JOIN [dbo].[PersonOfInterest] P WITH(NOLOCK) ON P.[Id] = SPA.[IdPersonOfInterest]
				
	WHERE		SPA.[IdScheduleProfile] = @IdScheduleProfile AND P.Deleted = 0 AND 
				((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(P.[Id], @IdUser) = 1)) AND
                ((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1))
                
	GROUP BY	P.[Id], P.[Name], P.[LastName], P.[Identifier]
	
	ORDER BY 	P.[Id]
END
