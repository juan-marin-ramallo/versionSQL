/****** Object:  Procedure [dbo].[GetPersonsOfInterestExitTimeLate]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetPersonsOfInterestExitTimeLate]
(
	@IdUser [sys].[int] = NULL
)
AS
BEGIN
	DECLARE @SystemToday [sys].[datetime]
	SET @SystemToday = Tzdb.FromUtc(GETUTCDATE())
	
	DECLARE @MinutesToCheck [sys].[int] = (SELECT [Value] FROM [dbo].[Configuration] WITH (NOLOCK) WHERE [Id] = 4094)

	SELECT	  P.[Id], P.[Name], P.[LastName], P.[Identifier], P.[MobilePhoneNumber], P.[MobileIMEI], P.[Email],
				WS.[EndTime], WS.[StartTime]

	FROM	    [dbo].[AvailablePersonOfInterest] P WITH (NOLOCK)
      			INNER JOIN [dbo].[PersonOfInterestWorkShift] PW WITH (NOLOCK) ON PW.[IdPersonOfInterest] = P.[Id]
				INNER JOIN [dbo].[WorkShift] WS WITH (NOLOCK) ON WS.[Id] = PW.[IdWorkShift]

	WHERE	    PW.[IdDayOfWeek] = DATEPART(WEEKDAY, @SystemToday) 
				AND WS.[IdType] = 1 --TIPO TRABAJO

				AND P.[Id] NOT IN (SELECT PA.[IdPersonOfInterest]
									FROM    [dbo].[PersonOfInterestAbsence] PA WITH (NOLOCK)
									WHERE   Tzdb.ToUtc(@SystemToday) >= PA.[FromDate] AND (PA.[ToDate] IS NULL OR Tzdb.ToUtc(@SystemToday) < PA.[ToDate]))

				-- AND (DATEDIFF(MINUTE, CAST(CAST(@SystemToday AS TIME) AS datetime), CAST(DATEADD(MINUTE, @MinutesToCheck, WS.[EndTime]) AS datetime)) BETWEEN -1 AND 1)
                AND (DATEDIFF(MINUTE, CAST(CAST(@SystemToday AS TIME) AS datetime), CAST(DATEADD(MINUTE, @MinutesToCheck, WS.[EndTime]) AS datetime)) = 0)
				AND NOT EXISTS 
							(SELECT 1 
							FROM [dbo].[Mark] M
							where IdPersonOfInterest = P.[Id] AND M.[Type] = 'S'
							AND M.[Date] > Tzdb.ToUtc(DATEADD(day, DATEDIFF(day, 0, CAST(@SystemToday as DATE)),CAST(WS.[EndTime] AS DATETIME))))

	GROUP BY  P.[Id], P.[Name], P.[LastName], P.[Identifier], P.[MobilePhoneNumber], P.[MobileIMEI], P.[Status], P.[Type],
			      P.[IdDepartment], P.[Email], WS.[EndTime], WS.[StartTime]
END
