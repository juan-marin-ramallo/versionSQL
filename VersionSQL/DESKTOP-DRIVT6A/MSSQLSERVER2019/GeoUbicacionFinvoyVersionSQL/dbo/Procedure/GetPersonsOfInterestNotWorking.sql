/****** Object:  Procedure [dbo].[GetPersonsOfInterestNotWorking]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 15/10/2015
-- Description:	SP para obtener las Personas de Interes que no están trabajando
-- =============================================
CREATE PROCEDURE [dbo].[GetPersonsOfInterestNotWorking]
(
	@IdUser [sys].[int] = NULL
)
AS
BEGIN
	DECLARE @SystemToday [sys].[datetime]
	SET @SystemToday = DATEADD(DAY, DATEDIFF(DAY, 0, Tzdb.FromUtc(GETUTCDATE())), 0)

  ;WITH vCurrentLocations([IdPersonOfInterest], [Date], [DateSystemTruncated]) AS
  (
      SELECT  L.[IdPersonOfInterest], L.[Date],
              DATEADD(DAY, DATEDIFF(DAY, 0, Tzdb.FromUtc(L.[Date])), 0) AS DateSystemTruncated
      FROM    [dbo].[CurrentLocation] L WITH (NOLOCK)
  )

	SELECT	  P.[Id], P.[Name], P.[LastName], P.[Identifier], P.[MobilePhoneNumber], P.[MobileIMEI], P.[Status], P.[Type],
			      P.[IdDepartment], P.[Email]
	FROM	    [dbo].[AvailablePersonOfInterest] P WITH (NOLOCK)
      			INNER JOIN [dbo].[PersonOfInterestSchedule] PS WITH (NOLOCK) ON PS.[IdPersonOfInterest] = P.[Id]
      			INNER JOIN vCurrentLocations L WITH (NOLOCK) ON P.[Id] = L.[IdPersonOfInterest]
	WHERE	    PS.[IdDayOfWeek] = DATEPART(WEEKDAY, @SystemToday) AND L.[DateSystemTruncated] < @SystemToday
				AND ((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1))
      			AND ((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(P.[Id], @IdUser) = 1))
				AND P.[Id] NOT IN (SELECT PA.[IdPersonOfInterest]
									FROM    [dbo].[PersonOfInterestAbsence] PA WITH (NOLOCK)
									WHERE   Tzdb.ToUtc(@SystemToday) >= PA.[FromDate] AND (PA.[ToDate] IS NULL OR Tzdb.ToUtc(@SystemToday) < PA.[ToDate]))
  GROUP BY  P.[Id], P.[Name], P.[LastName], P.[Identifier], P.[MobilePhoneNumber], P.[MobileIMEI], P.[Status], P.[Type],
			      P.[IdDepartment], P.[Email]
END

-- OLD)
-- BEGIN
-- 	DECLARE @Now [sys].[datetime]
-- 	SET @Now = GETUTCDATE()

-- 	SELECT	P.[Id], P.[Name], P.[LastName], P.[Identifier], P.[MobilePhoneNumber], P.[MobileIMEI], P.[Status], P.[Type],
-- 			 P.[IdDepartment], P.[Email]
-- 	FROM	[dbo].[AvailablePersonOfInterest] P WITH (NOLOCK)
-- 			INNER JOIN [dbo].[PersonOfInterestSchedule] PS WITH (NOLOCK) ON PS.[IdPersonOfInterest] = P.[Id]
-- 			INNER JOIN [dbo].[CurrentLocation] L WITH (NOLOCK) ON P.[Id] = L.[IdPersonOfInterest]
-- 	WHERE	PS.[IdDayOfWeek] = DATEPART(WEEKDAY, Tzdb.FromUtc(@Now)) AND Tzdb.IsLowerSystemDate(L.[Date], @Now) = 1
-- 			AND ((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1))
-- 			AND ((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(P.[Id], @IdUser) = 1))
-- END
