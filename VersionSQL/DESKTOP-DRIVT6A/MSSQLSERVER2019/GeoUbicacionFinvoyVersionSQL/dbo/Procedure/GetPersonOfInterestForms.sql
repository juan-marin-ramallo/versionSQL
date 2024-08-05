/****** Object:  Procedure [dbo].[GetPersonOfInterestForms]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 21/10/2016
-- Description:	SP para obtener los formularios asignados a una persona
-- =============================================
CREATE PROCEDURE [dbo].[GetPersonOfInterestForms]
	 @IdPersonOfInterest [sys].[int]
AS
BEGIN
	DECLARE @Now [sys].[datetime]
	SET @Now = GETUTCDATE()

	SELECT		F.[Id] AS FormId, F.[Name] AS FormName, F.[Description] AS FormDescription,
				U.[Name] AS UserName, U.[LastName] AS UserLastName, F.[Date] AS FormDate, F.[IsFormPlus],
				F.[IdFormCategory], FC.[Name] AS FormCategoryName, F.[StartDate], F.[EndDate],
				CASE 
					WHEN CF.[IdForm] IS NOT NULL THEN 1 					
					ELSE 0
				END AS FormHasBeenCompleted, F.[CompleteMultipleTimes], F.[IsWeighted]

	FROM		[dbo].[AssignedForm] AF WITH(NOLOCK)
				INNER JOIN [dbo].[Form] F WITH(NOLOCK) ON F.[Id] = AF.[IdForm]
				LEFT JOIN [dbo].[User] U WITH(NOLOCK) ON U.[Id] = F.[IdUser]
				LEFT JOIN [dbo].[FormCategory] FC WITH(NOLOCK) ON FC.[Id] = F.[IdFormCategory]
				LEFT JOIN dbo.CompletedForm CF WITH(NOLOCK) ON CF.IdForm = F.Id AND CF.IdPersonOfInterest = @IdPersonOfInterest 

	WHERE		AF.[IdPersonOfInterest] = @IdPersonOfInterest AND F.[NonPointOfInterest] = 1
				AND AF.[IdPointOfInterest] IS NULL
				AND F.[Deleted] = 0 AND AF.[Deleted] = 0
				AND Tzdb.IsLowerOrSameSystemDate(F.[StartDate], @Now) = 1 AND Tzdb.IsGreaterOrSameSystemDate(F.[EndDate], @Now) = 1 --Tiene que ser un formulario activo
	
	GROUP BY	F.[Id], F.[Name],  U.[Name], U.[LastName] , F.[Date] ,F.[IdFormCategory], FC.[Name], CF.[IdForm], 
				F.[Description], F.[IsWeighted], F.[StartDate], F.[EndDate], F.[CompleteMultipleTimes], F.[IsFormPlus]
	
	ORDER BY F.[Date] DESC


END
