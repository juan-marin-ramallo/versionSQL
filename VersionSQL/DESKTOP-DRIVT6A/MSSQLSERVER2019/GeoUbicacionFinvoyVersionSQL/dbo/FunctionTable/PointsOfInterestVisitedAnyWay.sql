/****** Object:  TableFunction [dbo].[PointsOfInterestVisitedAnyWay]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		G
-- Create date: 23/01/2017
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[PointsOfInterestVisitedAnyWay]
(	
	 @DateFrom [sys].[datetime] 
	,@DateTo [sys].[datetime]
	,@IdDepartments [sys].[varchar](max) = NULL
	,@Types [sys].[varchar](max) = NULL
	,@IdPersonsOfInterest [sys].[varchar](max) = NULL
	,@IdPointsOfInterest [sys].[varchar](max) = NULL
	,@IncludeAutomaticVisits [sys].[bit] = 1
	,@IdUser [sys].[int] = NULL
)
RETURNS @t TABLE (IdPointOfInterestVisited [sys].[int], IdPersonOfInterest [sys].[int], PersonOfInterestName [sys].[varchar](50), 
			PersonOfInterestLastName [sys].[varchar](50),PersonOfInterestIdentifier [sys].[varchar](20), 
			[ActionDate] [sys].[datetime],[Radius] [sys].[int], 
			[MinElapsedTimeForVisit] [sys].[int], [IdDepartment] [sys].[INT], [Latitude] [sys].[decimal](25,20), 
			[Longitude] [sys].[decimal](25,20),[Address] [sys].[varchar](250),
			LocationInDate [sys].[datetime], LocationOutDate [sys].[datetime], [IdPointOfInterest] [sys].[int], 
			[PointOfInterestName] [sys].[varchar](100), [ElapsedTime] [sys].[time], 
			PointOfInterestIdentifier [sys].[varchar](50), AutomaticValue [sys].[int], Reason [sys].[varchar](100))	
AS
BEGIN
	DECLARE @MarkedVisitedAutomaticCheckInOutText [sys].[varchar](5000)
	SET @MarkedVisitedAutomaticCheckInOutText = dbo.GetCommonTextTranslated('MarkedVisited_AutomaticCheckInOut')

	DECLARE @MarkedVisitedTaskComplianceText [sys].[varchar](5000)
	SET @MarkedVisitedTaskComplianceText = dbo.GetCommonTextTranslated('MarkedVisited_TaskCompliance')

	DECLARE @MarkedVisitedProductReportText [sys].[varchar](5000)
	SET @MarkedVisitedProductReportText = dbo.GetCommonTextTranslated('MarkedVisited_ProductReport')

	DECLARE @MarkedVisitedAssetReportText [sys].[varchar](5000)
	SET @MarkedVisitedAssetReportText = dbo.GetCommonTextTranslated('MarkedVisited_AssetReport')

	DECLARE @MarkedVisitedManualCheckInOutText [sys].[varchar](5000)
	SET @MarkedVisitedManualCheckInOutText = dbo.GetCommonTextTranslated('MarkedVisited_ManualCheckInOut')

	DECLARE @MarkedVisitedObservationText [sys].[varchar](5000)
	SET @MarkedVisitedObservationText = dbo.GetCommonTextTranslated('MarkedVisited_Observation')

	DECLARE @MarkedVisitedNfcCheckInOutText [sys].[varchar](5000)
	SET @MarkedVisitedNfcCheckInOutText = dbo.GetCommonTextTranslated('MarkedVisited_NfcCheckInOut')

	DECLARE @MarkedVisitedProductRefundText [sys].[varchar](5000)
	SET @MarkedVisitedProductRefundText = dbo.GetCommonTextTranslated('MarkedVisited_ProductRefund')

	DECLARE @MarkedVisitedDocumentReportText [sys].[varchar](5000)
	SET @MarkedVisitedDocumentReportText = dbo.GetCommonTextTranslated('MarkedVisited_DocumentReport')

	DECLARE @MarkedVisitedComparationOfImagesReportText [sys].[varchar](5000)
	SET @MarkedVisitedComparationOfImagesReportText = dbo.GetCommonTextTranslated('MarkedVisited_ComparationOfImagesReport')

	DECLARE @MarkedVisitedShortageReportText [sys].[varchar](5000)
	SET @MarkedVisitedShortageReportText = dbo.GetCommonTextTranslated('MarkedVisited_ShortageReport')

	INSERT INTO @t 
	
	SELECT	POIV.[Id] as IdPointOfInterestVisited, S.[Id] AS IdPersonOfInterest, S.[Name] AS PersonOfInterestName, 
			S.[LastName] AS PersonOfInterestLastName, S.[Identifier] AS PersonOfInterestIdentifier, 
			POIV.[LocationInDate] as ActionDate, P.[Radius], 
			P.[MinElapsedTimeForVisit], P.[IdDepartment], P.[Latitude], P.[Longitude], P.[Address],
			POIV.[LocationInDate] as LocationInDate, POIV.[LocationOutDate] as LocationOutDate,
			[IdPointOfInterest], P.[Name] AS PointOfInterestName, POIV.[ElapsedTime], 
			P.[Identifier] AS PointOfInterestIdentifier, 1 AS AutomaticValue, @MarkedVisitedAutomaticCheckInOutText as Reason	
	
	FROM	[dbo].[PointOfInterestVisited] POIV WITH (NOLOCK)
			INNER JOIN [dbo].[PointOfInterest] P WITH (NOLOCK) ON P.[Id] = POIV.[IdPointOfInterest]
			LEFT OUTER JOIN [dbo].[PersonOfInterest] S WITH (NOLOCK) ON S.[Id] = POIV.[IdPersonOfInterest]

	WHERE	@IncludeAutomaticVisits = 1 -- Only select something if @IncludeAutomaticVisits = 1
			AND 
			POIV.DeletedByNotVisited = 0 AND ((POIV.[LocationOutDate] IS NULL AND POIV.[LocationInDate] >= @DateFrom AND POIV.[LocationInDate] <= @DateTo) 
				OR (POIV.[LocationInDate] BETWEEN @DateFrom AND @DateTo) 
				OR (POIV.[LocationOutDate] BETWEEN @DateFrom AND @DateTo)) AND
			((@IdDepartments IS NULL) OR (S.[IdDepartment] IS NULL) OR (dbo.CheckValueInList(S.[IdDepartment], @IdDepartments) = 1)) AND
			((@Types IS NULL) OR (dbo.CheckCharValueInList(S.[Type], @Types) = 1)) AND
			((@IdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(S.[Id], @IdPersonsOfInterest) = 1)) AND
			((@IdPointsOfInterest IS NULL) OR (dbo.CheckValueInList(P.[Id], @IdPointsOfInterest) = 1)) AND			
			((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1)) AND
			((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1)) AND
			((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1)) AND
			((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1)) AND
			[dbo].IsVisitedLocationInPointHourWindow(POIV.[IdPointOfInterest], POIV.[LocationInDate], POIV.[LocationOutDate]) = 1 

	GROUP BY  POIV.[Id], S.[Id], S.[Name], S.[LastName], S.[Identifier], POIV.[LocationInDate], P.[Radius], p.[MinElapsedTimeForVisit], 
			P.[IdDepartment], P.[Latitude], P.[Longitude], P.[Address],
	          [IdPointOfInterest], P.[Name], P.[Identifier], POIV.[ElapsedTime], POIV.[LocationInDate],POIV.[LocationOutDate]

	UNION

	-- Tareas
	SELECT		0 as IdPointOfInterestVisited, S.[Id] AS IdPersonOfInterest, S.[Name] AS PersonOfInterestName, 
				S.[LastName] AS PersonOfInterestLastName, S.[Identifier] AS PersonOfInterestIdentifier, CF.[StartDate] as ActionDate, P.[Radius], 
				P.[MinElapsedTimeForVisit], P.[IdDepartment], P.[Latitude], P.[Longitude], P.[Address],
				CF.[StartDate] AS LocationInDate, CF.[StartDate] as LocationOutDate,
				[IdPointOfInterest], P.[Name] AS PointOfInterestName, NULL AS ElapsedTime, 
				P.[Identifier] AS PointOfInterestIdentifier, 3 AS AutomaticValue, @MarkedVisitedTaskComplianceText as Reason	

	FROM		dbo.[CompletedForm] CF WITH (NOLOCK) 
				INNER JOIN [dbo].[PointOfInterest] P WITH (NOLOCK) ON P.[Id] = CF.[IdPointOfInterest]
				INNER JOIN [dbo].[PersonOfInterest] S WITH (NOLOCK) ON S.[Id] = CF.[IdPersonOfInterest]

	WHERE		CF.[StartDate] >= @DateFrom AND CF.[StartDate] <= @DateTo AND
				((@IdDepartments IS NULL) OR (S.[IdDepartment] IS NULL) OR (dbo.CheckValueInList(S.[IdDepartment], @IdDepartments) = 1)) AND
				((@Types IS NULL) OR (dbo.CheckCharValueInList(S.[Type], @Types) = 1)) AND
				((@IdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(S.[Id], @IdPersonsOfInterest) = 1)) AND
				((@IdPointsOfInterest IS NULL) OR (dbo.CheckValueInList(P.[Id], @IdPointsOfInterest) = 1)) AND			
				((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1))

	GROUP BY  S.[Id], S.[Name], S.[LastName], S.[Identifier], CF.[StartDate] , P.[Radius], p.[MinElapsedTimeForVisit], P.[IdDepartment],P.[Latitude], P.[Longitude], P.[Address],
	          [IdPointOfInterest], P.[Name], P.[Identifier]

	UNION

	-- Stock
	SELECT		0 as IdPointOfInterestVisited, S.[Id] AS IdPersonOfInterest, S.[Name] AS PersonOfInterestName, 
				S.[LastName] AS PersonOfInterestLastName, S.[Identifier] AS PersonOfInterestIdentifier, CF.[ReportDateTime] as ActionDate, 
				P.[Radius], P.[MinElapsedTimeForVisit], P.[IdDepartment], P.[Latitude], P.[Longitude], P.[Address],
				CF.[ReportDateTime] AS LocationInDate, CF.[ReportDateTime] as LocationOutDate,
				[IdPointOfInterest], P.[Name] AS PointOfInterestName, NULL AS ElapsedTime, 
				P.[Identifier] AS PointOfInterestIdentifier, 4 AS AutomaticValue, @MarkedVisitedProductReportText as Reason	
	
	FROM		dbo.[ProductReportDynamic] CF WITH (NOLOCK) 
				INNER JOIN [dbo].[PointOfInterest] P WITH (NOLOCK) ON P.[Id] = CF.[IdPointOfInterest]
				INNER JOIN [dbo].[PersonOfInterest] S WITH (NOLOCK) ON S.[Id] = CF.[IdPersonOfInterest]

	WHERE		CF.[ReportDateTime] >= @DateFrom AND CF.[ReportDateTime] <= @DateTo AND
				((@IdDepartments IS NULL) OR (S.[IdDepartment] IS NULL) OR (dbo.CheckValueInList(S.[IdDepartment], @IdDepartments) = 1)) AND
				((@Types IS NULL) OR (dbo.CheckCharValueInList(S.[Type], @Types) = 1)) AND
				((@IdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(S.[Id], @IdPersonsOfInterest) = 1)) AND
				((@IdPointsOfInterest IS NULL) OR (dbo.CheckValueInList(P.[Id], @IdPointsOfInterest) = 1)) AND			
				((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1))

	GROUP BY  S.[Id], S.[Name], S.[LastName], S.[Identifier], CF.[ReportDateTime] , P.[Radius], p.[MinElapsedTimeForVisit], P.[IdDepartment],P.[Latitude], P.[Longitude], P.[Address],
	          [IdPointOfInterest], P.[Name], P.[Identifier]

	UNION

	-- Activos
	SELECT		0 as IdPointOfInterestVisited,S.[Id] AS IdPersonOfInterest, S.[Name] AS PersonOfInterestName, 
				S.[LastName] AS PersonOfInterestLastName, S.[Identifier] AS PersonOfInterestIdentifier, CF.[Date] as ActionDate, P.[Radius], 
				P.[MinElapsedTimeForVisit], P.[IdDepartment], P.[Latitude], P.[Longitude], P.[Address],
				CF.[Date] AS LocationInDate, CF.[Date] as LocationOutDate,
				[IdPointOfInterest], P.[Name] AS PointOfInterestName, NULL AS ElapsedTime, 
				P.[Identifier] AS PointOfInterestIdentifier, 5 AS AutomaticValue, @MarkedVisitedAssetReportText as Reason	
	
	FROM		dbo.[AssetReportDynamic] CF WITH (NOLOCK) 
				INNER JOIN [dbo].[PointOfInterest] P WITH (NOLOCK) ON P.[Id] = CF.[IdPointOfInterest]
				INNER JOIN [dbo].[PersonOfInterest] S WITH (NOLOCK) ON S.[Id] = CF.[IdPersonOfInterest]

	WHERE		CF.[Date] >= @DateFrom AND CF.[Date] <= @DateTo AND
				((@IdDepartments IS NULL) OR (S.[IdDepartment] IS NULL) OR (dbo.CheckValueInList(S.[IdDepartment], @IdDepartments) = 1)) AND
				((@Types IS NULL) OR (dbo.CheckCharValueInList(S.[Type], @Types) = 1)) AND
				((@IdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(S.[Id], @IdPersonsOfInterest) = 1)) AND
				((@IdPointsOfInterest IS NULL) OR (dbo.CheckValueInList(P.[Id], @IdPointsOfInterest) = 1)) AND			
				((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1))

	GROUP BY  S.[Id], S.[Name], S.[LastName], S.[Identifier], CF.[Date] , P.[Radius], p.[MinElapsedTimeForVisit], P.[IdDepartment], P.[Latitude], P.[Longitude], P.[Address],
	          [IdPointOfInterest], P.[Name], P.[Identifier]

	UNION

	-- Marcas Manuales
	SELECT	POIV.[Id] as IdPointOfInterestVisited, S.[Id] AS IdPersonOfInterest, S.[Name] AS PersonOfInterestName, 
			S.[LastName] AS PersonOfInterestLastName, S.[Identifier] AS PersonOfInterestIdentifier, POIV.[CheckInDate] as ActionDate, 
			P.[Radius], P.[MinElapsedTimeForVisit], P.[IdDepartment], P.[Latitude], P.[Longitude], P.[Address],
			POIV.[CheckInDate] AS LocationInDate, POIV.[CheckOutDate] as LocationOutDate,
			[IdPointOfInterest], P.[Name] AS PointOfInterestName, POIV.[ElapsedTime] AS ElapsedTime, 
			P.[Identifier] AS PointOfInterestIdentifier, 2 AS AutomaticValue, @MarkedVisitedManualCheckInOutText as Reason	
	
	FROM	[dbo].[PointOfInterestManualVisited] POIV WITH (NOLOCK) 
			INNER JOIN [dbo].[PointOfInterest] P WITH (NOLOCK) ON P.[Id] = POIV.[IdPointOfInterest]
			LEFT OUTER JOIN [dbo].[PersonOfInterest] S WITH (NOLOCK) ON S.[Id] = POIV.[IdPersonOfInterest]

	WHERE	POIV.DeletedByNotVisited = 0 AND ((POIV.[CheckOutDate] IS NULL AND POIV.[CheckInDate] >= @DateFrom AND POIV.[CheckInDate] <= @DateTo) 
				OR (POIV.[CheckInDate] BETWEEN @DateFrom AND @DateTo) 
				OR (POIV.[CheckOutDate] BETWEEN @DateFrom AND @DateTo)) AND
			((@IdDepartments IS NULL) OR (S.[IdDepartment] IS NULL) OR (dbo.CheckValueInList(S.[IdDepartment], @IdDepartments) = 1)) AND
			((@Types IS NULL) OR (dbo.CheckCharValueInList(S.[Type], @Types) = 1)) AND
			((@IdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(S.[Id], @IdPersonsOfInterest) = 1)) AND
			((@IdPointsOfInterest IS NULL) OR (dbo.CheckValueInList(P.[Id], @IdPointsOfInterest) = 1)) AND			
			((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1)) AND
			((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1)) AND
			((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1)) AND
			((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1)) AND
			[dbo].IsVisitedLocationInPointHourWindow(POIV.[IdPointOfInterest], POIV.[CheckInDate], POIV.[CheckOutDate]) = 1 	 

	GROUP BY  POIV.[Id], S.[Id], S.[Name], S.[LastName], S.[Identifier], POIV.[CheckInDate], P.[Radius], p.[MinElapsedTimeForVisit], P.[IdDepartment], P.[Latitude], P.[Longitude], P.[Address],
	          [IdPointOfInterest], P.[Name], P.[Identifier], POIV.[ElapsedTime], POIV.[CheckOutDate]

	UNION

	-- Observaciones
	SELECT		0 as IdPointOfInterestVisited, S.[Id] AS IdPersonOfInterest, S.[Name] AS PersonOfInterestName, 
				S.[LastName] AS PersonOfInterestLastName, S.[Identifier] AS PersonOfInterestIdentifier, CF.[CreatedDate] as ActionDate, 
				P.[Radius], P.[MinElapsedTimeForVisit], P.[IdDepartment], P.[Latitude], P.[Longitude], P.[Address],
				CF.[CreatedDate] AS LocationInDate, CF.[CreatedDate] as LocationOutDate,
				[IdPointOfInterest], P.[Name] AS PointOfInterestName, NULL AS ElapsedTime, 
				P.[Identifier] AS PointOfInterestIdentifier,6 AS AutomaticValue, @MarkedVisitedObservationText as Reason
	
	FROM		dbo.[Incident] CF WITH (NOLOCK) 
				INNER JOIN [dbo].[PointOfInterest] P WITH (NOLOCK) ON P.[Id] = CF.[IdPointOfInterest]
				INNER JOIN [dbo].[PersonOfInterest] S WITH (NOLOCK) ON S.[Id] = CF.[IdPersonOfInterest]

	WHERE		CF.[CreatedDate] >= @DateFrom AND CF.[CreatedDate] <= @DateTo AND
				((@IdDepartments IS NULL) OR (S.[IdDepartment] IS NULL) OR (dbo.CheckValueInList(S.[IdDepartment], @IdDepartments) = 1)) AND
				((@Types IS NULL) OR (dbo.CheckCharValueInList(S.[Type], @Types) = 1)) AND
				((@IdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(S.[Id], @IdPersonsOfInterest) = 1)) AND
				((@IdPointsOfInterest IS NULL) OR (dbo.CheckValueInList(P.[Id], @IdPointsOfInterest) = 1)) AND			
				((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1))

	GROUP BY  S.[Id], S.[Name], S.[LastName], S.[Identifier], CF.[CreatedDate], P.[Radius], p.[MinElapsedTimeForVisit], P.[IdDepartment], P.[Latitude], P.[Longitude], P.[Address],
	          [IdPointOfInterest], P.[Name], P.[Identifier]

	UNION

	-- Marcas Manuales NFC
	SELECT	POIV.[Id] as IdPointOfInterestVisited, S.[Id] AS IdPersonOfInterest, S.[Name] AS PersonOfInterestName, 
			S.[LastName] AS PersonOfInterestLastName, S.[Identifier] AS PersonOfInterestIdentifier, POIV.[CheckInDate] as ActionDate, 
			P.[Radius], P.[MinElapsedTimeForVisit], P.[IdDepartment], P.[Latitude], P.[Longitude], P.[Address],
			POIV.[CheckInDate] AS LocationInDate, POIV.[CheckOutDate] as LocationOutDate,
			[IdPointOfInterest], P.[Name] AS PointOfInterestName, POIV.[ElapsedTime] AS ElapsedTime, 
			P.[Identifier] AS PointOfInterestIdentifier, 2 AS AutomaticValue, @MarkedVisitedNfcCheckInOutText as Reason	
	
	FROM	[dbo].[PointOfInterestMark] POIV WITH (NOLOCK) 
			INNER JOIN [dbo].[PointOfInterest] P WITH (NOLOCK) ON P.[Id] = POIV.[IdPointOfInterest]
			LEFT OUTER JOIN [dbo].[PersonOfInterest] S WITH (NOLOCK) ON S.[Id] = POIV.[IdPersonOfInterest]

	WHERE	POIV.DeletedByNotVisited = 0 AND ((POIV.[CheckOutDate] IS NULL AND POIV.[CheckInDate] >= @DateFrom AND POIV.[CheckInDate] <= @DateTo) 
				OR (POIV.[CheckInDate] BETWEEN @DateFrom AND @DateTo) 
				OR (POIV.[CheckOutDate] BETWEEN @DateFrom AND @DateTo)) AND
			((@IdDepartments IS NULL) OR (S.[IdDepartment] IS NULL) OR (dbo.CheckValueInList(S.[IdDepartment], @IdDepartments) = 1)) AND
			((@Types IS NULL) OR (dbo.CheckCharValueInList(S.[Type], @Types) = 1)) AND
			((@IdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(S.[Id], @IdPersonsOfInterest) = 1)) AND
			((@IdPointsOfInterest IS NULL) OR (dbo.CheckValueInList(P.[Id], @IdPointsOfInterest) = 1)) AND			
			((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1)) AND
			((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1)) AND
			((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1)) AND
			((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1)) AND
			[dbo].IsVisitedLocationInPointHourWindow(POIV.[IdPointOfInterest], POIV.[CheckInDate], POIV.[CheckOutDate]) = 1 	 

	GROUP BY  POIV.[Id], S.[Id], S.[Name], S.[LastName], S.[Identifier], POIV.[CheckInDate], P.[Radius], p.[MinElapsedTimeForVisit], P.[IdDepartment], P.[Latitude], P.[Longitude], P.[Address],
	          [IdPointOfInterest], P.[Name], P.[Identifier], POIV.[ElapsedTime], POIV.[CheckOutDate]

	UNION

	-- Devoluciones
	SELECT		0 as IdPointOfInterestVisited, S.[Id] AS IdPersonOfInterest, S.[Name] AS PersonOfInterestName, 
				S.[LastName] AS PersonOfInterestLastName, S.[Identifier] AS PersonOfInterestIdentifier, CF.[Date] as ActionDate, 
				P.[Radius], P.[MinElapsedTimeForVisit], P.[IdDepartment], P.[Latitude], P.[Longitude], P.[Address],
				CF.[Date] AS LocationInDate, CF.[Date] as LocationOutDate,
				[IdPointOfInterest], P.[Name] AS PointOfInterestName, NULL AS ElapsedTime, 
				P.[Identifier] AS PointOfInterestIdentifier, 7 AS AutomaticValue, @MarkedVisitedProductRefundText as Reason	

	FROM		dbo.[ProductRefund] CF WITH (NOLOCK) 
				INNER JOIN [dbo].[PointOfInterest] P WITH (NOLOCK) ON P.[Id] = CF.[IdPointOfInterest]
				INNER JOIN [dbo].[PersonOfInterest] S WITH (NOLOCK) ON S.[Id] = CF.[IdPersonOfInterest]

	WHERE		CF.[Date] >= @DateFrom AND CF.[Date] <= @DateTo AND
				((@IdDepartments IS NULL) OR (S.[IdDepartment] IS NULL) OR (dbo.CheckValueInList(S.[IdDepartment], @IdDepartments) = 1)) AND
				((@Types IS NULL) OR (dbo.CheckCharValueInList(S.[Type], @Types) = 1)) AND
				((@IdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(S.[Id], @IdPersonsOfInterest) = 1)) AND
				((@IdPointsOfInterest IS NULL) OR (dbo.CheckValueInList(P.[Id], @IdPointsOfInterest) = 1)) AND			
				((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1))

	GROUP BY  S.[Id], S.[Name], S.[LastName], S.[Identifier], CF.[Date] , P.[Radius], p.[MinElapsedTimeForVisit], P.[IdDepartment],P.[Latitude], P.[Longitude], P.[Address],
	          [IdPointOfInterest], P.[Name], P.[Identifier]

	UNION

	-- Documentos
	SELECT		0 as IdPointOfInterestVisited, S.[Id] AS IdPersonOfInterest, S.[Name] AS PersonOfInterestName, 
				S.[LastName] AS PersonOfInterestLastName, S.[Identifier] AS PersonOfInterestIdentifier, CF.[Date] as ActionDate, 
				P.[Radius], P.[MinElapsedTimeForVisit], P.[IdDepartment], P.[Latitude], P.[Longitude], P.[Address],
				CF.[Date] AS LocationInDate, CF.[Date] as LocationOutDate,
				[IdPointOfInterest], P.[Name] AS PointOfInterestName, NULL AS ElapsedTime, 
				P.[Identifier] AS PointOfInterestIdentifier, 8 AS AutomaticValue, @MarkedVisitedDocumentReportText as Reason	

	FROM		dbo.[DocumentReport] CF WITH (NOLOCK) 
				INNER JOIN [dbo].[PointOfInterest] P WITH (NOLOCK) ON P.[Id] = CF.[IdPointOfInterest]
				INNER JOIN [dbo].[PersonOfInterest] S WITH (NOLOCK) ON S.[Id] = CF.[IdPersonOfInterest]

	WHERE		CF.[Date] >= @DateFrom AND CF.[Date] <= @DateTo AND
				((@IdDepartments IS NULL) OR (S.[IdDepartment] IS NULL) OR (dbo.CheckValueInList(S.[IdDepartment], @IdDepartments) = 1)) AND
				((@Types IS NULL) OR (dbo.CheckCharValueInList(S.[Type], @Types) = 1)) AND
				((@IdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(S.[Id], @IdPersonsOfInterest) = 1)) AND
				((@IdPointsOfInterest IS NULL) OR (dbo.CheckValueInList(P.[Id], @IdPointsOfInterest) = 1)) AND			
				((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1))

	GROUP BY  S.[Id], S.[Name], S.[LastName], S.[Identifier], CF.[Date] , P.[Radius], p.[MinElapsedTimeForVisit], P.[IdDepartment],P.[Latitude], P.[Longitude], P.[Address],
	          [IdPointOfInterest], P.[Name], P.[Identifier]

	UNION

	-- foto antes vs despues
	SELECT		0 as IdPointOfInterestVisited, S.[Id] AS IdPersonOfInterest, S.[Name] AS PersonOfInterestName, 
				S.[LastName] AS PersonOfInterestLastName, S.[Identifier] AS PersonOfInterestIdentifier, CF.[ReportDate] as ActionDate, 
				P.[Radius], P.[MinElapsedTimeForVisit], P.[IdDepartment], P.[Latitude], P.[Longitude], P.[Address],
				CF.[ReportDate] AS LocationInDate, CF.[ReportDate] as LocationOutDate,
				[IdPointOfInterest], P.[Name] AS PointOfInterestName, NULL AS ElapsedTime, 
				P.[Identifier] AS PointOfInterestIdentifier, 9 AS AutomaticValue, @MarkedVisitedComparationOfImagesReportText as Reason	

	FROM		dbo.[PhotoReport] CF WITH (NOLOCK) 
				INNER JOIN [dbo].[PointOfInterest] P WITH (NOLOCK) ON P.[Id] = CF.[IdPointOfInterest]
				INNER JOIN [dbo].[PersonOfInterest] S WITH (NOLOCK) ON S.[Id] = CF.[IdPersonOfInterest]

	WHERE		CF.[ReportDate] >= @DateFrom AND CF.[ReportDate] <= @DateTo AND
				((@IdDepartments IS NULL) OR (S.[IdDepartment] IS NULL) OR (dbo.CheckValueInList(S.[IdDepartment], @IdDepartments) = 1)) AND
				((@Types IS NULL) OR (dbo.CheckCharValueInList(S.[Type], @Types) = 1)) AND
				((@IdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(S.[Id], @IdPersonsOfInterest) = 1)) AND
				((@IdPointsOfInterest IS NULL) OR (dbo.CheckValueInList(P.[Id], @IdPointsOfInterest) = 1)) AND			
				((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1))

	GROUP BY  S.[Id], S.[Name], S.[LastName], S.[Identifier], CF.[ReportDate] , P.[Radius], p.[MinElapsedTimeForVisit], P.[IdDepartment],P.[Latitude], P.[Longitude], P.[Address],
	          [IdPointOfInterest], P.[Name], P.[Identifier]

	UNION

	-- faltantes
	SELECT		0 as IdPointOfInterestVisited, S.[Id] AS IdPersonOfInterest, S.[Name] AS PersonOfInterestName, 
				S.[LastName] AS PersonOfInterestLastName, S.[Identifier] AS PersonOfInterestIdentifier, CF.[Date] as ActionDate, 
				P.[Radius], P.[MinElapsedTimeForVisit], P.[IdDepartment], P.[Latitude], P.[Longitude], P.[Address],
				CF.[Date] AS LocationInDate, CF.[Date] as LocationOutDate,
				[IdPointOfInterest], P.[Name] AS PointOfInterestName, NULL AS ElapsedTime, 
				P.[Identifier] AS PointOfInterestIdentifier, 10 AS AutomaticValue, @MarkedVisitedShortageReportText as Reason	

	FROM		dbo.[ProductMissingPointOfInterest] CF WITH (NOLOCK) 
				INNER JOIN [dbo].[PointOfInterest] P WITH (NOLOCK) ON P.[Id] = CF.[IdPointOfInterest]
				INNER JOIN [dbo].[PersonOfInterest] S WITH (NOLOCK) ON S.[Id] = CF.[IdPersonOfInterest]

	WHERE		CF.[Date] >= @DateFrom AND CF.[Date] <= @DateTo AND
				((@IdDepartments IS NULL) OR (S.[IdDepartment] IS NULL) OR (dbo.CheckValueInList(S.[IdDepartment], @IdDepartments) = 1)) AND
				((@Types IS NULL) OR (dbo.CheckCharValueInList(S.[Type], @Types) = 1)) AND
				((@IdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(S.[Id], @IdPersonsOfInterest) = 1)) AND
				((@IdPointsOfInterest IS NULL) OR (dbo.CheckValueInList(P.[Id], @IdPointsOfInterest) = 1)) AND			
				((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1))

	GROUP BY  S.[Id], S.[Name], S.[LastName], S.[Identifier], CF.[Date] , P.[Radius], p.[MinElapsedTimeForVisit], P.[IdDepartment],P.[Latitude], P.[Longitude], P.[Address],
	          [IdPointOfInterest], P.[Name], P.[Identifier]
			  
	UNION

	-- share of shelf
	SELECT		0 as IdPointOfInterestVisited, S.[Id] AS IdPersonOfInterest, S.[Name] AS PersonOfInterestName, 
				S.[LastName] AS PersonOfInterestLastName, S.[Identifier] AS PersonOfInterestIdentifier, SOS.[Date] as ActionDate, 
				P.[Radius], P.[MinElapsedTimeForVisit], P.[IdDepartment], P.[Latitude], P.[Longitude], P.[Address],
				SOS.[Date] AS LocationInDate, SOS.[Date] as LocationOutDate,
				[IdPointOfInterest], P.[Name] AS PointOfInterestName, NULL AS ElapsedTime, 
				P.[Identifier] AS PointOfInterestIdentifier, 11 AS AutomaticValue, NULL as Reason	

	FROM		dbo.[ShareOfShelfReport] SOS WITH (NOLOCK) 
				INNER JOIN [dbo].[PointOfInterest] P WITH (NOLOCK) ON P.[Id] = SOS.[IdPointOfInterest]
				INNER JOIN [dbo].[PersonOfInterest] S WITH (NOLOCK) ON S.[Id] = SOS.[IdPersonOfInterest]

	WHERE		SOS.[Date] >= @DateFrom AND SOS.[Date] <= @DateTo AND
				((@IdDepartments IS NULL) OR (S.[IdDepartment] IS NULL) OR (dbo.CheckValueInList(S.[IdDepartment], @IdDepartments) = 1)) AND
				((@Types IS NULL) OR (dbo.CheckCharValueInList(S.[Type], @Types) = 1)) AND
				((@IdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(S.[Id], @IdPersonsOfInterest) = 1)) AND
				((@IdPointsOfInterest IS NULL) OR (dbo.CheckValueInList(P.[Id], @IdPointsOfInterest) = 1)) AND			
				((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1))

	GROUP BY  S.[Id], S.[Name], S.[LastName], S.[Identifier], SOS.[Date] , P.[Radius], p.[MinElapsedTimeForVisit], P.[IdDepartment],P.[Latitude], P.[Longitude], P.[Address],
	          [IdPointOfInterest], P.[Name], P.[Identifier]
	UNION

	-- Order
	SELECT		0 as IdPointOfInterestVisited, S.[Id] AS IdPersonOfInterest, S.[Name] AS PersonOfInterestName, 
				S.[LastName] AS PersonOfInterestLastName, S.[Identifier] AS PersonOfInterestIdentifier, O.[OrderDateTime] as ActionDate, 
				P.[Radius], P.[MinElapsedTimeForVisit], P.[IdDepartment], P.[Latitude], P.[Longitude], P.[Address],
				O.[OrderDateTime] AS LocationInDate, O.[OrderDateTime] as LocationOutDate,
				[IdPointOfInterest], P.[Name] AS PointOfInterestName, NULL AS ElapsedTime, 
				P.[Identifier] AS PointOfInterestIdentifier, 12 AS AutomaticValue, NULL as Reason	

	FROM		dbo.[OrderReport] O WITH (NOLOCK) 
				INNER JOIN [dbo].[PointOfInterest] P WITH (NOLOCK) ON P.[Id] = O.[IdPointOfInterest]
				INNER JOIN [dbo].[PersonOfInterest] S WITH (NOLOCK) ON S.[Id] = O.[IdPersonOfInterest]

	WHERE		O.[OrderDateTime] >= @DateFrom AND O.[OrderDateTime] <= @DateTo AND
				((@IdDepartments IS NULL) OR (S.[IdDepartment] IS NULL) OR (dbo.CheckValueInList(S.[IdDepartment], @IdDepartments) = 1)) AND
				((@Types IS NULL) OR (dbo.CheckCharValueInList(S.[Type], @Types) = 1)) AND
				((@IdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(S.[Id], @IdPersonsOfInterest) = 1)) AND
				((@IdPointsOfInterest IS NULL) OR (dbo.CheckValueInList(P.[Id], @IdPointsOfInterest) = 1)) AND			
				((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1))

	GROUP BY  S.[Id], S.[Name], S.[LastName], S.[Identifier], O.[OrderDateTime], P.[Radius], p.[MinElapsedTimeForVisit], P.[IdDepartment],P.[Latitude], P.[Longitude], P.[Address],
	          [IdPointOfInterest], P.[Name], P.[Identifier]
	RETURN 
END
