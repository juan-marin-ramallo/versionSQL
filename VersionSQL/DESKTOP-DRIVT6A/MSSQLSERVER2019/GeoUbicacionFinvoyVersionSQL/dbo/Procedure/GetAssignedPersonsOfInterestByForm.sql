/****** Object:  Procedure [dbo].[GetAssignedPersonsOfInterestByForm]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Diego Cáceres
-- Create date: 29/01/2016
-- Description:	SP para obtener las personas de interes de un formulario dado
-- =============================================
CREATE PROCEDURE [dbo].[GetAssignedPersonsOfInterestByForm]
	
	@IdForm [sys].[INT]
    ,@IdUser [sys].[INT] = NULL
AS
BEGIN

	SELECT		AF.[Id], AF.[Date], P.[Id] AS PersonOfInterestId, P.[Name] AS PersonOfInterestName, 
				P.[LastName] AS PersonOfInterestLastName
				
	FROM		[dbo].[AssignedForm] AF WITH(NOLOCK)
				INNER JOIN [dbo].[PersonOfInterest] P WITH(NOLOCK) ON P.[Id] = AF.[IdPersonOfInterest]
				
	WHERE		AF.[IdForm] = @IdForm AND AF.[Deleted] = 0 AND P.Deleted = 0 AND 
				((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(P.[Id], @IdUser) = 1)) AND
                ((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1))
                
	GROUP BY	AF.[Id], AF.[Date], P.[Id], P.[Name], P.[LastName]
	
	ORDER BY 	P.[Id]
END
