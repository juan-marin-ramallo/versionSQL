/****** Object:  TableFunction [dbo].[GetDetailedMarksReportIncludeNonMarks]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 27/02/2013
-- Description:	SP para obtener un reporte de marcas realizadas
-- =============================================
CREATE FUNCTION [dbo].[GetDetailedMarksReportIncludeNonMarks]
(
	 @DateFrom [sys].[datetime]
	,@DateTo [sys].[datetime]
	,@IdDepartments [sys].[varchar](1000) = NULL
	,@Types [sys].[varchar](1000) = NULL
	,@IdPersonsOfInterest [sys].[varchar](max) = NULL
	,@IdUser [sys].[int] = NULL
	,@IncludeNonMarks [sys].[bit] = NULL
)
RETURNS @t TABLE (IdPersonOfInterest [sys].[int], [Id] [sys].[int], [Date] [sys].[datetime],
	 PersonOfInterestName [sys].[varchar](50), PersonOfInterestLastName [sys].[varchar](50), 
	 PersonOfInterestIdentifier [sys].[varchar](20), PersonOfInterestMobilePhoneNumber [sys].[varchar](20), PersonOfInterestMobileIMEI [sys].[varchar](40),
	 [EntryTime] [sys].[datetime], [EntryLatitude] [sys].[decimal](18,6), [EntryLongitude] [sys].[decimal](18,6), 
	 [RestEntryTime] [sys].[datetime], [RestEntryLatitude] [sys].[decimal](18,6), [RestEntryLongitude] [sys].[decimal](18,6),
	 [RestExitTime] [sys].[datetime], [RestExitLatitude] [sys].[decimal](18,6), [RestExitLongitude] [sys].[decimal](18,6),
	 [ExitTime] [sys].[datetime], [ExitLatitude] [sys].[decimal](18,6), [ExitLongitude] [sys].[decimal](18,6),
	 [WorkedHours] [sys].[datetime], [RestedHours] [sys].[datetime], [ExtraHours] [sys].[datetime], 
	 [LessWorkedHours] [sys].[bit], [MoreRestedHours] [sys].[bit],
	 [IdPointOfInterestIn] [sys].[int], [PointOfInterestInName] [sys].[varchar](100),[PointOfInterestInIdentifier] [sys].[varchar](50), 
	 [PointOfInterestInLatitude] [sys].[decimal](18,2), [PointOfInterestInLongitude] [sys].[decimal](18,2),
	 [IdPointOfInterestOut] [sys].[int], [PointOfInterestOutName] [sys].[varchar](100), [PointOfInterestOutIdentifier] [sys].[varchar](50),
	 [PointOfInterestOutLatitude] [sys].[decimal](18,2), [PointOfInterestOutLongitude] [sys].[decimal](18,2)
	 )
AS
BEGIN

		DECLARE @AllPersonOfInterestDates TABLE
		(
			GroupedDate [sys].[DATETIME], IdPersonOfInterest [sys].[int], PersonOfInterestName [sys].[varchar](50)
			, PersonOfInterestLastName [sys].[varchar](50), PersonOfInterestIdentifier [sys].[varchar](50),
			PersonOfInterestMobilePhoneNumber [sys].[varchar](20), PersonOfInterestMobileIMEI [sys].[varchar](40)
		)

		WHILE (@DateFrom <= @DateTo) 
		BEGIN

			INSERT INTO @AllPersonOfInterestDates(GroupedDate, IdPersonOfInterest, PersonOfInterestName, PersonOfInterestLastName,
			  PersonOfInterestIdentifier, PersonOfInterestMobilePhoneNumber, PersonOfInterestMobileIMEI)
			SELECT DISTINCT @DateFrom, P.[Id], P.[Name], P.[LastName], P.[Identifier],
			  P.[MobilePhoneNumber], P.[MobileIMEI]
			FROM [dbo].[PersonOfInterest] P WITH (NOLOCK)
			  JOIN PersonOfInterestSchedule S WITH (NOLOCK) ON S.IdPersonOfInterest = P.Id
			WHERE P.[Deleted] = 0
			  AND S.IdDayOfWeek = DATEPART(WEEKDAY, Tzdb.FromUtc(@DateFrom))
			  AND ((@IdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(P.[Id], @IdPersonsOfInterest) = 1))
			  AND P.[Id] NOT IN (SELECT PA.[IdPersonOfInterest]
								 FROM    [dbo].[PersonOfInterestAbsence] PA WITH (NOLOCK)
								 WHERE   @DateFrom >= PA.[FromDate] AND (PA.[ToDate] IS NULL OR @DateFrom < PA.[ToDate]))

			SET @DateFrom = DATEADD(day, 1, @DateFrom)
		END

		INSERT INTO @t 
		SELECT	D.[IdPersonOfInterest], VDMR.[Id], D.GroupedDate AS Date, D.PersonOfInterestName, 
				D.PersonOfInterestLastName, D.PersonOfInterestIdentifier, D.PersonOfInterestMobilePhoneNumber, 
				D.PersonOfInterestMobileIMEI,
				VDMR.EntryTime, VDMR.[EntryLatitude], VDMR.[EntryLongitude], 
				VDMR.[RestEntryTime], VDMR.[RestEntryLatitude],
				VDMR.[RestEntryLongitude],VDMR.[RestExitTime], VDMR.[RestExitLatitude], 
				VDMR.[RestExitLongitude],
				VDMR.[ExitTime], VDMR.[ExitLatitude], VDMR.[ExitLongitude], VDMR.WorkedHours, VDMR.RestedHours,
				VDMR.ExtraHours, VDMR.LessWorkedHours, VDMR.MoreRestedHours, VDMR.[IdPointOfInterestIn], VDMR.[PointOfInterestInName], 
				VDMR.[PointOfInterestInIdentifier], VDMR.[PointOfInterestInLatitude], VDMR.[PointOfInterestInLongitude], 
				VDMR.[IdPointOfInterestOut], VDMR.[PointOfInterestOutName], VDMR.[PointOfInterestOutIdentifier], VDMR.[PointOfInterestOutLatitude], 
				VDMR.[PointOfInterestOutLongitude]
		FROM	@AllPersonOfInterestDates D
		LEFT JOIN	[dbo].[GetDetailedMarks](@DateFrom, @DateTo, @IdDepartments, @Types, @IdPersonsOfInterest, @IdUser) VDMR
					ON VDMR.[IdPersonOfInterest] = D.[IdPersonOfInterest] AND Tzdb.AreSameSystemDates(VDMR.[Date], D.[GroupedDate]) = 1 

		RETURN
END
