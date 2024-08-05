/****** Object:  TableFunction [dbo].[PointsOfInterestActivityDoneSimplified]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		JP
-- Create date: 03/08/2020
-- Description:	Mismo que PointsOfInterestActivityDone pero con menos datos
-- =============================================
CREATE FUNCTION [dbo].[PointsOfInterestActivityDoneSimplified]
(	
	 @DateFrom [sys].[datetime] 
	,@DateTo [sys].[datetime]
	,@IdDepartments [sys].[varchar](max) = NULL
	,@Types [sys].[varchar](max) = NULL
	,@IdPersonsOfInterest [sys].[varchar](max) = NULL
	,@IdPointsOfInterest [sys].[varchar](max) = NULL
	,@IdUser [sys].[int] = NULL
)
RETURNS @t TABLE (IdPersonOfInterest [sys].[int], [IdPointOfInterest] [sys].[int],
			[ActionDate] [sys].[datetime], [ConfirmedVisit] [sys].[bit])	
AS
BEGIN
	;WITH vPersons AS
	(
		SELECT	S.[Id]
		FROM	[dbo].[PersonOfInterest] S WITH (NOLOCK)
		WHERE	((@IdDepartments IS NULL) OR (S.[IdDepartment] IS NULL) OR (dbo.CheckValueInList(S.[IdDepartment], @IdDepartments) = 1)) AND
				((@Types IS NULL) OR (dbo.CheckCharValueInList(S.[Type], @Types) = 1)) AND
				((@IdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(S.[Id], @IdPersonsOfInterest) = 1)) AND
				((@IdUser IS NULL) OR ((dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1) AND
					(dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1)))
	),
	vPoints AS
	(
		SELECT	P.[Id]
		FROM	[dbo].[PointOfInterest] P WITH (NOLOCK)
		WHERE	((@IdPointsOfInterest IS NULL) OR (dbo.CheckValueInList(P.[Id], @IdPointsOfInterest) = 1)) AND
				((@IdUser IS NULL) OR ((dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1) AND
					(dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1)))
	)

	INSERT INTO @t 
	
	-- Tareas
	SELECT		CF.[IdPersonOfInterest], CF.[IdPointOfInterest], CF.[StartDate] as ActionDate, 1 AS ConfirmedVisit
	
	FROM		dbo.[CompletedForm] CF WITH (NOLOCK)
				INNER JOIN vPoints P WITH (NOLOCK) ON P.[Id] = CF.[IdPointOfInterest]
				INNER JOIN vPersons S WITH (NOLOCK) ON S.[Id] = CF.[IdPersonOfInterest]
	
	WHERE		CF.[StartDate] >= @DateFrom AND CF.[StartDate] <= @DateTo

	GROUP BY	CF.[IdPersonOfInterest], CF.[IdPointOfInterest], CF.[StartDate]

	UNION

	-- Stock
	SELECT		CF.[IdPersonOfInterest], CF.[IdPointOfInterest], CF.[ReportDateTime] as ActionDate, 1 AS ConfirmedVisit
	
	FROM		dbo.[ProductReportDynamic] CF WITH (NOLOCK)
				INNER JOIN vPoints P WITH (NOLOCK) ON P.[Id] = CF.[IdPointOfInterest]
				INNER JOIN vPersons S WITH (NOLOCK) ON S.[Id] = CF.[IdPersonOfInterest]
	
	WHERE		CF.[ReportDateTime] >= @DateFrom AND CF.[ReportDateTime] <= @DateTo

	GROUP BY	CF.[IdPersonOfInterest], CF.[IdPointOfInterest], CF.[ReportDateTime]

	UNION

	-- Activos
	SELECT		CF.[IdPersonOfInterest], CF.[IdPointOfInterest], CF.[Date] as ActionDate, 1 AS ConfirmedVisit
	
	FROM		dbo.[AssetReport] CF WITH (NOLOCK)
				INNER JOIN vPoints P WITH (NOLOCK) ON P.[Id] = CF.[IdPointOfInterest]
				INNER JOIN vPersons S WITH (NOLOCK) ON S.[Id] = CF.[IdPersonOfInterest]
	
	WHERE		CF.[Date] >= @DateFrom AND CF.[Date] <= @DateTo

	GROUP BY	CF.[IdPersonOfInterest], CF.[IdPointOfInterest], CF.[Date]

	UNION

	-- Observaciones
	SELECT		CF.[IdPersonOfInterest], CF.[IdPointOfInterest], CF.[CreatedDate] as ActionDate, 1 AS ConfirmedVisit
	
	FROM		dbo.[Incident] CF WITH (NOLOCK)
				INNER JOIN vPoints P WITH (NOLOCK) ON P.[Id] = CF.[IdPointOfInterest]
				INNER JOIN vPersons S WITH (NOLOCK) ON S.[Id] = CF.[IdPersonOfInterest]
	
	WHERE		CF.[CreatedDate] >= @DateFrom AND CF.[CreatedDate] <= @DateTo

	GROUP BY	CF.[IdPersonOfInterest], CF.[IdPointOfInterest], CF.[CreatedDate]

	UNION

	-- Documentos
	SELECT		CF.[IdPersonOfInterest], CF.[IdPointOfInterest], CF.[Date] as ActionDate, 1 AS ConfirmedVisit
	
	FROM		dbo.[DocumentReport] CF WITH (NOLOCK)
				INNER JOIN vPoints P WITH (NOLOCK) ON P.[Id] = CF.[IdPointOfInterest]
				INNER JOIN vPersons S WITH (NOLOCK) ON S.[Id] = CF.[IdPersonOfInterest]
	
	WHERE		CF.[Date] >= @DateFrom AND CF.[Date] <= @DateTo

	GROUP BY	CF.[IdPersonOfInterest], CF.[IdPointOfInterest], CF.[Date]

	UNION

	-- Devoluciones
	SELECT		CF.[IdPersonOfInterest], CF.[IdPointOfInterest], CF.[Date] as ActionDate, 1 AS ConfirmedVisit
	
	FROM		dbo.[ProductRefund] CF WITH (NOLOCK)
				INNER JOIN vPoints P WITH (NOLOCK) ON P.[Id] = CF.[IdPointOfInterest]
				INNER JOIN vPersons S WITH (NOLOCK) ON S.[Id] = CF.[IdPersonOfInterest]
	
	WHERE		CF.[Date] >= @DateFrom AND CF.[Date] <= @DateTo

	GROUP BY	CF.[IdPersonOfInterest], CF.[IdPointOfInterest], CF.[Date]

	UNION

	-- Faltantes
	SELECT		CF.[IdPersonOfInterest], CF.[IdPointOfInterest], CF.[Date] as ActionDate, 1 AS ConfirmedVisit
	
	FROM		dbo.[ProductMissingPointOfInterest] CF WITH (NOLOCK)
				INNER JOIN vPoints P WITH (NOLOCK) ON P.[Id] = CF.[IdPointOfInterest]
				INNER JOIN vPersons S WITH (NOLOCK) ON S.[Id] = CF.[IdPersonOfInterest]
	
	WHERE		CF.[Date] >= @DateFrom AND CF.[Date] <= @DateTo

	GROUP BY	CF.[IdPersonOfInterest], CF.[IdPointOfInterest], CF.[Date]

	UNION

	-- foto antes y despues
	SELECT		CF.[IdPersonOfInterest], CF.[IdPointOfInterest], CF.[ReportDate] as ActionDate, 1 AS ConfirmedVisit
	
	FROM		dbo.[PhotoReport] CF WITH (NOLOCK)
				INNER JOIN vPoints P WITH (NOLOCK) ON P.[Id] = CF.[IdPointOfInterest]
				INNER JOIN vPersons S WITH (NOLOCK) ON S.[Id] = CF.[IdPersonOfInterest]
	
	WHERE		CF.[ReportDate] >= @DateFrom AND CF.[ReportDate] <= @DateTo

	GROUP BY	CF.[IdPersonOfInterest], CF.[IdPointOfInterest], CF.[ReportDate]


	RETURN 
END
