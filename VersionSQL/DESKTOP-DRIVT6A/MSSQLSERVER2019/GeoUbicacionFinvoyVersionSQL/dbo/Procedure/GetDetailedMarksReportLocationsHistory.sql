/****** Object:  Procedure [dbo].[GetDetailedMarksReportLocationsHistory]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 20/03/2013
-- Description:	SP para obtener el historial de ubicaciones de una persona de interés dada por el reporte de marcas
-- =============================================
CREATE PROCEDURE [dbo].[GetDetailedMarksReportLocationsHistory]
(
	 @Date [sys].[datetime]
	,@IdDepartments [sys].[varchar](1000) = NULL
	,@Types [sys].[varchar](1000) = NULL
	,@IdPersonOfInterest [sys].[int] = NULL
	,@IdUser [sys].[int] = NULL
)
AS
BEGIN
	;WITH ViewDetailedMarksReport([Date], [IdPersonOfInterest], [EntryTime], [RestEntryTime], [RestExitTime], [ExitTime]) AS
	(
		SELECT		Tzdb.ToUtc(CAST(Tzdb.FromUtc(M.[Date]) AS [sys].[date])) AS [Date],
					MAX(M.[IdPersonOfInterest]) AS IdPersonOfInterest,
					MAX(CASE M.[Type] WHEN 'E' THEN M.[Date] ELSE NULL END) AS EntryTime,
					MAX(CASE M.[Type] WHEN 'ED' THEN M.[Date] ELSE NULL END) AS RestEntryTime,
					MAX(CASE M.[Type] WHEN 'SD' THEN M.[Date] ELSE NULL END) AS RestExitTime,
					MAX(CASE M.[Type] WHEN 'S' THEN M.[Date] ELSE NULL END) AS ExitTime
		FROM		[dbo].[Mark] M WITH (NOLOCK)
		WHERE		Tzdb.AreSameSystemDates(M.[Date], @Date) = 1 AND
					((@IdPersonOfInterest IS NULL) OR (M.[IdPersonOfInterest] = @IdPersonOfInterest))
		GROUP BY	Tzdb.ToUtc(CAST(Tzdb.FromUtc(M.[Date]) AS [sys].[date]))
	)

	SELECT		LR.[Id], LR.[IdPersonOfInterest], LR.[Date], LR.[Latitude], LR.[Longitude], LR.[Processed],
				LR.[IdPersonOfInterest] AS PersonOfInterestId, LR.[PersonOfInterestName], LR.[PersonOfInterestLastName], LR.[PersonOfInterestMobilePhoneNumber], LR.[PersonOfInterestMobileIMEI],
				(CASE WHEN dbo.CalculateExtraHours(VDMR.[EntryTime], VDMR.[ExitTime], SS.[WorkHours]) IS NULL THEN
						CASE WHEN VDMR.[ExitTime] IS NOT NULL AND LR.[Date] >= VDMR.[ExitTime] THEN ''
							 WHEN VDMR.[RestExitTime] IS NOT NULL AND LR.[Date] >= VDMR.[RestExitTime] THEN 'W'
							 WHEN VDMR.[RestEntryTime] IS NOT NULL AND LR.[Date] >= VDMR.[RestEntryTime] THEN 'R'
							 WHEN VDMR.[EntryTime] IS NOT NULL AND LR.[Date] >= VDMR.[EntryTime] THEN 'W'
							 ELSE ''
						END
					  ELSE
						CASE WHEN VDMR.[ExitTime] IS NOT NULL THEN
								CASE WHEN LR.[Date] >= (VDMR.[ExitTime] - CONVERT([sys].[datetime], dbo.CalculateExtraHours(VDMR.[EntryTime], VDMR.[ExitTime], SS.[WorkHours]))) THEN 'E'
									 ELSE
										CASE WHEN VDMR.[RestExitTime] IS NOT NULL AND LR.[Date] >= VDMR.[RestExitTime] THEN 'W'
											 WHEN VDMR.[RestEntryTime] IS NOT NULL AND LR.[Date] >= VDMR.[RestEntryTime] THEN 'R'
											 WHEN VDMR.[EntryTime] IS NOT NULL AND LR.[Date] >= VDMR.[EntryTime] THEN 'W'
											 ELSE ''
										END
								END
							 WHEN VDMR.[RestExitTime] IS NOT NULL AND LR.[Date] >= VDMR.[RestExitTime] THEN
								CASE WHEN DATEDIFF(SS, VDMR.[RestEntryTime], VDMR.[RestExitTime]) <= (DATEPART(HOUR, SS.[RestHours]) * 60 * 60 + DATEPART(MINUTE, SS.[RestHours]) * 60) THEN
										CASE WHEN DATEDIFF(SS, VDMR.[EntryTime], LR.[Date]) >= (DATEPART(HOUR, SS.[WorkHours]) * 60 * 60 + DATEPART(MINUTE, SS.[WorkHours]) * 60) THEN 'E'
											 ELSE 'W'
										END
									 ELSE
										CASE WHEN DATEDIFF(SS, VDMR.[EntryTime], LR.[Date] - CONVERT([sys].[varchar], (VDMR.[RestExitTime] - VDMR.[RestEntryTime]) - CAST(SS.[RestHours] AS [sys].[datetime]), 108)) >= (DATEPART(HOUR, SS.[WorkHours]) * 60 * 60 + DATEPART(MINUTE, SS.[WorkHours]) * 60) THEN 'E'
											 ELSE 'W'
										END
								END
							 WHEN VDMR.[RestEntryTime] IS NOT NULL AND LR.[Date] >= VDMR.[RestEntryTime] THEN 'R'
							 WHEN VDMR.[EntryTime] IS NOT NULL AND LR.[Date] >= VDMR.[EntryTime] THEN
								CASE WHEN DATEDIFF(SS, VDMR.[EntryTime], LR.[Date]) >= (DATEPART(HOUR, SS.[WorkHours]) * 60 * 60 + DATEPART(MINUTE, SS.[WorkHours]) * 60) THEN 'E'
									 ELSE 'W'
								END
							 ELSE ''
						END
				END) AS TimeType
	FROM		[dbo].[LocationReport] LR WITH (NOLOCK)
				LEFT OUTER JOIN ViewDetailedMarksReport VDMR WITH (NOLOCK) ON Tzdb.AreSameSystemDates(VDMR.[Date], LR.[Date]) = 1
				LEFT OUTER JOIN [dbo].[PersonOfInterestSchedule] SS WITH (NOLOCK) ON SS.[IdPersonOfInterest] = LR.[IdPersonOfInterest] AND SS.[IdDayOfWeek] = DATEPART(WEEKDAY, Tzdb.FromUtc(VDMR.[Date]))
	WHERE		Tzdb.AreSameSystemDates(LR.[Date], @Date) = 1 AND
				((@IdDepartments IS NULL) OR (LR.[PersonOfInterestIdDepartment] IS NULL) OR (dbo.CheckValueInList(LR.[PersonOfInterestIdDepartment], @IdDepartments) = 1)) AND
				((@Types IS NULL) OR (dbo.CheckCharValueInList(LR.[Type], @Types) = 1)) AND
				((@IdPersonOfInterest IS NULL) OR (LR.[IdPersonOfInterest] = @IdPersonOfInterest)) AND
				((@IdDepartments IS NOT NULL) OR (@IdUser IS NOT NULL AND dbo.CheckDepartmentInUserDepartments(LR.[PersonOfInterestIdDepartment], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(LR.[IdPersonOfInterest], @IdUser) = 1))
	GROUP BY	LR.[Id], LR.[IdPersonOfInterest], LR.[Date], LR.[Latitude], LR.[Longitude], LR.[Processed],
				LR.[PersonOfInterestName], LR.[PersonOfInterestLastName], LR.[PersonOfInterestMobilePhoneNumber], LR.[PersonOfInterestMobileIMEI],
				VDMR.[ExitTime], VDMR.[RestExitTime], VDMR.[RestEntryTime], VDMR.[EntryTime],
				SS.[WorkHours], SS.[RestHours]
	ORDER BY	LR.[IdPersonOfInterest], LR.[Date] ASC
END
