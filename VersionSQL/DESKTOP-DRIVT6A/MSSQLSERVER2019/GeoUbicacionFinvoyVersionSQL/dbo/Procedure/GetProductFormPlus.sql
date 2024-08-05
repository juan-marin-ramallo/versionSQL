/****** Object:  Procedure [dbo].[GetProductFormPlus]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Javier
-- Create date: 30/03/2023
-- Description:	GetProductFormPlus
-- =============================================
CREATE PROCEDURE [dbo].[GetProductFormPlus] 
	-- Add the parameters for the stored procedure here
	@IdPersonOfInterest [sys].[int],
	@IdPointOfInterest [sys].[int],
	@IdProduct [sys].[int]
AS
BEGIN
	DECLARE @Now [sys].[datetime]
		SET @Now = GETUTCDATE()
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;

		-- Insert statements for procedure here
		--Ids de FormPlus asignados a punto
		SELECT F.[Id] AS FormId, F.[Name] AS FormName,  U.[Name] AS UserName, U.[LastName] AS UserLastName, 
					F.[Date] AS FormDate, F.[Description] AS FormDescription, F.[IsFormPlus],
					F.[IdFormCategory], FC.[Name] AS FormCategoryName,  F.[OneTimeAnswer], 
					F.[CompleteMultipleTimes], F.[StartDate], F.[EndDate],
					CASE 
						WHEN CF.[IdForm] IS NOT NULL THEN 1 					
						ELSE 0
					END AS FormHasBeenCompleted,
					CASE 
						WHEN CF2.[IdForm] IS NOT NULL AND F.[OneTimeAnswer] = 1 THEN 1 					
						ELSE 0
					END AS FormIsCompletedOneTime, F.[IsWeighted]

		FROM dbo.[Product] as P
		INNER JOIN dbo.[FormPlusProduct] as FPP WITH (NOLOCK) on FPP.IdProduct = P.Id
		INNER JOIN dbo.[FormPlus] as FP WITH (NOLOCK) on FP.Id = FPP.IdFormPlus
		INNER JOIN dbo.[AssignedForm] as AF WITH (NOLOCK) on AF.[IdForm] = FP.[IdForm]
		INNER JOIN dbo.[Form] F WITH (NOLOCK) ON F.[Id] = AF.[IdForm]
		LEFT JOIN dbo.[User] U WITH (NOLOCK) ON U.[Id] = F.[IdUser]
		LEFT JOIN dbo.[FormCategory] FC WITH (NOLOCK) ON FC.[Id] = F.[IdFormCategory]
		LEFT JOIN dbo.CompletedForm CF WITH (NOLOCK) ON CF.IdForm = F.Id AND CF.IdPersonOfInterest = @IdPersonOfInterest AND CF.IdPointOfInterest = @IdPointOfInterest AND CF.IdProduct = @IdProduct AND Tzdb.AreSameSystemDates(CF.[Date], @Now) = 1
		LEFT JOIN [dbo].[CompletedForm] CF2 WITH (NOLOCK) ON CF2.IdForm = F.Id AND CF2.IdPointOfInterest = @IdPointOfInterest  AND CF2.IdProduct = @IdProduct AND Tzdb.AreSameSystemDates(CF2.[Date], @Now) = 1
		WHERE P.[Id] = @IdProduct AND F.[Deleted] = 0 AND AF.Deleted = 0
		                  AND AF.IdPersonOfInterest = @IdPersonOfInterest AND F.AllPointOfInterest = 0
						  AND AF.IdPointOfInterest = @IdPointOfInterest 
						  AND P.Deleted = 0 AND FP.Deleted = 0
						  AND Tzdb.IsLowerOrSameSystemDate(F.[StartDate], @Now) = 1 
						  AND Tzdb.IsGreaterOrSameSystemDate(F.[EndDate], @Now) = 1 --Tiene que ser un formulario activo
	
		GROUP BY	F.[Id], F.[Name], U.[Name], U.[LastName], F.[Date], F.[IdFormCategory], F.[IsFormPlus],
						FC.[Name], CF.IdForm, F.[OneTimeAnswer], F.[CompleteMultipleTimes], CF2.[IdForm],
				F.[Description], F.[IsWeighted], F.[StartDate], F.[EndDate]
		UNION
		SELECT F.[Id] AS FormId, F.[Name] AS FormName,  U.[Name] AS UserName, U.[LastName] AS UserLastName, 
						F.[Date] AS FormDate, F.[Description] AS FormDescription, F.[IsFormPlus],
						F.[IdFormCategory], FC.[Name] AS FormCategoryName,  F.[OneTimeAnswer], 
						F.[CompleteMultipleTimes], F.[StartDate], F.[EndDate],
						CASE 
							WHEN CF.[IdForm] IS NOT NULL THEN 1 					
							ELSE 0
						END AS FormHasBeenCompleted,
						CASE 
							WHEN CF2.[IdForm] IS NOT NULL AND F.[OneTimeAnswer] = 1 THEN 1 					
							ELSE 0
						END AS FormIsCompletedOneTime, F.[IsWeighted]
		FROM dbo.[Product] as P
		INNER JOIN dbo.[CatalogProduct] as CP WITH (NOLOCK) on CP.IdProduct = P.Id
		INNER JOIN dbo.[FormPlusCatalog] as FPC WITH (NOLOCK) on FPC.IdCatalog = CP.IdCatalog
		INNER JOIN dbo.[FormPlus] as FP WITH (NOLOCK) on FP.Id = FPC.IdFormPlus
		INNER JOIN dbo.[AssignedForm] as AF WITH (NOLOCK) on AF.[IdForm] = FP.[IdForm]
		INNER JOIN dbo.[Form] F WITH (NOLOCK) ON F.[Id] =  AF.[IdForm]
		LEFT JOIN dbo.[User] U WITH (NOLOCK) ON U.[Id] = F.[IdUser]
		LEFT JOIN dbo.[FormCategory] FC WITH (NOLOCK) ON FC.[Id] = F.[IdFormCategory]
		LEFT JOIN dbo.CompletedForm CF WITH (NOLOCK) ON CF.IdForm = F.Id AND CF.IdPersonOfInterest = @IdPersonOfInterest AND CF.IdPointOfInterest = @IdPointOfInterest AND CF.IdProduct = @IdProduct AND Tzdb.AreSameSystemDates(CF.[Date], @Now) = 1
		LEFT JOIN [dbo].[CompletedForm] CF2 WITH (NOLOCK) ON CF2.IdForm = F.Id AND CF2.IdPointOfInterest = @IdPointOfInterest AND CF2.IdProduct = @IdProduct AND Tzdb.AreSameSystemDates(CF2.[Date], @Now) = 1
		WHERE P.[Id] = @IdProduct AND F.[Deleted] = 0 AND AF.Deleted = 0
		                  AND AF.IdPersonOfInterest = @IdPersonOfInterest AND F.AllPointOfInterest = 0
						  AND AF.IdPointOfInterest = @IdPointOfInterest 
						  AND P.Deleted = 0 AND FP.Deleted = 0
						  AND Tzdb.IsLowerOrSameSystemDate(F.[StartDate], @Now) = 1 
						  AND Tzdb.IsGreaterOrSameSystemDate(F.[EndDate], @Now) = 1 --Tiene que ser un formulario activo
	
		GROUP BY	F.[Id], F.[Name], U.[Name], U.[LastName], F.[Date], F.[IdFormCategory], F.[IsFormPlus],
						FC.[Name], CF.IdForm, F.[OneTimeAnswer], F.[CompleteMultipleTimes], CF2.[IdForm],
				F.[Description], F.[IsWeighted], F.[StartDate], F.[EndDate]

		UNION

		--Ids de FormPlus asignados a Todos los puntos
		SELECT F.[Id] AS FormId, F.[Name] AS FormName,  U.[Name] AS UserName, U.[LastName] AS UserLastName, 
					F.[Date] AS FormDate, F.[Description] AS FormDescription, F.[IsFormPlus],
					F.[IdFormCategory], FC.[Name] AS FormCategoryName,  F.[OneTimeAnswer], 
					F.[CompleteMultipleTimes], F.[StartDate], F.[EndDate],
				CASE 
					WHEN CF.[IdForm] IS NOT NULL THEN 1 					
					ELSE 0
				END AS FormHasBeenCompleted,
				CASE 
					WHEN CF2.[IdForm] IS NOT NULL AND F.[OneTimeAnswer] = 1 THEN 1 					
					ELSE 0
				END AS FormIsCompletedOneTime, F.[IsWeighted]

		FROM dbo.[Product] as P
		INNER JOIN dbo.[FormPlusProduct] as FPP WITH (NOLOCK)  on FPP.IdProduct = P.Id
		INNER JOIN dbo.[FormPlus] as FP WITH (NOLOCK)  on FP.Id = FPP.IdFormPlus
		INNER JOIN dbo.[AssignedForm] as AF WITH (NOLOCK) on AF.[IdForm] = FP.[IdForm]
		INNER JOIN dbo.[Form] F WITH (NOLOCK) ON F.[Id] = AF.[IdForm]
		LEFT JOIN dbo.[User] U WITH (NOLOCK) ON U.[Id] = F.[IdUser]
		LEFT JOIN dbo.[FormCategory] FC WITH (NOLOCK) ON FC.[Id] = F.[IdFormCategory]
		LEFT JOIN [dbo].[CompletedForm] CF WITH (NOLOCK) ON CF.IdForm = F.Id AND CF.IdPersonOfInterest = @IdPersonOfInterest AND CF.IdPointOfInterest = @IdPointOfInterest AND CF.IdProduct = @IdProduct AND Tzdb.AreSameSystemDates(CF.[Date], @Now) = 1
		LEFT JOIN [dbo].[CompletedForm] CF2 WITH (NOLOCK) ON CF2.IdForm = F.Id AND CF2.IdPointOfInterest = @IdPointOfInterest AND CF2.IdProduct = @IdProduct AND Tzdb.AreSameSystemDates(CF2.[Date], @Now) = 1
		WHERE P.[Id] = @IdProduct AND F.[Deleted] = 0 AND AF.Deleted = 0
						  AND AF.IdPersonOfInterest = @IdPersonOfInterest AND F.AllPointOfInterest = 1 
						  AND AF.IdPointOfInterest IS NULL
						  AND Tzdb.IsLowerOrSameSystemDate(F.[StartDate], @Now) = 1 
						  AND Tzdb.IsGreaterOrSameSystemDate(F.[EndDate], @Now) = 1 --Tiene que ser un formulario activo
	
		GROUP BY	F.[Id], F.[Name], U.[Name], U.[LastName], F.[Date], F.[IdFormCategory], F.[IsFormPlus],
						FC.[Name], CF.IdForm, F.[OneTimeAnswer], F.[CompleteMultipleTimes], CF2.[IdForm],
				F.[Description], F.[IsWeighted], F.[StartDate], F.[EndDate]
		UNION
		SELECT F.[Id] AS FormId, F.[Name] AS FormName,  U.[Name] AS UserName, U.[LastName] AS UserLastName, 
						F.[Date] AS FormDate, F.[Description] AS FormDescription, F.[IsFormPlus],
						F.[IdFormCategory], FC.[Name] AS FormCategoryName,  F.[OneTimeAnswer], 
						F.[CompleteMultipleTimes], F.[StartDate], F.[EndDate],
						CASE 
							WHEN CF.[IdForm] IS NOT NULL THEN 1 					
							ELSE 0
						END AS FormHasBeenCompleted,
						CASE 
							WHEN CF2.[IdForm] IS NOT NULL AND F.[OneTimeAnswer] = 1 THEN 1 					
							ELSE 0
						END AS FormIsCompletedOneTime, F.[IsWeighted]
		FROM dbo.[Product] as P
		INNER JOIN dbo.[CatalogProduct] as CP WITH (NOLOCK) on CP.IdProduct = P.Id
		INNER JOIN dbo.[FormPlusCatalog] as FPC WITH (NOLOCK) on FPC.IdCatalog = CP.IdCatalog
		INNER JOIN dbo.[FormPlus] as FP WITH (NOLOCK) on FP.Id = FPC.IdFormPlus
		INNER JOIN dbo.[AssignedForm] as AF WITH (NOLOCK) on AF.[IdForm] = FP.[IdForm]
		INNER JOIN dbo.[Form] F WITH (NOLOCK) ON F.[Id] = AF.[IdForm]
		LEFT JOIN dbo.[User] U WITH (NOLOCK) ON U.[Id] = F.[IdUser]
		LEFT JOIN dbo.[FormCategory] FC WITH (NOLOCK) ON FC.[Id] = F.[IdFormCategory]
		LEFT JOIN [dbo].[CompletedForm] CF WITH (NOLOCK) ON CF.IdForm = F.Id AND CF.IdPersonOfInterest = @IdPersonOfInterest AND CF.IdPointOfInterest = @IdPointOfInterest AND CF.IdProduct = @IdProduct AND Tzdb.AreSameSystemDates(CF.[Date], @Now) = 1
		LEFT JOIN [dbo].[CompletedForm] CF2 WITH (NOLOCK) ON CF2.IdForm = F.Id AND CF2.IdPointOfInterest = @IdPointOfInterest AND CF2.IdProduct = @IdProduct AND Tzdb.AreSameSystemDates(CF2.[Date], @Now) = 1
		WHERE P.[Id] = @IdProduct AND F.[Deleted] = 0 AND AF.Deleted = 0
						  AND AF.IdPersonOfInterest = @IdPersonOfInterest AND F.AllPointOfInterest = 1 
						  AND AF.IdPointOfInterest IS NULL
						  AND Tzdb.IsLowerOrSameSystemDate(F.[StartDate], @Now) = 1 
						  AND Tzdb.IsGreaterOrSameSystemDate(F.[EndDate], @Now) = 1 --Tiene que ser un formulario activo
	
		GROUP BY	F.[Id], F.[Name], U.[Name], U.[LastName], F.[Date], F.[IdFormCategory], F.[IsFormPlus],
						FC.[Name], CF.IdForm, F.[OneTimeAnswer], F.[CompleteMultipleTimes], CF2.[IdForm],
				F.[Description], F.[IsWeighted], F.[StartDate], F.[EndDate]
	END
