/****** Object:  Procedure [dbo].[GetNfcWorkingHoursGroupByPointOfInterestConfirmed]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Gaston Legnani
-- Create date: 17/01/2017
-- Description:	SP para GRAFICO DE REPORTES DE ACTIVIDADES DONDE SE MUESTRE LAS HORAS TRABAJADAS Y REGISTRADAS con tags NFC POR PUNTO EN UN PERIODO
-- =============================================
CREATE PROCEDURE [dbo].[GetNfcWorkingHoursGroupByPointOfInterestConfirmed]

	 @DateFrom [sys].[datetime] = NULL
	,@DateTo [sys].[datetime] = NULL
	,@IdPersonsOfInterest [sys].[varchar](max) = NULL
	,@IdPointsOfInterest [sys].[varchar](max) = NULL	
	,@IdUser [sys].[int] = NULL
	,@OnlyConfirmed [sys].[bit] = NULL
AS
BEGIN

	DECLARE @DateFromAux [sys].[datetime] = @DateFrom

	DECLARE @PointsOfInterestActivityDone TABLE
	(
		 [IdPersonOfInterest] [sys].[int]
		,[PersonOfInterestName] [sys].[varchar](50)
		,[PersonOfInterestLastName] [sys].[varchar](50)
		,[ActionDate] [sys].[datetime]
		,[IdDepartment] [sys].[INT]
		,[Latitude] [sys].[decimal](25,20)
		,[Longitude] [sys].[decimal](25,20)
		,[Address] [sys].[varchar](250)
		,[IdPointOfInterest] [sys].[int]
		,[PointOfInterestName] [sys].[varchar](100)
		,[PointOfInterestIdentifier] [sys].[varchar](50)
		,[AutomaticValue] [sys].[int]
		,[Reason] [sys].[varchar](100)
		,[ConfirmedVisit] [sys].[bit]
		,[Number] [sys].[int]
	)

	;WITH TablePartition AS 
	( 
		SELECT	[IdPersonOfInterest], [PersonOfInterestName], 
				[PersonOfInterestLastName], [ActionDate], [IdDepartment],	[Latitude], [Longitude], [Address],
				[IdPointOfInterest], [PointOfInterestName], [PointOfInterestIdentifier],
				[AutomaticValue], [Reason], [ConfirmedVisit],
				 ROW_NUMBER() OVER 
				 ( 
					 PARTITION BY IdPersonOfInterest, IdPointOfInterest, CAST(Tzdb.FromUtc(ActionDate) AS [sys].[date])
					 ORDER BY AutomaticValue 
				 ) AS Number 
		FROM [dbo].PointsOfInterestActivityDone(@DateFrom, @DateTo, NULL, NULL, @IdPersonsOfInterest, 
			@IdPointsOfInterest, @IdUser) POIV
	) 

	INSERT INTO @PointsOfInterestActivityDone
	(
		 [IdPersonOfInterest], [PersonOfInterestName],[PersonOfInterestLastName]
		,[ActionDate], [IdDepartment], [Latitude], [Longitude], [Address], [IdPointOfInterest], [PointOfInterestName]
		,[PointOfInterestIdentifier], [AutomaticValue], [Reason],[ConfirmedVisit], [Number]
	)
	SELECT * FROM TablePartition

		SELECT a.PointOfInterestId, a.PointOfInterestName, a.PointOfInterestIdentifier, 
		SUM(DATEDIFF(SECOND, '0:00:00', a.ElapsedTimeInMilliSeconds)) AS ElapsedTimeInSeconds
		FROM

		(SELECT	P.[Id] AS PointOfInterestId, P.[Name] AS PointOfInterestName,  P.[Identifier] AS PointOfInterestIdentifier,
				 [POIV].[ElapsedTime] AS ElapsedTimeInMilliSeconds
	
		
		FROM	[dbo].[PointOfInterestMark] POIV		
				INNER JOIN [dbo].[PointOfInterest] P ON P.[Id] = POIV.[IdPointOfInterest]
				INNER JOIN [dbo].[PersonOfInterest] S ON S.[Id] = POIV.[IdPersonOfInterest]
				LEFT OUTER JOIN	@PointsOfInterestActivityDone POID ON POIV.[IdPersonOfInterest] = POID.[IdPersonOfInterest]
					AND POIV.[IdPointOfInterest] = POID.[IdPointOfInterest] 
					AND (
						(POID.[ActionDate] BETWEEN POIV.[CheckInDate] AND POIV.[CheckOutDate]) 
						--OR (POID.[ActionDate] > POIMV.[CheckInDate] AND POIMV.[CheckOutDate] IS NULL)
					)
		
		WHERE	POIV.DeletedByNotVisited = 0 AND ((POIV.[CheckOutDate] IS NULL AND Tzdb.IsGreaterOrSameSystemDate(POIV.[CheckInDate], @DateFrom) = 1 AND Tzdb.IsLowerOrSameSystemDate(POIV.[CheckInDate], @DateTo) = 1) 
					OR (CAST(Tzdb.FromUtc(POIV.[CheckInDate]) AS [sys].[date]) BETWEEN CAST(Tzdb.FromUtc(@DateFrom) AS [sys].[date]) AND CAST(Tzdb.FromUtc(@DateTo) AS [sys].[date]))
					OR (CAST(Tzdb.FromUtc(POIV.[CheckOutDate]) AS [sys].[date]) BETWEEN CAST(Tzdb.FromUtc(@DateFrom) AS [sys].[date]) AND CAST(Tzdb.FromUtc(@DateTo) AS [sys].[date]))) AND
				((@IdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(S.[Id], @IdPersonsOfInterest) = 1)) AND
				((@IdPointsOfInterest IS NULL) OR (dbo.CheckValueInList(P.[Id], @IdPointsOfInterest) = 1)) AND			
				((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1))
				AND
				((@OnlyConfirmed IS NULL AND POID.[ConfirmedVisit] IS NULL) --SOLO SIN CONFIRMAR
				OR (@OnlyConfirmed IS NOT NULL AND POID.[ConfirmedVisit] IS NOT NULL)) --SOLO CONFIRMADOS

		GROUP BY  P.[Id], P.[Name], P.[Identifier], [POIV].[ElapsedTime])a

		group by a.PointOfInterestId, a.PointOfInterestName, a.PointOfInterestIdentifier
		ORDER BY ElapsedTimeInSeconds desc
    
END
