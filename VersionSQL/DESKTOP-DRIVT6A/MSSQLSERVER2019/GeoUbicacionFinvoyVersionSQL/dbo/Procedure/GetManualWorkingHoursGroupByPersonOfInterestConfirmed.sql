/****** Object:  Procedure [dbo].[GetManualWorkingHoursGroupByPersonOfInterestConfirmed]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Gaston Legnani
-- Create date: 16/10/2015
-- Description:	SP para GRAFICO DE REPORTES DE ACTIVIDADES DONDE SE MUESTRE LAS HORAS TRABAJADAS registradas de forma manual POR persona en determinado periodo
-- =============================================
CREATE PROCEDURE [dbo].[GetManualWorkingHoursGroupByPersonOfInterestConfirmed]

	 @DateFrom [sys].[datetime] = NULL
	,@DateTo [sys].[datetime] = NULL
	,@IdDepartments [sys].[varchar](max) = NULL
	,@IdPersonsOfInterest [sys].[varchar](max) = NULL
	,@IdPointsOfInterest [sys].[varchar](max) = NULL	
	,@IdUser [sys].[int] = NULL
	,@OnlyScheduled [sys].[bit] = NULL
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
		FROM [dbo].PointsOfInterestActivityDone(@DateFrom, @DateTo, @IdDepartments, NULL, @IdPersonsOfInterest, 
			@IdPointsOfInterest, @IdUser) POIV
	) 

	INSERT INTO @PointsOfInterestActivityDone
	(
		 [IdPersonOfInterest], [PersonOfInterestName],[PersonOfInterestLastName]
		,[ActionDate], [IdDepartment], [Latitude], [Longitude], [Address], [IdPointOfInterest], [PointOfInterestName]
		,[PointOfInterestIdentifier], [AutomaticValue], [Reason],[ConfirmedVisit], [Number]
	)
	SELECT * FROM TablePartition 

	SELECT a.PersonOfInterestId, a.PersonOfInterestName, a.PersonOfInterestLastName, 
		SUM(DATEDIFF(SECOND, '0:00:00', a.ElapsedTimeInMilliSeconds)) AS ElapsedTimeInSeconds
		FROM

		(SELECT	S.[Id] AS PersonOfInterestId, S.[Name] AS PersonOfInterestName,  S.[LastName] AS PersonOfInterestLastName,
				 [POIV].[ElapsedTime] AS ElapsedTimeInMilliSeconds
	
		FROM	[dbo].[PointOfInterestManualVisited] POIV		
				INNER JOIN [dbo].[PointOfInterest] P ON P.[Id] = POIV.[IdPointOfInterest]
				INNER JOIN [dbo].[PersonOfInterest] S ON S.[Id] = POIV.[IdPersonOfInterest]
				LEFT OUTER JOIN	@PointsOfInterestActivityDone POID ON POIV.[IdPersonOfInterest] = POID.[IdPersonOfInterest]
								AND POIV.[IdPointOfInterest] = POID.[IdPointOfInterest] 
								AND (
									(POID.[ActionDate] BETWEEN POIV.[CheckInDate] AND POIV.[CheckOutDate]) 
								)

		WHERE	POIV.DeletedByNotVisited = 0 AND ((POIV.[CheckOutDate] IS NULL AND Tzdb.IsGreaterOrSameSystemDate(POIV.[CheckInDate], @DateFrom) = 1 AND Tzdb.IsLowerOrSameSystemDate(POIV.[CheckInDate], @DateTo) = 1) 
					OR (CAST(Tzdb.FromUtc(POIV.[CheckInDate]) AS [sys].[date]) BETWEEN CAST(Tzdb.FromUtc(@DateFrom) AS [sys].[date]) AND CAST(Tzdb.FromUtc(@DateTo) AS [sys].[date]))
					OR (CAST(Tzdb.FromUtc(POIV.[CheckOutDate]) AS [sys].[date]) BETWEEN CAST(Tzdb.FromUtc(@DateFrom) AS [sys].[date]) AND CAST(Tzdb.FromUtc(@DateTo) AS [sys].[date]))) AND
				((@IdDepartments IS NULL) OR (S.[IdDepartment] IS NULL) OR (dbo.CheckValueInList(S.[IdDepartment], @IdDepartments) = 1)) AND
				((@IdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(S.[Id], @IdPersonsOfInterest) = 1)) AND
				((@IdPointsOfInterest IS NULL) OR (dbo.CheckValueInList(P.[Id], @IdPointsOfInterest) = 1)) AND			
				((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1))
				AND
				((@OnlyConfirmed IS NULL AND POID.[ConfirmedVisit] IS NULL) --SOLO SIN CONFIRMAR
				OR (@OnlyConfirmed IS NOT NULL AND POID.[ConfirmedVisit] IS NOT NULL)) --SOLO CONFIRMADOS

		GROUP BY  S.[Id], S.[Name] ,  S.[LastName], [POIV].[ElapsedTime])a

		group by a.PersonOfInterestId, a.PersonOfInterestName, a.PersonOfInterestLastName
		ORDER BY ElapsedTimeInSeconds desc
    
	

END
