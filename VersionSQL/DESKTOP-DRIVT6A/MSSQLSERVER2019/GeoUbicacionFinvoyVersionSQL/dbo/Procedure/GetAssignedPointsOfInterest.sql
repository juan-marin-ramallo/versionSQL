/****** Object:  Procedure [dbo].[GetAssignedPointsOfInterest]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 04/05/2016
-- Description:	SP para obtener los puntos de interes de un formulario dado sin contar la cantidad de completados
-- =============================================
CREATE PROCEDURE [dbo].[GetAssignedPointsOfInterest]
	
	@IdForm [sys].[INT]
    ,@IdUser [sys].[INT] = NULL
AS
BEGIN

	SELECT		AF.[Id], AF.[Date], P.[Id] AS PointOfInterestId, P.[Name] AS PointOfInterestName, 
				P.[Identifier] AS PointOfInterestIdentifier
			
	FROM		[dbo].[AssignedForm] AF WITH(NOLOCK)
				INNER JOIN [dbo].[PointOfInterest] P WITH(NOLOCK) ON P.[Id] = AF.[IdPointOfInterest]

	WHERE		AF.[IdForm] = @IdForm AND AF.[Deleted] = 0 AND P.Deleted = 0 AND 
				((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1)) AND
                ((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1))
	
	GROUP BY	AF.[Id], AF.[Date], P.[Id], P.[Name], P.[Identifier]
	ORDER BY 	P.[Id]
END
