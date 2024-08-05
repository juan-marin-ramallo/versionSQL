/****** Object:  TableFunction [dbo].[PointsOfInterestActivityDone]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		G
-- Create date: 12/03/2018
-- Description:	Function para obtener todas las actividades realizadas por una persona según filtros
-- =============================================
CREATE FUNCTION [dbo].[PointsOfInterestActivityDone]
(	
	 @DateFrom [sys].[datetime] 
	,@DateTo [sys].[datetime]
	,@IdDepartments [sys].[varchar](max) = NULL
	,@Types [sys].[varchar](max) = NULL
	,@IdPersonsOfInterest [sys].[varchar](max) = NULL
	,@IdPointsOfInterest [sys].[varchar](max) = NULL
	,@IdUser [sys].[int] = NULL
)
RETURNS @t TABLE (IdPersonOfInterest [sys].[int], PersonOfInterestName [sys].[varchar](50), 
			PersonOfInterestLastName [sys].[varchar](50), [ActionDate] [sys].[datetime], 
			[IdDepartment] [sys].[INT], [Latitude] [sys].[decimal](25,20), 
			[Longitude] [sys].[decimal](25,20),[Address] [sys].[varchar](250),
			[IdPointOfInterest] [sys].[int], 
			[PointOfInterestName] [sys].[varchar](100),
			PointOfInterestIdentifier [sys].[varchar](50), AutomaticValue [sys].[int], Reason [sys].[varchar](100),
			ConfirmedVisit [sys].[bit])	
AS
BEGIN
	DECLARE @CompletesTaskText [sys].[varchar](5000)
	SET @CompletesTaskText = dbo.GetCommonTextTranslated('ItCompletesTask')

	DECLARE @ProductReportText [sys].[varchar](5000)
	SET @ProductReportText = dbo.GetCommonTextTranslated('ProductReport')

	DECLARE @AssetReportText [sys].[varchar](5000)
	SET @AssetReportText = dbo.GetCommonTextTranslated('AssetReport')

	DECLARE @ObservationsText [sys].[varchar](5000)
	SET @ObservationsText = dbo.GetCommonTextTranslated('Observations')

	DECLARE @DocumentsComplianceText [sys].[varchar](5000)
	SET @DocumentsComplianceText = dbo.GetCommonTextTranslated('DocumentsCompliance')

	DECLARE @ProductRefundText [sys].[varchar](5000)
	SET @ProductRefundText = dbo.GetCommonTextTranslated('ProductRefund')

	DECLARE @ShortageText [sys].[varchar](5000)
	SET @ShortageText = dbo.GetCommonTextTranslated('Shortage')

	DECLARE @ComparationOfImagesText [sys].[varchar](5000)
	SET @ComparationOfImagesText = dbo.GetCommonTextTranslated('ComparationOfImages')

	INSERT INTO @t 
	
	-- Tareas
	SELECT		S.[Id] AS IdPersonOfInterest, S.[Name] AS PersonOfInterestName, 
				S.[LastName] AS PersonOfInterestLastName, CF.[StartDate] as ActionDate, 
				P.[IdDepartment], P.[Latitude], P.[Longitude], P.[Address],
				[IdPointOfInterest], P.[Name] AS PointOfInterestName, 
				P.[Identifier] AS PointOfInterestIdentifier, 3 AS AutomaticValue, @CompletesTaskText as Reason,
				1 AS ConfirmedVisit	
	
	FROM		dbo.[CompletedForm] CF 
				INNER JOIN [dbo].[PointOfInterest] P ON P.[Id] = CF.[IdPointOfInterest]
				INNER JOIN [dbo].[PersonOfInterest] S ON S.[Id] = CF.[IdPersonOfInterest]
	
	WHERE		CF.[StartDate] >= @DateFrom AND CF.[StartDate] <= @DateTo AND
				((@IdDepartments IS NULL) OR (S.[IdDepartment] IS NULL) OR (dbo.CheckValueInList(S.[IdDepartment], @IdDepartments) = 1)) AND
				((@Types IS NULL) OR (dbo.CheckCharValueInList(S.[Type], @Types) = 1)) AND
				((@IdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(S.[Id], @IdPersonsOfInterest) = 1)) AND
				((@IdPointsOfInterest IS NULL) OR (dbo.CheckValueInList(P.[Id], @IdPointsOfInterest) = 1)) AND			
				((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1))

	GROUP BY  S.[Id], S.[Name], S.[LastName], CF.[StartDate] , P.[Radius], p.[MinElapsedTimeForVisit], P.[IdDepartment],P.[Latitude], P.[Longitude], P.[Address],
	          [IdPointOfInterest], P.[Name], P.[Identifier]

	UNION

	-- Stock
	SELECT		S.[Id] AS IdPersonOfInterest, S.[Name] AS PersonOfInterestName, 
				S.[LastName] AS PersonOfInterestLastName, CF.[ReportDateTime] as ActionDate, 
				P.[IdDepartment], P.[Latitude], P.[Longitude], P.[Address],
				[IdPointOfInterest], P.[Name] AS PointOfInterestName, 
				P.[Identifier] AS PointOfInterestIdentifier, 4 AS AutomaticValue, @ProductReportText as Reason,
				1 AS ConfirmedVisit
	
	FROM		dbo.[ProductReportDynamic] CF 
				INNER JOIN [dbo].[PointOfInterest] P ON P.[Id] = CF.[IdPointOfInterest]
				INNER JOIN [dbo].[PersonOfInterest] S ON S.[Id] = CF.[IdPersonOfInterest]
	
	WHERE		CF.[ReportDateTime] >= @DateFrom AND CF.[ReportDateTime] <= @DateTo AND
				((@IdDepartments IS NULL) OR (S.[IdDepartment] IS NULL) OR (dbo.CheckValueInList(S.[IdDepartment], @IdDepartments) = 1)) AND
				((@Types IS NULL) OR (dbo.CheckCharValueInList(S.[Type], @Types) = 1)) AND
				((@IdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(S.[Id], @IdPersonsOfInterest) = 1)) AND
				((@IdPointsOfInterest IS NULL) OR (dbo.CheckValueInList(P.[Id], @IdPointsOfInterest) = 1)) AND			
				((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1))

	GROUP BY  S.[Id], S.[Name], S.[LastName], CF.[ReportDateTime] , P.[Radius], p.[MinElapsedTimeForVisit], P.[IdDepartment],P.[Latitude], P.[Longitude], P.[Address],
	          [IdPointOfInterest], P.[Name], P.[Identifier]

	UNION

	-- Activos
	SELECT		S.[Id] AS IdPersonOfInterest, S.[Name] AS PersonOfInterestName, 
				S.[LastName] AS PersonOfInterestLastName, CF.[Date] as ActionDate, 
				P.[IdDepartment], P.[Latitude], P.[Longitude], P.[Address],
				[IdPointOfInterest], P.[Name] AS PointOfInterestName, 
				P.[Identifier] AS PointOfInterestIdentifier, 5 AS AutomaticValue, @AssetReportText as Reason,
				1 AS ConfirmedVisit
	
	FROM		dbo.[AssetReport] CF 
				INNER JOIN [dbo].[PointOfInterest] P ON P.[Id] = CF.[IdPointOfInterest]
				INNER JOIN [dbo].[PersonOfInterest] S ON S.[Id] = CF.[IdPersonOfInterest]
	
	WHERE		CF.[Date] >= @DateFrom AND CF.[Date] <= @DateTo AND
				((@IdDepartments IS NULL) OR (S.[IdDepartment] IS NULL) OR (dbo.CheckValueInList(S.[IdDepartment], @IdDepartments) = 1)) AND
				((@Types IS NULL) OR (dbo.CheckCharValueInList(S.[Type], @Types) = 1)) AND
				((@IdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(S.[Id], @IdPersonsOfInterest) = 1)) AND
				((@IdPointsOfInterest IS NULL) OR (dbo.CheckValueInList(P.[Id], @IdPointsOfInterest) = 1)) AND			
				((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1))

	GROUP BY  S.[Id], S.[Name], S.[LastName], CF.[Date] , P.[Radius], p.[MinElapsedTimeForVisit], P.[IdDepartment], P.[Latitude], P.[Longitude], P.[Address],
	          [IdPointOfInterest], P.[Name], P.[Identifier]

	UNION

	-- Observaciones
	SELECT		S.[Id] AS IdPersonOfInterest, S.[Name] AS PersonOfInterestName, 
				S.[LastName] AS PersonOfInterestLastName, CF.[CreatedDate] as ActionDate, 
				P.[IdDepartment], P.[Latitude], P.[Longitude], P.[Address],
				[IdPointOfInterest], P.[Name] AS PointOfInterestName, 
				P.[Identifier] AS PointOfInterestIdentifier, 6 AS AutomaticValue, @ObservationsText as Reason,
				1 AS ConfirmedVisit
	
	FROM		dbo.[Incident] CF 
				INNER JOIN [dbo].[PointOfInterest] P ON P.[Id] = CF.[IdPointOfInterest]
				INNER JOIN [dbo].[PersonOfInterest] S ON S.[Id] = CF.[IdPersonOfInterest]
	
	WHERE		CF.[CreatedDate] >= @DateFrom AND CF.[CreatedDate] <= @DateTo AND
				((@IdDepartments IS NULL) OR (S.[IdDepartment] IS NULL) OR (dbo.CheckValueInList(S.[IdDepartment], @IdDepartments) = 1)) AND
				((@Types IS NULL) OR (dbo.CheckCharValueInList(S.[Type], @Types) = 1)) AND
				((@IdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(S.[Id], @IdPersonsOfInterest) = 1)) AND
				((@IdPointsOfInterest IS NULL) OR (dbo.CheckValueInList(P.[Id], @IdPointsOfInterest) = 1)) AND			
				((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1))

	GROUP BY  S.[Id], S.[Name], S.[LastName], CF.[CreatedDate], P.[Radius], p.[MinElapsedTimeForVisit], P.[IdDepartment], P.[Latitude], P.[Longitude], P.[Address],
	          [IdPointOfInterest], P.[Name], P.[Identifier]

	UNION

	-- Documentos
	SELECT		S.[Id] AS IdPersonOfInterest, S.[Name] AS PersonOfInterestName, 
				S.[LastName] AS PersonOfInterestLastName, CF.[Date] as ActionDate, 
				P.[IdDepartment], P.[Latitude], P.[Longitude], P.[Address],
				[IdPointOfInterest], P.[Name] AS PointOfInterestName, 
				P.[Identifier] AS PointOfInterestIdentifier, 7 AS AutomaticValue, @DocumentsComplianceText as Reason,
				1 AS ConfirmedVisit	
	
	FROM		dbo.[DocumentReport] CF 
				INNER JOIN [dbo].[PointOfInterest] P ON P.[Id] = CF.[IdPointOfInterest]
				INNER JOIN [dbo].[PersonOfInterest] S ON S.[Id] = CF.[IdPersonOfInterest]
	
	WHERE		CF.[Date] >= @DateFrom AND CF.[Date] <= @DateTo AND
				((@IdDepartments IS NULL) OR (S.[IdDepartment] IS NULL) OR (dbo.CheckValueInList(S.[IdDepartment], @IdDepartments) = 1)) AND
				((@Types IS NULL) OR (dbo.CheckCharValueInList(S.[Type], @Types) = 1)) AND
				((@IdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(S.[Id], @IdPersonsOfInterest) = 1)) AND
				((@IdPointsOfInterest IS NULL) OR (dbo.CheckValueInList(P.[Id], @IdPointsOfInterest) = 1)) AND			
				((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1))

	GROUP BY  S.[Id], S.[Name], S.[LastName], CF.[Date] , P.[Radius], p.[MinElapsedTimeForVisit], P.[IdDepartment],P.[Latitude], P.[Longitude], P.[Address],
	          [IdPointOfInterest], P.[Name], P.[Identifier]

	UNION

	-- Devoluciones
	SELECT		S.[Id] AS IdPersonOfInterest, S.[Name] AS PersonOfInterestName, 
				S.[LastName] AS PersonOfInterestLastName, CF.[Date] as ActionDate, 
				P.[IdDepartment], P.[Latitude], P.[Longitude], P.[Address],
				[IdPointOfInterest], P.[Name] AS PointOfInterestName, 
				P.[Identifier] AS PointOfInterestIdentifier, 8 AS AutomaticValue, @ProductRefundText as Reason,
				1 AS ConfirmedVisit
	
	FROM		dbo.[ProductRefund] CF 
				INNER JOIN [dbo].[PointOfInterest] P ON P.[Id] = CF.[IdPointOfInterest]
				INNER JOIN [dbo].[PersonOfInterest] S ON S.[Id] = CF.[IdPersonOfInterest]
	
	WHERE		CF.[Date] >= @DateFrom AND CF.[Date] <= @DateTo AND
				((@IdDepartments IS NULL) OR (S.[IdDepartment] IS NULL) OR (dbo.CheckValueInList(S.[IdDepartment], @IdDepartments) = 1)) AND
				((@Types IS NULL) OR (dbo.CheckCharValueInList(S.[Type], @Types) = 1)) AND
				((@IdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(S.[Id], @IdPersonsOfInterest) = 1)) AND
				((@IdPointsOfInterest IS NULL) OR (dbo.CheckValueInList(P.[Id], @IdPointsOfInterest) = 1)) AND			
				((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1))

	GROUP BY  S.[Id], S.[Name], S.[LastName], CF.[Date] , P.[Radius], p.[MinElapsedTimeForVisit], P.[IdDepartment], P.[Latitude], P.[Longitude], P.[Address],
	          [IdPointOfInterest], P.[Name], P.[Identifier]

	UNION

	-- Faltantes
	SELECT		S.[Id] AS IdPersonOfInterest, S.[Name] AS PersonOfInterestName, 
				S.[LastName] AS PersonOfInterestLastName, CF.[Date] as ActionDate, 
				P.[IdDepartment], P.[Latitude], P.[Longitude], P.[Address],
				[IdPointOfInterest], P.[Name] AS PointOfInterestName, 
				P.[Identifier] AS PointOfInterestIdentifier, 9 AS AutomaticValue, @ShortageText as Reason,
				1 AS ConfirmedVisit
	
	FROM		dbo.[ProductMissingPointOfInterest] CF 
				INNER JOIN [dbo].[PointOfInterest] P ON P.[Id] = CF.[IdPointOfInterest]
				INNER JOIN [dbo].[PersonOfInterest] S ON S.[Id] = CF.[IdPersonOfInterest]
	
	WHERE		CF.[Date] >= @DateFrom AND CF.[Date] <= @DateTo AND
				((@IdDepartments IS NULL) OR (S.[IdDepartment] IS NULL) OR (dbo.CheckValueInList(S.[IdDepartment], @IdDepartments) = 1)) AND
				((@Types IS NULL) OR (dbo.CheckCharValueInList(S.[Type], @Types) = 1)) AND
				((@IdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(S.[Id], @IdPersonsOfInterest) = 1)) AND
				((@IdPointsOfInterest IS NULL) OR (dbo.CheckValueInList(P.[Id], @IdPointsOfInterest) = 1)) AND			
				((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1))

	GROUP BY  S.[Id], S.[Name], S.[LastName], CF.[Date] , P.[Radius], p.[MinElapsedTimeForVisit], P.[IdDepartment], P.[Latitude], P.[Longitude], P.[Address],
	          [IdPointOfInterest], P.[Name], P.[Identifier]

	UNION

	-- foto antes y despues
	SELECT		S.[Id] AS IdPersonOfInterest, S.[Name] AS PersonOfInterestName, 
				S.[LastName] AS PersonOfInterestLastName, CF.[ReportDate] as ActionDate, 
				P.[IdDepartment], P.[Latitude], P.[Longitude], P.[Address],
				[IdPointOfInterest], P.[Name] AS PointOfInterestName, 
				P.[Identifier] AS PointOfInterestIdentifier, 10 AS AutomaticValue, @ComparationOfImagesText as Reason,
				1 AS ConfirmedVisit
	
	FROM		dbo.[PhotoReport] CF 
				INNER JOIN [dbo].[PointOfInterest] P ON P.[Id] = CF.[IdPointOfInterest]
				INNER JOIN [dbo].[PersonOfInterest] S ON S.[Id] = CF.[IdPersonOfInterest]
	
	WHERE		CF.[ReportDate] >= @DateFrom AND CF.[ReportDate] <= @DateTo AND
				((@IdDepartments IS NULL) OR (S.[IdDepartment] IS NULL) OR (dbo.CheckValueInList(S.[IdDepartment], @IdDepartments) = 1)) AND
				((@Types IS NULL) OR (dbo.CheckCharValueInList(S.[Type], @Types) = 1)) AND
				((@IdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(S.[Id], @IdPersonsOfInterest) = 1)) AND
				((@IdPointsOfInterest IS NULL) OR (dbo.CheckValueInList(P.[Id], @IdPointsOfInterest) = 1)) AND			
				((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1))

	GROUP BY  S.[Id], S.[Name], S.[LastName], CF.[ReportDate] , P.[Radius], p.[MinElapsedTimeForVisit], P.[IdDepartment], P.[Latitude], P.[Longitude], P.[Address],
	          [IdPointOfInterest], P.[Name], P.[Identifier]


	RETURN 
END
