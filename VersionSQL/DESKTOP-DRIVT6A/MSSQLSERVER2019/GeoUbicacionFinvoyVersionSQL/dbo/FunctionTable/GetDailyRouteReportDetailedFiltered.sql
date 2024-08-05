/****** Object:  TableFunction [dbo].[GetDailyRouteReportDetailedFiltered]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 30/01/2018
-- Description:	Funcion que obtiene resumen de ruta y formularios dada una ruta y un día
-- =============================================
CREATE FUNCTION [dbo].[GetDailyRouteReportDetailedFiltered]
(
	 @Route [sys].[VARCHAR](50)
	,@Date [sys].[datetime]
)
RETURNS @t TABLE (
	 [Route] [sys].[VARCHAR](50)
	,[Date] [sys].[Date]
	,[PersonOfInterestId] [sys].[int]
	,[PersonOfInterestName] [sys].[varchar](101)
	,[PointOfInterestIdentifier] [sys].[varchar](50)
	,[PointOfInterestName] [sys].[varchar](100)
	,[Planned] [sys].[bit]
	,[Visited] [sys].[bit]
	,[VisitTime] [sys].[TIME]
	,[NoVisitMessage] [sys].[varchar](50)
	,[FormsCount] [sys].[INT]
	,[CompletedFormsCount] [sys].[INT]
	)
AS
BEGIN
	-- Calculate start and end datetime
	DECLARE @DateFrom [sys].[datetime] = @Date
	DECLARE @DateTo [sys].[datetime] = DATEADD(SECOND, -1, DATEADD(DAY, 1, @DateFrom))
	DECLARE @RouteNameEnd [sys].[VARCHAR](50) = ('% ' + @Route)
	DECLARE @RouteNameSpaces [sys].[VARCHAR](50) = ('% ' + @Route + ' %')

	-- Get Persons assigned to route
	-- Select Ids separated by ,
	DECLARE @PersonOfInterestIds [sys].[VARCHAR](MAX) = 
		( SELECT ',' + ISNULL(STUFF((
			SELECT ','+ CONVERT(VARCHAR(MAX), IdPersonOfInterest)
			FROM dbo.[RouteGroup] WITH (NOLOCK)
			WHERE ([Name] like @RouteNameSpaces OR [Name] LIKE @RouteNameEnd OR [Name] = @Route) 
				AND Tzdb.IsGreaterOrSameSystemDate(@DATE, StartDate) = 1
				AND (
					(Deleted = 0 AND (EndDate IS NULL OR Tzdb.IsLowerOrSameSystemDate(@Date, EndDate) = 1))
					OR (Deleted = 1 AND Tzdb.IsLowerOrSameSystemDate(@Date, IIF(EndDate IS NULL OR EndDate > EditedDate, EditedDate, EndDate)) = 1)
				)
			GROUP BY IdPersonOfInterest
			FOR XML PATH('')
			)
			,1,1,''), '') + ',')

	-- Select info
	INSERT INTO @t
	SELECT @Route AS [Route], @Date AS [Date]
		, r.PersonOfInterestId
		, r.PersonOfInterestName + IIF(r.PersonOfInterestLastName IS NULL, '', ' ' + r.PersonOfInterestLastName) AS PersonOfInterestName
		, r.PointOfInterestIdentifier
		, r.PointOfInterestName
		, IIF(r.RouteStatus = 1 OR r.RouteStatus = 2 OR r.RouteStatus = 4, 1, 0) AS Planned
		, IIF(r.RouteStatus = 1 OR r.RouteStatus = 3, 1, 0) AS Visited
		, r.VisitTime
		, r.NoVisitOptionText AS [NoVisitMessage]
		, r.FormsCount, r.CompletedFormsCount
	FROM (
		SELECT rr.PersonOfInterestId, rr.PersonOfInterestName, rr.PersonOfInterestLastName, rr.PointOfInterestIdentifier, RR.PointOfInterestName, rr.VisitTime, rr.RouteStatus, rr.NoVisitOptionText , COUNT(fr.FormId) AS FormsCount, COUNT (fr.CompletedFormId) AS CompletedFormsCount
		FROM dbo.RoutesReportFiltered(@DateFrom, @DateTo, NULL, NULL, @PersonOfInterestIds, NULL, 1, DEFAULT, null) rr
			LEFT OUTER JOIN dbo.FormsReportFiltered(@DateFrom, @DateTo, @PersonOfInterestIds, NULL, 1, null) fr ON rr.PointOfInterestId = fr.PointOfInterestId AND rr.RouteDate = fr.[Date]
		GROUP BY rr.PersonOfInterestId, rr.PersonOfInterestName, rr.PersonOfInterestLastName, rr.PointOfInterestIdentifier	, RR.PointOfInterestName, rr.VisitTime, rr.RouteStatus, rr.NoVisitOptionText
		) AS r

	RETURN 
END
