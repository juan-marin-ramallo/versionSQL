/****** Object:  Procedure [dbo].[GetPointOfInterestFormsByDate]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 10/09/2018
-- Description:	SP para obtener los formularios asignados a una persona y un punto Y UNA FECHA
-- =============================================
CREATE PROCEDURE [dbo].[GetPointOfInterestFormsByDate]
	 @IdPersonOfInterest [sys].[int]
	,@IdPointOfInterest [sys].[int]
	,@DateToCheck [sys].[datetime]
AS
BEGIN

	DECLARE  @IdPersonOfInterestLocal [sys].[int] = @IdPersonOfInterest
	DECLARE  @IdPointOfInterestLocal [sys].[int] = @IdPointOfInterest
	DECLARE  @DateToCheckLocal [sys].[DATETIME] = @DateToCheck

	DECLARE @Now [sys].[datetime]
    SET @Now = GETUTCDATE()

	--Tareas asignadas al punto en AssignedForm
	SELECT		F.[Id] AS FormId, F.[Name] AS FormName,  U.[Name] AS UserName, U.[LastName] AS UserLastName, 
				F.[Date] AS FormDate, F.[Description] AS FormDescription, F.[IsFormPlus], 
				F.[IdFormCategory], FC.[Name] AS FormCategoryName,  F.[OneTimeAnswer], F.[CompleteMultipleTimes], F.[StartDate], F.[EndDate],
				CASE 
					WHEN CF.[IdForm] IS NOT NULL THEN 1 					
					ELSE 0
				END AS FormHasBeenCompleted,
				CASE 
					WHEN CF2.[IdForm] IS NOT NULL AND F.[OneTimeAnswer] = 1 THEN 1 					
					ELSE 0
				END AS FormIsCompletedOneTime, F.[IsWeighted]
	
	FROM		[dbo].[AssignedForm] AF WITH (NOLOCK)
				INNER JOIN [dbo].[Form] F WITH (NOLOCK) ON F.[Id] = AF.[IdForm]
				LEFT JOIN [dbo].[User] U WITH (NOLOCK) ON U.[Id] = F.[IdUser]
				LEFT JOIN [dbo].[FormCategory] FC WITH (NOLOCK) ON FC.[Id] = F.[IdFormCategory]
				LEFT JOIN dbo.CompletedForm CF WITH (NOLOCK) ON CF.IdForm = F.Id AND CF.IdPersonOfInterest = @IdPersonOfInterestLocal AND CF.IdPointOfInterest = @IdPointOfInterestLocal 
				LEFT JOIN [dbo].[CompletedForm] CF2 WITH (NOLOCK) ON CF2.IdForm = F.Id AND CF2.IdPointOfInterest = @IdPointOfInterestLocal 

	WHERE		AF.[IdPersonOfInterest] = @IdPersonOfInterestLocal AND F.[AllPointOfInterest] = 0
				AND AF.[IdPointOfInterest] = @IdPointOfInterestLocal
				AND F.[Deleted] = 0 AND AF.[Deleted] = 0
				AND F.[IsFormPlus] = 0
				AND Tzdb.IsGreaterOrSameSystemDate(@DateToCheckLocal, @Now) = 1 --sIEMPRE QUE LA FECHA SEA MAYOR O IGUAL QUE HOY.si NO NO MUESTRO NADA
				AND Tzdb.IsLowerOrSameSystemDate(F.[StartDate], @DateToCheckLocal) = 1 AND Tzdb.IsGreaterOrSameSystemDate(F.[EndDate], @DateToCheckLocal) = 1 --Tiene que ser un formulario activo en el momento de la fecha que recibo como parametro
	GROUP BY	F.[Id], F.[Name], U.[Name], U.[LastName], F.[Description], F.[Date], F.[IdFormCategory], F.[IsFormPlus],
				FC.[Name], CF.IdForm, F.[OneTimeAnswer], F.[CompleteMultipleTimes], CF2.[IdForm], F.[IsWeighted], F.[StartDate], F.[EndDate]
	
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
					WHEN CF2.[IdForm] IS NOT NULL AND F.[OneTimeAnswer] = 1 THEN 1 					
					ELSE 0
				END AS FormIsCompletedOneTime, F.[IsWeighted]
	
	FROM		[dbo].[AssignedForm] AF WITH (NOLOCK)
				INNER JOIN [dbo].[Form] F WITH (NOLOCK) ON F.[Id] = AF.[IdForm]
				LEFT JOIN [dbo].[User] U WITH (NOLOCK) ON U.[Id] = F.[IdUser]
				LEFT JOIN [dbo].[FormCategory] FC WITH (NOLOCK) ON FC.[Id] = F.[IdFormCategory]
				LEFT JOIN [dbo].[CompletedForm] CF WITH (NOLOCK) ON CF.IdForm = F.Id AND CF.IdPersonOfInterest = @IdPersonOfInterestLocal AND CF.IdPointOfInterest = @IdPointOfInterestLocal 
				LEFT JOIN [dbo].[CompletedForm] CF2 WITH (NOLOCK) ON CF2.IdForm = F.Id AND CF2.IdPointOfInterest = @IdPointOfInterestLocal 
	
	WHERE		AF.[IdPersonOfInterest] = @IdPersonOfInterestLocal AND F.[AllPointOfInterest] = 1 AND AF.[IdPointOfInterest] IS NULL
				AND F.[Deleted] = 0 AND AF.[Deleted] = 0
				AND F.[IsFormPlus] = 0
				AND Tzdb.IsGreaterOrSameSystemDate(@DateToCheckLocal, @Now) = 1 --sIEMPRE QUE LA FECHA SEA MAYOR O IGUAL QUE HOY.si NO NO MUESTRO NADA
				AND Tzdb.IsLowerOrSameSystemDate(F.[StartDate], @DateToCheckLocal) = 1 AND Tzdb.IsGreaterOrSameSystemDate(F.[EndDate], @DateToCheckLocal) = 1 --Tiene que ser un formulario activo en el momento de la fecha que recibo como parametro
	
	GROUP BY	F.[Id], F.[Name], U.[Name], U.[LastName], F.[Date], F.[IdFormCategory], F.[IsFormPlus],
				FC.[Name], CF.IdForm, F.[OneTimeAnswer], F.[CompleteMultipleTimes], CF2.[IdForm],
        F.[Description], F.[IsWeighted], F.[StartDate], F.[EndDate]

END
