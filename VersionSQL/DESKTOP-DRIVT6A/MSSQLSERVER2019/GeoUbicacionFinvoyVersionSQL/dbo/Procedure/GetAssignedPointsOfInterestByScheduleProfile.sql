/****** Object:  Procedure [dbo].[GetAssignedPointsOfInterestByScheduleProfile]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 26/10/018
-- Description:	SP para obtener lOS PUNTOS de interes PARA UN CRONOGRAMA DE ACTIVIDADES
-- =============================================
create PROCEDURE [dbo].[GetAssignedPointsOfInterestByScheduleProfile]
	
	 @IdScheduleProfile [sys].[INT]
    ,@IdUser [sys].[INT] = NULL
AS
BEGIN

	SELECT		P.[Id] AS PointOfInterestId, P.[Name] AS PointOfInterestName, 
				P.[Identifier] AS PointOfInterestIdentifier
				
	FROM		[dbo].[ScheduleProfileAssignation] SPA WITH(NOLOCK)
				INNER JOIN [dbo].[PointOfInterest] P WITH(NOLOCK) ON P.[Id] = SPA.[IdPointOfInterest]
				
	WHERE		SPA.[IdScheduleProfile] = @IdScheduleProfile AND P.Deleted = 0 AND 
				((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(P.[Id], @IdUser) = 1)) AND
                ((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1))
                
	GROUP BY	P.[Id], P.[Name], P.[Identifier]
	
	ORDER BY 	P.[Id]
END
