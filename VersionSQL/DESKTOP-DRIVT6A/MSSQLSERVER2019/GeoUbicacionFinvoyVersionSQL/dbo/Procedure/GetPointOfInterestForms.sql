/****** Object:  Procedure [dbo].[GetPointOfInterestForms]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 21/10/2015
-- Description:	SP para obtener los formularios asignados a una persona y un punto
-- =============================================
CREATE PROCEDURE [dbo].[GetPointOfInterestForms]
	 @IdPersonOfInterest [sys].[int]
	,@IdPointOfInterest [sys].[int]
AS
BEGIN
	DECLARE @Now [sys].[datetime]
	SET @Now = GETUTCDATE()

	DECLARE  @IdPersonOfInterestLocal [sys].[int] = @IdPersonOfInterest
	DECLARE  @IdPointOfInterestLocal [sys].[int] = @IdPointOfInterest

	;WITH PointForms AS
	(
		SELECT	F.[Id], F.[Name], F.[Date], F.[Description], F.[IsFormPlus],   
				F.[IdFormCategory], F.[OneTimeAnswer], F.[CompleteMultipleTimes],
				F.[StartDate], F.[EndDate], F.[IsWeighted], F.[AllPointOfInterest], F.[IdUser]
		FROM	[dbo].[Form] F WITH (NOLOCK)
		WHERE	F.[Deleted] = 0
				AND F.[IsFormPlus] = 0
				AND Tzdb.IsLowerOrSameSystemDate(F.[StartDate], @Now) = 1 AND Tzdb.IsGreaterOrSameSystemDate(F.[EndDate], @Now) = 1 --Tiene que ser un formulario activo
	)
	,CompletedFormAggregated AS
	(
		SELECT		F.Id AS IdForm, COUNT(CF.IdForm) AS CompletedCount
		FROM		PointForms F WITH (NOLOCK)
					LEFT JOIN [dbo].[CompletedForm] CF WITH (NOLOCK) ON CF.IdForm = F.Id AND CF.IdPersonOfInterest = @IdPersonOfInterestLocal AND CF.IdPointOfInterest = @IdPointOfInterestLocal
		WHERE		F.[AllPointOfInterest] = 0
		GROUP BY	F.Id
	)
	,CompletedFormAllPointsAggregated AS
	(
		SELECT		F.Id AS IdForm, COUNT(CF.IdForm) AS CompletedCount
		FROM		PointForms F WITH (NOLOCK)
					LEFT JOIN [dbo].[CompletedForm] CF WITH (NOLOCK) ON CF.IdForm = F.Id AND CF.IdPersonOfInterest = @IdPersonOfInterestLocal AND CF.IdPointOfInterest = @IdPointOfInterestLocal
		WHERE		F.[AllPointOfInterest] = 1
		GROUP BY	F.Id
	)

	--Tareas asignadas al punto en AssignedForm
	SELECT		F.[Id] AS FormId, F.[Name] AS FormName,  U.[Name] AS UserName, U.[LastName] AS UserLastName, 
				F.[Date] AS FormDate, F.[Description] AS FormDescription, F.[IsFormPlus],   
				F.[IdFormCategory], FC.[Name] AS FormCategoryName,  F.[OneTimeAnswer], F.[CompleteMultipleTimes], F.[StartDate], F.[EndDate],
				CASE 
					WHEN CF.[IdForm] IS NOT NULL THEN 1 					
					ELSE 0
				END AS FormHasBeenCompleted,
				CASE 
					WHEN CFA.[CompletedCount] > 0 AND F.[OneTimeAnswer] = 1 THEN 1 					
					ELSE 0
				END AS FormIsCompletedOneTime, F.[IsWeighted]
	
	FROM		[dbo].[AssignedForm] AF WITH (NOLOCK)
				INNER JOIN PointForms F WITH (NOLOCK) ON F.[Id] = AF.[IdForm]
				LEFT JOIN [dbo].[User] U WITH (NOLOCK) ON U.[Id] = F.[IdUser]
				LEFT JOIN [dbo].[FormCategory] FC WITH (NOLOCK) ON FC.[Id] = F.[IdFormCategory]
				LEFT JOIN [dbo].[CompletedForm] CF WITH (NOLOCK) ON CF.IdForm = F.Id AND CF.IdPersonOfInterest = @IdPersonOfInterestLocal AND CF.IdPointOfInterest = @IdPointOfInterestLocal
				LEFT JOIN CompletedFormAggregated CFA WITH (NOLOCK) ON CFA.IdForm = F.Id

	WHERE		AF.[IdPersonOfInterest] = @IdPersonOfInterestLocal AND F.[AllPointOfInterest] = 0
				AND AF.[IdPointOfInterest] = @IdPointOfInterestLocal
				AND AF.[Deleted] = 0
	
	GROUP BY	F.[Id], F.[Name], U.[Name], U.[LastName], F.[Description], F.[Date], F.[IdFormCategory], F.[IsFormPlus], 
				FC.[Name], CF.IdForm, F.[OneTimeAnswer], F.[CompleteMultipleTimes], CFA.[IdForm], CFA.[CompletedCount],
				F.[IsWeighted], F.[StartDate], F.[EndDate]
	
	UNION

	--Tareas SIN ASIGNAR al punto en AssignedForm - ESTAN ASIGNADAS A TODOS LOS PUNTOS
	SELECT		F.[Id] AS FormId, F.[Name] AS FormName,  U.[Name] AS UserName, U.[LastName] AS UserLastName, 
				F.[Date] AS FormDate, F.[Description] AS FormDescription, F.[IsFormPlus],
				F.[IdFormCategory], FC.[Name] AS FormCategoryName,  F.[OneTimeAnswer], F.[CompleteMultipleTimes], F.[StartDate], F.[EndDate],
				CASE 
					WHEN CF.[IdForm] IS NOT NULL THEN 1 					
					ELSE 0
				END AS FormHasBeenCompleted,
				CASE 
					WHEN CFA.[CompletedCount] > 0 AND F.[OneTimeAnswer] = 1 THEN 1 					
					ELSE 0
				END AS FormIsCompletedOneTime, F.[IsWeighted]
	
	FROM		[dbo].[AssignedForm] AF WITH (NOLOCK)
				INNER JOIN PointForms F WITH (NOLOCK) ON F.[Id] = AF.[IdForm]
				LEFT JOIN [dbo].[User] U WITH (NOLOCK) ON U.[Id] = F.[IdUser]
				LEFT JOIN [dbo].[FormCategory] FC WITH (NOLOCK) ON FC.[Id] = F.[IdFormCategory]
				LEFT JOIN [dbo].[CompletedForm] CF WITH (NOLOCK) ON CF.IdForm = F.Id AND CF.IdPersonOfInterest = @IdPersonOfInterestLocal AND CF.IdPointOfInterest = @IdPointOfInterestLocal
				LEFT JOIN CompletedFormAllPointsAggregated CFA WITH (NOLOCK) ON CFA.IdForm = F.Id
	
	WHERE		AF.[IdPersonOfInterest] = @IdPersonOfInterestLocal AND F.[AllPointOfInterest] = 1 AND AF.[IdPointOfInterest] IS NULL
				AND AF.[Deleted] = 0
	
	GROUP BY	F.[Id], F.[Name], U.[Name], U.[LastName], F.[Date], F.[IdFormCategory], F.[IsFormPlus],
				FC.[Name], CF.IdForm, F.[OneTimeAnswer], F.[CompleteMultipleTimes], CFA.[IdForm], CFA.[CompletedCount],
				F.[Description], F.[IsWeighted], F.[StartDate], F.[EndDate]

END
