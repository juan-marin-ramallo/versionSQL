/****** Object:  Procedure [dbo].[GetPersonsOfInterestAlertScheduleLateExit]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		gl
-- Create date: 27/12/2017
-- Description:	SP para buscar personas cuyo horario laboral haya terminado y todavia no haya marcado salida de un punto
-- =============================================
CREATE PROCEDURE [dbo].[GetPersonsOfInterestAlertScheduleLateExit]
(
	 @IdUser [sys].[int] = NULL
)
AS
BEGIN
	DECLARE @Now [sys].[datetime]
	SET @Now = GETUTCDATE()
		
	DECLARE @MinutesToCheck [sys].[int] = (SELECT [Value] FROM [dbo].[ConfigurationTranslated] WITH (NOLOCK) WHERE [Id] = 1057)

	SELECT	P.[Id], P.[Name], P.[LastName], P.[Identifier], P.[MobileIMEI], P.[MobilePhoneNumber],
			PMV.[CheckInDate] as ManualVisitEntryDate, PIM.[CheckInDate] as MarkVisitEntryDate,
			POI.[Id] AS ManualPointNoExitId, POI.[Name] AS ManualPointNoExitName, POI.[Identifier] AS ManualPointNoExitIdentifier,
			POI2.[Id] AS MarkPointNoExitId, POI2.[Name] AS MarkPointNoExitName, POI2.[Identifier] AS MarkPointNoExitIdentifier
	
	FROM	[dbo].[AvailablePersonOfInterest] P WITH (NOLOCK)
			INNER JOIN [dbo].[PersonOfInterestSchedule] S WITH (NOLOCK) ON S.[IdPersonOfInterest] = P.[Id]
			LEFT JOIN  [dbo].[PointOfInterestManualVisited] PMV WITH (NOLOCK) ON P.[Id] = PMV.[IdPersonOfInterest] AND
						Tzdb.AreSameSystemDates(PMV.[CheckInDate], @Now) = 1 AND PMV.[CheckOutDate] IS NULL
			LEFT JOIN  [dbo].[PointOfInterestMark] PIM WITH (NOLOCK) ON P.[Id] = PIM.[IdPersonOfInterest] AND
						Tzdb.AreSameSystemDates(PIM.[CheckInDate], @Now) = 1 AND PIM.[CheckOutDate] IS NULL
			LEFT JOIN  [dbo].[PointOfInterest] POI WITH (NOLOCK) ON POI.[Id] = PMV.[IdPointOfInterest]
			LEFT JOIN  [dbo].[PointOfInterest] POI2 WITH (NOLOCK) ON POI2.[Id] = PIM.[IdPointOfInterest]
	
	WHERE	S.[IdDayOfWeek] = DATEPART(WEEKDAY, Tzdb.FromUtc(@Now)) AND --P.[Deleted] = 0 AND 
			((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(P.[Id], @IdUser) = 1)) AND
			((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1)) AND
			(DATEDIFF(MINUTE, CAST(CAST(Tzdb.FromUtc(@Now) AS TIME) AS datetime), CAST(DATEADD(MINUTE, @MinutesToCheck, S.[ToHour]) AS datetime)) BETWEEN -1 AND 1) AND
			(PMV.[Id] IS NOT NULL OR PIM.[Id] IS NOT NULL)

END
