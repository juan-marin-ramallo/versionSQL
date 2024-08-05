/****** Object:  Procedure [dbo].[GetPersonsOfInterestAlertSchedule]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		gl
-- Create date: 20/12/2017
-- Description:	SP para buscar personas cuyo horario laboral haya empezado x tiempo antes de la hora actual
-- =============================================
CREATE PROCEDURE [dbo].[GetPersonsOfInterestAlertSchedule]
(
	 @IdUser [sys].[int] = NULL
)
AS
BEGIN
	DECLARE @Now [sys].[datetime]
	SET @Now = GETUTCDATE()
		
	DECLARE @MinutesToCheck [sys].[int] = (SELECT [Value] FROM [dbo].[ConfigurationTranslated] WITH (NOLOCK) WHERE [Id] = 1056)

	SELECT	  P.[Id], P.[Name], P.[LastName], P.[Identifier], P.[MobileIMEI], P.[MobilePhoneNumber]
	
	FROM	    [dbo].[AvailablePersonOfInterest] P WITH (NOLOCK)
			      INNER JOIN [dbo].[PersonOfInterestSchedule] S WITH (NOLOCK) ON S.[IdPersonOfInterest] = P.[Id]
	
	WHERE	    S.[IdDayOfWeek] = DATEPART(WEEKDAY, Tzdb.FromUtc(@Now)) AND --P.[Deleted] = 0 AND
			      ((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(P.[Id], @IdUser) = 1)) AND
			      ((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1)) AND
			      (DATEDIFF(MINUTE, CAST(CAST(Tzdb.FromUtc(@Now) AS TIME) AS datetime), CAST(DATEADD(MINUTE, @MinutesToCheck, S.[FromHour]) AS datetime)) BETWEEN -1 AND 1) AND
			      P.[Id] NOT IN (SELECT [IdPersonOfInterest] FROM [dbo].[PointOfInterestManualVisited] WITH (NOLOCK) WHERE Tzdb.AreSameSystemDates([CheckInDate], @Now) = 1) AND
			      P.[Id] NOT IN (SELECT [IdPersonOfInterest] FROM [dbo].[PointOfInterestMark] WITH (NOLOCK) WHERE Tzdb.AreSameSystemDates([CheckInDate], @Now) = 1)
				AND P.[Id] NOT IN (SELECT PA.[IdPersonOfInterest]
									FROM    [dbo].[PersonOfInterestAbsence] PA WITH (NOLOCK)
									WHERE   @Now >= PA.[FromDate] AND (PA.[ToDate] IS NULL OR @Now < PA.[ToDate]))

  GROUP BY  P.[Id], P.[Name], P.[LastName], P.[Identifier], P.[MobileIMEI], P.[MobilePhoneNumber]

END
