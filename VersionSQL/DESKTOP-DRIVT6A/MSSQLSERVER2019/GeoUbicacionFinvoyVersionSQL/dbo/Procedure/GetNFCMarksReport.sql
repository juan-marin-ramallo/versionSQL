/****** Object:  Procedure [dbo].[GetNFCMarksReport]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 28/03/2016
-- Description:	SP para obtener un reporte de entrada y salida utilizando los tags nfc
-- =============================================
CREATE PROCEDURE [dbo].[GetNFCMarksReport]

	 @DateFrom [sys].[datetime]
	,@DateTo [sys].[datetime]
	,@IdPersonsOfInterest [sys].[varchar](max) = NULL
	,@IdPointsOfInterest [sys].[varchar](max) = NULL
	,@IdUser [sys].[int] = NULL
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

	SELECT	POIMV.[Id] as IdPointOfInterestNFCVisited, S.[Id] AS IdPersonOfInterest, S.[Name] AS PersonOfInterestName, 
			S.[LastName] AS PersonOfInterestLastName, POIMV.[CheckInDate], POIMV.[CheckOutDate], 
			POIMV.[IdPointOfInterest], P.[Name] AS PointOfInterestName,  [ElapsedTime],
			P.[Latitude], P.[Longitude], P.[Identifier] AS PointOfInterestIdentifier, POIMV.[Edited], POIMV.[Completition],
			POID.[ConfirmedVisit] AS ConfirmedVisit 

	FROM	[dbo].[PointOfInterestMark] POIMV
			INNER JOIN [dbo].[PointOfInterest] P ON P.[Id] = POIMV.[IdPointOfInterest]
			INNER JOIN [dbo].[PersonOfInterest] S ON S.[Id] = POIMV.[IdPersonOfInterest]
			LEFT OUTER JOIN	@PointsOfInterestActivityDone POID ON POIMV.[IdPersonOfInterest] = POID.[IdPersonOfInterest]
					AND POIMV.[IdPointOfInterest] = POID.[IdPointOfInterest] 
					AND (
						(POID.[ActionDate] BETWEEN POIMV.[CheckInDate] AND POIMV.[CheckOutDate]) 
						--OR (POID.[ActionDate] > POIMV.[CheckInDate] AND POIMV.[CheckOutDate] IS NULL)
					)

	WHERE	POIMV.[DeletedByNotVisited] = 0 AND 
			((POIMV.[CheckOutDate] IS NULL AND POIMV.[CheckInDate] >= @DateFrom AND POIMV.[CheckInDate] <= @DateTo) 
				OR (POIMV.[CheckInDate] BETWEEN @DateFrom AND @DateTo) 
				OR (POIMV.[CheckOutDate] BETWEEN @DateFrom AND @DateTo)) AND
			((@IdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(S.[Id], @IdPersonsOfInterest) = 1)) AND
			((@IdPointsOfInterest IS NULL) OR (dbo.CheckValueInList(P.[Id], @IdPointsOfInterest) = 1)) AND			
			((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1)) AND
			((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1)) AND
			((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1)) AND
			((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1))	 

	GROUP BY	POIMV.[Id], S.[Id], S.[Name], S.[LastName], POIMV.[CheckInDate], POIMV.[CheckOutDate], 
				POIMV.[IdPointOfInterest], P.[Name],  [ElapsedTime], P.[Latitude], P.[Longitude], P.[Identifier],
				POIMV.[Edited], POIMV.[Completition], POID.[ConfirmedVisit]
END
