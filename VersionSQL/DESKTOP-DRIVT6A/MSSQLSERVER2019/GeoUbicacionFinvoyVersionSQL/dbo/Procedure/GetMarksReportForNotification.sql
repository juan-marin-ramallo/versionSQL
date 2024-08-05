/****** Object:  Procedure [dbo].[GetMarksReportForNotification]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 09/09/2023
-- Description:	SP para obtener un reporte de
--              marcas realizadas para enviar
--              en la notificación a empleadores
-- =============================================
CREATE PROCEDURE [dbo].[GetMarksReportForNotification]
AS
BEGIN
    DECLARE @Now [sys].[datetime] = GETUTCDATE();
    DECLARE @DateFrom [sys].[datetime] = Tzdb.ToUtc(DATEADD(DAY, DATEDIFF(DAY, 0, Tzdb.FromUtc(@Now)), 0));
    DECLARE @DateTo [sys].[datetime] = @Now;

	CREATE TABLE #AllPersonOfInterestDates
    (
        GroupedDate [sys].[DATETIME], IdPersonOfInterest [sys].[int], PersonOfInterestName [sys].[varchar](50)
        , PersonOfInterestLastName [sys].[varchar](50), PersonOfInterestIdentifier [sys].[varchar](50),
        PersonOfInterestMobilePhoneNumber [sys].[varchar](20), PersonOfInterestMobileIMEI [sys].[varchar](40),
        IdDayOfWeek [sys].[int]
    )

    INSERT INTO #AllPersonOfInterestDates(GroupedDate, IdPersonOfInterest, PersonOfInterestName, PersonOfInterestLastName,
        PersonOfInterestIdentifier, PersonOfInterestMobilePhoneNumber, PersonOfInterestMobileIMEI, IdDayOfWeek)
    SELECT DISTINCT @DateFrom, P.[Id], P.[Name], P.[LastName], P.[Identifier],
        P.[MobilePhoneNumber], P.[MobileIMEI], PWS.IdDayOfWeek
    FROM [dbo].[PersonOfInterest] P WITH (NOLOCK)
        LEFT OUTER JOIN [dbo].[PersonOfInterestWorkShift] PWS WITH (NOLOCK) ON PWS.[IdPersonOfInterest] = P.[Id] AND  PWS.IdDayOfWeek = DATEPART(WEEKDAY, Tzdb.FromUtc(@Now))
    WHERE P.[Deleted] = 0
        AND P.[Pending] = 0
        AND P.[Status] = 'H'
        AND P.[Id] NOT IN (SELECT PA.[IdPersonOfInterest]
                            FROM    [dbo].[PersonOfInterestAbsence] PA WITH (NOLOCK)
                            WHERE   @DateFrom >= PA.[FromDate] AND (PA.[ToDate] IS NULL OR @DateFrom < PA.[ToDate]));

    SELECT	D.[IdPersonOfInterest], D.GroupedDate AS Date, VDMR.[Id], D.PersonOfInterestName, 
            D.PersonOfInterestLastName, D.PersonOfInterestIdentifier, D.PersonOfInterestMobilePhoneNumber, 
            D.PersonOfInterestMobileIMEI, D.IdDayOfWeek,
            VDMR.EntryTime, VDMR.[EntryLatitude], VDMR.[EntryLongitude],  VDMR.[EditedEntryTime],
            VDMR.[RestEntryTime], VDMR.[RestEntryLatitude], VDMR.[RestEntryLongitude],VDMR.[EditedRestEntryTime],
			VDMR.[RestExitTime], VDMR.[RestExitLatitude], VDMR.[RestExitLongitude], VDMR.[EditedRestExitTime],
            VDMR.[ExitTime], VDMR.[ExitLatitude], VDMR.[ExitLongitude], VDMR.[EditedExitTime],
			VDMR.WorkedHours, VDMR.RestedHours,
            VDMR.ExtraHours, VDMR.LessWorkedHours, VDMR.MoreWorkedHours, VDMR.MoreRestedHours, VDMR.[IdPointOfInterestIn], VDMR.[PointOfInterestInName], 
            VDMR.[PointOfInterestInIdentifier], VDMR.[PointOfInterestInLatitude], VDMR.[PointOfInterestInLongitude], 
            VDMR.[IdPointOfInterestOut], VDMR.[PointOfInterestOutName], VDMR.[PointOfInterestOutIdentifier], VDMR.[PointOfInterestOutLatitude], 
            VDMR.[PointOfInterestOutLongitude], VDMR.[ExitMarkId], VDMR.[TraveledDistance], VDMR.IsJustification, VDMR.IdAbsenceReason, VDMR.FromHour, VDMR.ToHour, '' as comment
    FROM	#AllPersonOfInterestDates D
            LEFT JOIN [dbo].[GetDetailedMarks](@DateFrom, @DateTo, NULL, NULL, NULL, NULL) VDMR
                ON VDMR.[IdPersonOfInterest] = D.[IdPersonOfInterest] AND Tzdb.AreSameSystemDates(VDMR.[Date], D.[GroupedDate]) = 1 
    ORDER BY D.PersonOfInterestName ASC, D.PersonOfInterestLastName ASC, VDMR.[EntryTime] ASC;

    DROP TABLE #AllPersonOfInterestDates;
END
