/****** Object:  TableFunction [dbo].[PointsOfInterestWithActivityForWorkingActivity]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Gl
-- Create date: 23/01/2021
-- Description:	se utiliza para incluir en el reporte de actividad laboral, todas las entradas y salidas a los puntos en ruta, para que se muestre mas de 1 en caso necesario
-- =============================================
CREATE FUNCTION [dbo].[PointsOfInterestWithActivityForWorkingActivity]
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

	GROUP BY  PA.IdPersonOfInterest, S.[Name], S.[LastName], S.[Identifier], ISNULL(POIV.LocationInDate, ISNULL(POIMV.CheckInDate, PA.[DateIn])),
			IIF(@IncludeAutomaticVisits = 1, IIF(POIV.LocationInDate IS NULL, PA.[DateOut],POIV.LocationOutDate), IIF(POIMV.CheckInDate IS NULL, PA.[DateOut], POIMV.CheckOutDate))
				, P.[Radius], p.[MinElapsedTimeForVisit], 
				P.[IdDepartment], P.[Latitude], P.[Longitude], P.[Address],
				Pa.[IdPointOfInterest], P.[Name], P.[Identifier], IIF(POIV.Id IS NOT NULL, POIV.[ElapsedTime], IIF(POIMV.Id IS NOT NULL, POIMV.[ElapsedTime], PA.[ElapsedTime])), 
                CASE WHEN @IncludeAutomaticVisits = 1 THEN PA.AutomaticValue
                    WHEN POIMV.Id IS NOT NULL THEN 2
                    WHEN @IncludeAutomaticVisits = 0 THEN IIF(PA.AutomaticValue > 1, PA.AutomaticValue, PA.ActionValue) END

	UNION

	SELECT	POIV.IdPersonOfInterest, S.[Name] AS PersonOfInterestName, 
			S.[LastName] AS PersonOfInterestLastName, S.[Identifier] AS PersonOfInterestIdentifier, 
			POIV.LocationInDate AS [DateIn],
			POIV.LocationOutDate AS [DateOut], 
			P.[Radius], P.[MinElapsedTimeForVisit], P.[IdDepartment], P.[Latitude], P.[Longitude], P.[Address],
			POIV.[IdPointOfInterest], P.[Name] AS PointOfInterestName, POIV.[ElapsedTime] AS [ElapsedTime], 
			P.[Identifier] AS PointOfInterestIdentifier, 1 AS AutomaticValue
	
	FROM	[dbo].[PointOfInterestVisited] POIV WITH (NOLOCK)
			INNER JOIN [dbo].[PointOfInterest] P WITH (NOLOCK) ON P.[Id] = POIV.[IdPointOfInterest]
			INNER JOIN [dbo].[PersonOfInterest] S WITH (NOLOCK) ON S.[Id] = POIV.[IdPersonOfInterest]

	WHERE	@IncludeAutomaticVisits = 1  AND ((POIV.LocationInDate BETWEEN @DateFrom AND @DateTo) OR (POIV.LocationOutDate BETWEEN @DateFrom AND @DateTo))
			AND (@UseHourWindow = 0 OR POIV.InHourWindow = 1) 
			AND ((@IdDepartments IS NULL) OR (S.[IdDepartment] IS NULL) OR (dbo.CheckValueInList(S.[IdDepartment], @IdDepartments) = 1)) 
			AND ((@Types IS NULL) OR (dbo.CheckCharValueInList(S.[Type], @Types) = 1))
			AND ((@IdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(S.[Id], @IdPersonsOfInterest) = 1)) 
			AND ((@IdPointsOfInterest IS NULL) OR (dbo.CheckValueInList(P.[Id], @IdPointsOfInterest) = 1))			
			AND ((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1))
			AND ((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1))
			AND ((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1))
			AND ((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1)) 

	GROUP BY  POIV.IdPersonOfInterest, S.[Name] , 
			S.[LastName] , S.[Identifier] , 
			POIV.LocationInDate ,
			POIV.LocationOutDate , 
			P.[Radius], P.[MinElapsedTimeForVisit], P.[IdDepartment], P.[Latitude], P.[Longitude], P.[Address],
			POIV.[IdPointOfInterest], P.[Name] , POIV.[ElapsedTime] , 
			P.[Identifier] 

	UNION

	SELECT	POIV.IdPersonOfInterest, S.[Name] AS PersonOfInterestName, 
			S.[LastName] AS PersonOfInterestLastName, S.[Identifier] AS PersonOfInterestIdentifier, 
			POIV.CheckInDate AS [DateIn],
			POIV.CheckOutDate AS [DateOut], 
			P.[Radius], P.[MinElapsedTimeForVisit], P.[IdDepartment], P.[Latitude], P.[Longitude], P.[Address],
			POIV.[IdPointOfInterest], P.[Name] AS PointOfInterestName, POIV.[ElapsedTime] AS [ElapsedTime], 
			P.[Identifier] AS PointOfInterestIdentifier, 2 AS AutomaticValue
	
	FROM	[dbo].[PointOfInterestManualVisited] POIV WITH (NOLOCK)
			INNER JOIN [dbo].[PointOfInterest] P WITH (NOLOCK) ON P.[Id] = POIV.[IdPointOfInterest]
			INNER JOIN [dbo].[PersonOfInterest] S WITH (NOLOCK) ON S.[Id] = POIV.[IdPersonOfInterest]

	WHERE	((POIV.CheckInDate BETWEEN @DateFrom AND @DateTo) OR (POIV.CheckOutDate BETWEEN @DateFrom AND @DateTo))
			AND ((@IdDepartments IS NULL) OR (S.[IdDepartment] IS NULL) OR (dbo.CheckValueInList(S.[IdDepartment], @IdDepartments) = 1)) 
			AND ((@Types IS NULL) OR (dbo.CheckCharValueInList(S.[Type], @Types) = 1))
			AND ((@IdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(S.[Id], @IdPersonsOfInterest) = 1)) 
			AND ((@IdPointsOfInterest IS NULL) OR (dbo.CheckValueInList(P.[Id], @IdPointsOfInterest) = 1))			
			AND ((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1))
			AND ((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1))
			AND ((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1))
			AND ((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1)) 

	GROUP BY  POIV.IdPersonOfInterest, S.[Name] , 
			S.[LastName] , S.[Identifier] , 
			POIV.CheckInDate ,
			POIV.CheckOutDate , 
			P.[Radius], P.[MinElapsedTimeForVisit], P.[IdDepartment], P.[Latitude], P.[Longitude], P.[Address],
			POIV.[IdPointOfInterest], P.[Name] , POIV.[ElapsedTime] , 
			P.[Identifier] 

	RETURN 
END
