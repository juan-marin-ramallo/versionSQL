/****** Object:  TableFunction [dbo].[PointsOfInterestWithActivity]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		G
-- Create date: 23/01/2017
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[PointsOfInterestWithActivity]
(	
	 @DateFrom [sys].[datetime]
	,@DateTo [sys].[datetime]
	,@IdDepartments [sys].[varchar](max) = NULL
	,@Types [sys].[varchar](max) = NULL
	,@IdPersonsOfInterest [sys].[varchar](max) = NULL
	,@IdPointsOfInterest [sys].[varchar](max) = NULL
	,@IncludeAutomaticVisits [sys].[bit] = 0
	,@IdUser [sys].[int] = NULL
)
RETURNS @t TABLE (
			IdPersonOfInterest [sys].[int], PersonOfInterestName [sys].[varchar](50), 
			PersonOfInterestLastName [sys].[varchar](50),PersonOfInterestIdentifier [sys].[varchar](20), 
			[DateIn] [sys].[datetime],[DateOut] [sys].[datetime],[Radius] [sys].[int], 
			[MinElapsedTimeForVisit] [sys].[int], [IdDepartment] [sys].[INT], [Latitude] [sys].[decimal](25,20), 
			[Longitude] [sys].[decimal](25,20),[Address] [sys].[varchar](250),
			[IdPointOfInterest] [sys].[int], [PointOfInterestName] [sys].[varchar](100), [ElapsedTime] [sys].[time], 
			PointOfInterestIdentifier [sys].[varchar](50), AutomaticValue [sys].[int]
)	
AS
BEGIN
	--DECLARE @MarkedVisitedAutomaticCheckInOutText [sys].[varchar](5000)
	--SET @MarkedVisitedAutomaticCheckInOutText = dbo.GetCommonTextTranslated('MarkedVisited_AutomaticCheckInOut')

	--DECLARE @MarkedVisitedTaskComplianceText [sys].[varchar](5000)
	--SET @MarkedVisitedTaskComplianceText = dbo.GetCommonTextTranslated('MarkedVisited_TaskCompliance')

	--DECLARE @MarkedVisitedProductReportText [sys].[varchar](5000)
	--SET @MarkedVisitedProductReportText = dbo.GetCommonTextTranslated('MarkedVisited_ProductReport')

	--DECLARE @MarkedVisitedAssetReportText [sys].[varchar](5000)
	--SET @MarkedVisitedAssetReportText = dbo.GetCommonTextTranslated('MarkedVisited_AssetReport')

	--DECLARE @MarkedVisitedManualCheckInOutText [sys].[varchar](5000)
	--SET @MarkedVisitedManualCheckInOutText = dbo.GetCommonTextTranslated('MarkedVisited_ManualCheckInOut')

	--DECLARE @MarkedVisitedObservationText [sys].[varchar](5000)
	--SET @MarkedVisitedObservationText = dbo.GetCommonTextTranslated('MarkedVisited_Observation')

	--DECLARE @MarkedVisitedNfcCheckInOutText [sys].[varchar](5000)
	--SET @MarkedVisitedNfcCheckInOutText = dbo.GetCommonTextTranslated('MarkedVisited_NfcCheckInOut')

	--DECLARE @MarkedVisitedProductRefundText [sys].[varchar](5000)
	--SET @MarkedVisitedProductRefundText = dbo.GetCommonTextTranslated('MarkedVisited_ProductRefund')

	--DECLARE @MarkedVisitedDocumentReportText [sys].[varchar](5000)
	--SET @MarkedVisitedDocumentReportText = dbo.GetCommonTextTranslated('MarkedVisited_DocumentReport')

	--DECLARE @MarkedVisitedComparationOfImagesReportText [sys].[varchar](5000)
	--SET @MarkedVisitedComparationOfImagesReportText = dbo.GetCommonTextTranslated('MarkedVisited_ComparationOfImagesReport')

	--DECLARE @MarkedVisitedShortageReportText [sys].[varchar](5000)
	--SET @MarkedVisitedShortageReportText = dbo.GetCommonTextTranslated('MarkedVisited_ShortageReport')

	DECLARE @UseHourWindow BIT = [dbo].GetConfigurationUseHoursWindow()

	INSERT INTO @t 

	SELECT	PA.IdPersonOfInterest, S.[Name] AS PersonOfInterestName, 
			S.[LastName] AS PersonOfInterestLastName, S.[Identifier] AS PersonOfInterestIdentifier, 

			ISNULL(POIV.LocationInDate, ISNULL(POIMV.CheckInDate, PA.[DateIn])) AS [DateIn],
			IIF(@IncludeAutomaticVisits = 1, IIF(POIV.LocationInDate IS NULL, PA.[DateOut],POIV.LocationOutDate), IIF(POIMV.CheckInDate IS NULL, PA.[DateOut], POIMV.CheckOutDate)) AS [DateOut], 

			P.[Radius], P.[MinElapsedTimeForVisit], P.[IdDepartment], P.[Latitude], P.[Longitude], P.[Address],
			PA.[IdPointOfInterest], P.[Name] AS PointOfInterestName, IIF(POIV.Id IS NOT NULL, POIV.[ElapsedTime], IIF(POIMV.Id IS NOT NULL, POIMV.[ElapsedTime], PA.[ElapsedTime])) AS [ElapsedTime], 
			P.[Identifier] AS PointOfInterestIdentifier, 
			CASE WHEN @IncludeAutomaticVisits = 1 THEN PA.AutomaticValue
				WHEN POIMV.Id IS NOT NULL THEN 2
				WHEN @IncludeAutomaticVisits = 0 THEN IIF(PA.AutomaticValue > 1, PA.AutomaticValue, PA.ActionValue) END AS AutomaticValue
	
	FROM	[dbo].[PointOfInterestActivity] PA WITH (NOLOCK)
			INNER JOIN [dbo].[PointOfInterest] P WITH (NOLOCK) ON P.[Id] = PA.[IdPointOfInterest]
			INNER JOIN [dbo].[PersonOfInterest] S WITH (NOLOCK) ON S.[Id] = PA.[IdPersonOfInterest]
			LEFT OUTER JOIN [dbo].[PointOfInterestVisited] POIV WITH(NOLOCK) ON @IncludeAutomaticVisits = 1 AND POIV.Id = PA.IdPointOfInterestVisited
			LEFT OUTER JOIN [dbo].[PointOfInterestManualVisited] POIMV WITH(NOLOCK) ON @IncludeAutomaticVisits = 0 AND POIMV.Id = PA.IdPointOfInterestManualVisited

	WHERE	((@IncludeAutomaticVisits = 1) OR  (@IncludeAutomaticVisits = 0 AND (PA.AutomaticValue > 1 OR PA.IdPointOfInterestManualVisited IS NOT NULL OR PA.ActionValue IS NOT NULL)))
			AND ((ISNULL(POIV.LocationInDate, PA.[DateIn]) BETWEEN @DateFrom AND @DateTo) OR (ISNULL(POIV.LocationOutDate, PA.[DateOut]) BETWEEN @DateFrom AND @DateTo))
			AND (@UseHourWindow = 0 OR PA.InHourWindow = 1) 
			AND ((@IdDepartments IS NULL) OR (S.[IdDepartment] IS NULL) OR (dbo.CheckValueInList(S.[IdDepartment], @IdDepartments) = 1)) 
			AND ((@Types IS NULL) OR (dbo.CheckCharValueInList(S.[Type], @Types) = 1))
			AND ((@IdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(S.[Id], @IdPersonsOfInterest) = 1)) 
			AND ((@IdPointsOfInterest IS NULL) OR (dbo.CheckValueInList(P.[Id], @IdPointsOfInterest) = 1))			
			AND ((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1))
			AND ((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1))
			AND ((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1))
			AND ((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1)) 

	GROUP BY  PA.IdPersonOfInterest, S.[Name], S.[LastName], S.[Identifier],
				ISNULL(POIV.LocationInDate, ISNULL(POIMV.CheckInDate, PA.[DateIn])),
				IIF(@IncludeAutomaticVisits = 1, IIF(POIV.LocationInDate IS NULL, PA.[DateOut],POIV.LocationOutDate), IIF(POIMV.CheckInDate IS NULL, PA.[DateOut], POIMV.CheckOutDate)), 
				P.[Radius], p.[MinElapsedTimeForVisit], 
				P.[IdDepartment], P.[Latitude], P.[Longitude], P.[Address],
				Pa.[IdPointOfInterest], P.[Name], P.[Identifier], IIF(POIV.Id IS NOT NULL, POIV.[ElapsedTime], IIF(POIMV.Id IS NOT NULL, POIMV.[ElapsedTime], PA.[ElapsedTime])),
			CASE WHEN @IncludeAutomaticVisits = 1 THEN PA.AutomaticValue
				WHEN POIMV.Id IS NOT NULL THEN 2
				WHEN @IncludeAutomaticVisits = 0 THEN IIF(PA.AutomaticValue > 1, PA.AutomaticValue, PA.ActionValue) END
	
	--SELECT	PA.IdPersonOfInterest, S.[Name] AS PersonOfInterestName, 
	--		S.[LastName] AS PersonOfInterestLastName, S.[Identifier] AS PersonOfInterestIdentifier, 
	--		ISNULL(POIV.LocationInDate, PA.[DateIn]) AS [DateIn], ISNULL(POIV.LocationOutDate, PA.[DateOut]) AS [DateOut], P.[Radius], 
	--		P.[MinElapsedTimeForVisit], P.[IdDepartment], P.[Latitude], P.[Longitude], P.[Address],
	--		PA.[IdPointOfInterest], P.[Name] AS PointOfInterestName, ISNULL(POIV.[ElapsedTime], PA.[ElapsedTime]), 
	--		P.[Identifier] AS PointOfInterestIdentifier, IIF(POIV.Id IS NOT NULL, 1, PA.AutomaticValue) AS AutomaticValue
	
	--FROM	[dbo].[PointOfInterestActivity] PA WITH (NOLOCK)
	--		INNER JOIN [dbo].[PointOfInterest] P WITH (NOLOCK) ON P.[Id] = PA.[IdPointOfInterest]
	--		INNER JOIN [dbo].[PersonOfInterest] S WITH (NOLOCK) ON S.[Id] = PA.[IdPersonOfInterest]
	--		LEFT OUTER JOIN [dbo].[PointOfInterestVisited] POIV WITH(NOLOCK) ON @IncludeAutomaticVisits = 1 AND POIV.Id = PA.IdPointOfInterestVisited

	--WHERE	((ISNULL(POIV.LocationInDate, PA.[DateIn]) BETWEEN @DateFrom AND @DateTo) OR (ISNULL(POIV.LocationOutDate, PA.[DateOut]) BETWEEN @DateFrom AND @DateTo))
	--		AND (@UseHourWindow = 0 OR PA.InHourWindow = 1) 
	--		AND ((@IdDepartments IS NULL) OR (S.[IdDepartment] IS NULL) OR (dbo.CheckValueInList(S.[IdDepartment], @IdDepartments) = 1)) 
	--		AND ((@Types IS NULL) OR (dbo.CheckCharValueInList(S.[Type], @Types) = 1))
	--		AND ((@IdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(S.[Id], @IdPersonsOfInterest) = 1)) 
	--		AND ((@IdPointsOfInterest IS NULL) OR (dbo.CheckValueInList(P.[Id], @IdPointsOfInterest) = 1))			
	--		AND ((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1))
	--		AND ((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1))
	--		AND ((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1))
	--		AND ((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1)) 

	--GROUP BY  PA.IdPersonOfInterest, S.[Name], S.[LastName], S.[Identifier], ISNULL(POIV.LocationInDate, PA.[DateIn]), ISNULL(POIV.LocationOutDate, PA.[DateOut]), P.[Radius], p.[MinElapsedTimeForVisit], 
	--		P.[IdDepartment], P.[Latitude], P.[Longitude], P.[Address],
	--          Pa.[IdPointOfInterest], P.[Name], P.[Identifier], ISNULL(POIV.[ElapsedTime], PA.[ElapsedTime]), IIF(POIV.Id IS NOT NULL, 1, PA.AutomaticValue)

	RETURN 
END
