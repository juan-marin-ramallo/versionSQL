/****** Object:  Procedure [dbo].[GetAssignedPointsOfInterestByScheduleReport]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 23/04/2019
-- Description:	SP para obtener las puntos de interes de un REPORTE AUTOMATICO dado
-- =============================================
CREATE PROCEDURE [dbo].[GetAssignedPointsOfInterestByScheduleReport]
	
	@IdScheduleReport [sys].[INT],
	@IdUser [sys].[INT] = NULL
AS
BEGIN

	SELECT		P.[Id] AS PointOfInterestId, P.[Name] AS PointOfInterestName, 
				P.[Identifier] AS PointOfInterestIdentifier
			
	FROM		[dbo].[ScheduleReportPointOfInterest] AF WITH(NOLOCK)
				INNER JOIN [dbo].[PointOfInterest] P WITH(NOLOCK) ON P.[Id] = AF.[IdPointOfInterest]

	WHERE		AF.[IdScheduleReport] = @IdScheduleReport  AND P.Deleted = 0 AND 
				((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1)) AND
                ((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1))
	
	GROUP BY	P.[Id], P.[Name], P.[Identifier]
	ORDER BY 	P.[Id]
	
END
