/****** Object:  Procedure [dbo].[GetFormsChartData]    Committed by VersionSQL https://www.versionsql.com ******/

-- Stored Procedure

-- =============================================
-- Author:		Gaston Legnani
-- Create date: 16/10/2015
-- Description:	SP para obtener la información para la gráfica de formularios
-- =============================================
CREATE PROCEDURE [dbo].[GetFormsChartData]

	 @DateFrom [sys].[datetime] = NULL
	,@DateTo [sys].[datetime] = NULL,
	@IdUser [sys].[INT] = NULL
AS
BEGIN
	DECLARE @IdUserAux [sys].[INT] = @IdUser

	SELECT F.[Id] AS FormId, F.[Name] AS FormName, COUNT(DISTINCT CF.IdPointOfInterest) AS CompletedPointsQuantity, 
	(SELECT COUNT(DISTINCT AF.IdPointOfInterest) FROM [dbo].[AssignedForm] AF WITH (NOLOCK) WHERE AF.IdForm = F.Id AND Tzdb.IsLowerOrSameSystemDate(AF.[Date], @DateTo) = 1) AS AssignedPointsQuantity
	FROM [dbo].[Form] F WITH (NOLOCK)
	LEFT JOIN [dbo].[CompletedForm] CF WITH (NOLOCK) ON F.Id = CF.[IdForm]
	LEFT JOIN [dbo].[PointOfInterest] P WITH (NOLOCK) ON P.[Id] = CF.[IdPointOfInterest]
	LEFT JOIN [dbo].[PersonOfInterest] S WITH (NOLOCK) ON S.[Id] = CF.[IdPersonOfInterest]	
	WHERE 
	--Tiene que tener en cuenta formularios que hayan sido completados dentro de las fechas, y que hayan sido asignados en una
	--fecha previa a la fecha de fin seleccionada. Si se tiene en cuenta solo formularios asignados entre determinadas fechas,  dejamos afuera todos los asignados de antes pero que se mantienen asignados.
	--(CAST(Tzdb.FromUtc(CF.[Date]) AS [sys].[date]) BETWEEN CAST(Tzdb.FromUtc(@DateFrom) AS [sys].[date]) AND CAST(Tzdb.FromUtc(@DateTo) AS [sys].[date])) AND 
	(CF.[Date] BETWEEN @DateFrom AND @DateTo) AND
	((@IdUserAux IS NULL) OR (dbo.CheckUserInPointOfInterestZones(CF.[IdPointOfInterest], @IdUserAux) = 1)) AND
	((@IdUserAux IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUserAux) = 1)) AND
    ((@IdUserAux IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUserAux) = 1)) AND
	((@IdUserAux IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUserAux) = 1))
	AND P.Deleted = 0 AND S.Deleted = 0 AND	F.[DeletedDate] IS NULL
	GROUP BY	F.[Id], F.[Name]
	ORDER BY	F.[Name] 


	-- Metodo que daba TimeOut al dia 2016-02-24
	--SELECT F.[Id] AS FormId, F.[Name] AS FormName, COUNT(DISTINCT CF.IdPointOfInterest) AS CompletedPointsQuantity , 
	--COUNT(DISTINCT AF.IdPointOfInterest) AS AssignedPointsQuantity
	--FROM [dbo].[Form] F
	--LEFT JOIN [dbo].[AssignedForm] AF ON F.[Id] = AF.[IdForm]
	--LEFT JOIN [dbo].[CompletedForm] CF ON F.Id = CF.[IdForm]
	--LEFT JOIN [dbo].[PointOfInterest] P ON P.[Id] = CF.[IdPointOfInterest]
	--LEFT JOIN [dbo].[PersonOfInterest] S ON S.[Id] = CF.[IdPersonOfInterest]
	--WHERE 
	----Tiene que tener en cuenta formularios que hayan sido completados dentro de las fechas, y que hayan sido asignados en una
	----fecha previa a la fecha de fin seleccionada. Si se tiene en cuenta solo formularios asignados entre determinadas fechas,  dejamos afuera todos los asignados de antes pero que se mantienen asignados.
	--((CAST(CF.[Date] AS [sys].[sys].[date]) BETWEEN CAST(@DateFrom AS [sys].[sys].[date]) AND CAST(@DateTo AS [sys].[date])) AND
	--(CAST(AF.[Date] AS [sys].[sys].[date]) < CAST(@DateTo AS [sys].[sys].[date]))) AND 
	----(CAST(AF.[Date] AS [sys].[date]) BETWEEN CAST(@DateFrom AS [sys].[date]) AND CAST(@DateTo AS [sys].[sys].[date]))) AND
	--((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(CF.[IdPointOfInterest], @IdUser) = 1)) AND
	--((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1)) AND
 --   ((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1)) AND
	--((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1))
	--AND P.Deleted = 0 AND S.Deleted = 0 AND	F.[DeletedDate] IS NULL
	--GROUP BY	F.[Id], F.[Name]
	--ORDER BY	F.[Name] 

END
