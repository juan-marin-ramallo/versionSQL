/****** Object:  Procedure [dbo].[GetFiscalizationShiftModificationsReport]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 05/09/2023
-- Description:	SP para obtener los datos para
--              el reporte de fiscalización
--              de cambios de turnos de las
--              personas de interés
-- =============================================
CREATE PROCEDURE [dbo].[GetFiscalizationShiftModificationsReport]
(
     @PersonOfInterestIds [sys].[varchar](MAX) = NULL
    ,@WorkShiftIds [sys].[varchar](MAX) = NULL
    ,@PlaceOfWorkIds [sys].[varchar](MAX) = NULL
    ,@PersonOfInterestTypeCodes [sys].[varchar](MAX) = NULL
    ,@DateFrom [sys].[datetime]
    ,@DateTo [sys].[datetime]
)
AS
BEGIN
    SET @DateTo = Tzdb.ToUtc(DATEADD(DAY, 1, Tzdb.FromUtc(@DateTo)))

    SELECT      P.[Id] AS IdPersonOfInterest, P.[Name] AS PersonOfInterestName, P.[LastName] AS PersonOfInterestLastName, P.[Identifier] AS PersonOfInterestIdentifier,
                PIWSM.[Id], PIWSM.[Date], PIWSM.[IdDayOfWeek], PIWSM.[IdCurrentWorkShift], PIWSM.[CurrentWorkShiftStartTime], PIWSM.[CurrentWorkShiftEndTime], PIWSM.[CurrentWorkShiftAssignedDate],
                PIWSM.[IdWorkShiftRecurrenceType], PIWSM.[IdNewWorkShift], PIWSM.[NewWorkShiftStartTime], PIWSM.[NewWorkShiftEndTime], PIWSM.[IdWorkShiftRequestor], PIWSM.[NewWorkShiftAssignedDate],
                PIWSM.[IdWorkShiftRequestor]
    FROM        [dbo].[PersonOfInterest] P WITH (NOLOCK)
                INNER JOIN [dbo].[PersonOfInterestFiscalizationInfo] PFI WITH (NOLOCK) ON PFI.[IdPersonOfInterest] = P.[Id]
                LEFT OUTER JOIN [dbo].[PersonOfInterestWorkShiftModification] PIWSM WITH (NOLOCK) ON PIWSM.[IdPersonOfInterest] = P.[Id] AND PIWSM.[Date] BETWEEN @DateFrom AND @DateTo
    WHERE       --(PIWSM.[Id] IS NULL OR PIWSM.[Date] BETWEEN @DateFrom AND @DateTo)
                (@PersonOfInterestIds IS NULL OR dbo.[CheckValueInList](PIWSM.[IdPersonOfInterest], @PersonOfInterestIds) = 1)
                AND (@WorkShiftIds IS NULL OR dbo.[CheckValueInList](PIWSM.[IdCurrentWorkShift], @WorkShiftIds) = 1 OR dbo.[CheckValueInList](PIWSM.[IdNewWorkShift], @WorkShiftIds) = 1)
                AND (@PlaceOfWorkIds IS NULL OR dbo.[CheckValueInList](PFI.[IdPlaceOfWork], @PlaceOfWorkIds) = 1)
                AND (@PersonOfInterestTypeCodes IS NULL OR dbo.[CheckCharValueInList](P.[Type], @PersonOfInterestTypeCodes) = 1)
                AND P.[Deleted] = 0
                AND P.[Pending] = 0
                AND P.[Status] = 'H'
    ORDER BY    P.[Name], P.[LastName], PIWSM.[Date], PIWSM.[IdDayOfWeek];
END
