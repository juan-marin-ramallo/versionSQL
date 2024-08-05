/****** Object:  Procedure [dbo].[GetPointsOfInterestManualVisited]    Committed by VersionSQL https://www.versionsql.com ******/

-- Stored Procedure

-- =============================================
-- Author:		GL
-- Create date: 17/01/2016
-- Description:	SP para obtener los puntos de interés visitados de orma manual
-- =============================================
CREATE PROCEDURE [dbo].[GetPointsOfInterestManualVisited]
(
	 @DateFrom [sys].[datetime]
	,@DateTo [sys].[datetime]
	,@IdDepartments [sys].[varchar](max) = NULL
	,@IdPersonsOfInterest [sys].[varchar](max) = NULL
	,@IdPointsOfInterest [sys].[varchar](max) = NULL	
	,@IdUser [sys].[int] = NULL
)
AS
BEGIN
	;WITH vPointsManualVisited AS

	(
		SELECT	POIMV.[Id], POIMV.[CheckInDate], POIMV.[CheckOutDate], POIMV.[IdPointOfInterest], POIMV.[IdPersonOfInterest], POIMV.[ElapsedTime],
				POIMV.[Edited], POIMV.[CheckInImageName], POIMV.[CheckInImageUrl], POIMV.[CheckOutImageName], POIMV.[CheckOutImageUrl],
				POID.[ConfirmedVisit], POIMV.[TaskCompletition]
		FROM	[dbo].[PointOfInterestManualVisited] POIMV WITH (NOLOCK)
				LEFT OUTER JOIN	[dbo].PointsOfInterestActivityDoneSimplified(@DateFrom, @DateTo, @IdDepartments, NULL, @IdPersonsOfInterest, 
					@IdPointsOfInterest, @IdUser) POID ON POID.[IdPersonOfInterest] = POIMV.[IdPersonOfInterest]
						AND POID.[IdPointOfInterest] = POIMV.[IdPointOfInterest]
						AND POID.[ActionDate] BETWEEN POIMV.[CheckInDate] AND POIMV.[CheckOutDate]
		WHERE	POIMV.[DeletedByNotVisited] = 0 AND 
				((POIMV.[CheckOutDate] IS NULL AND POIMV.[CheckInDate] >= @DateFrom AND POIMV.[CheckInDate] <= @DateTo) 
					OR (POIMV.[CheckInDate] BETWEEN @DateFrom AND @DateTo) 
					OR (POIMV.[CheckOutDate] BETWEEN @DateFrom AND @DateTo))
	)

	,vPoints AS
	(
		SELECT	P.[Id], P.[Name], P.[Latitude], P.[Longitude], P.[Identifier], P.[Address], P.[IdDepartment], P.[FatherId], P.[GrandfatherId], P.[ContactName], P.[ContactPhoneNumber]

		FROM	[dbo].[PointOfInterest] P WITH (NOLOCK)
		WHERE	((@IdPointsOfInterest IS NULL) OR (dbo.CheckValueInList(P.[Id], @IdPointsOfInterest) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1) AND
					(dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1))
	)
	,vPersons AS
	(
		SELECT	S.[Id], S.[Name], S.[LastName], S.[MobileIMEI], S.[MobilePhoneNumber], S.[Identifier]
		FROM	[dbo].[PersonOfInterest] S WITH (NOLOCK)
		WHERE	((@IdDepartments IS NULL) OR (S.[IdDepartment] IS NULL) OR (dbo.CheckValueInList(S.[IdDepartment], @IdDepartments) = 1)) AND
				((@IdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(S.[Id], @IdPersonsOfInterest) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1) AND
					(dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1))
	)


	SELECT	POIMV.[Id] as IdPointOfInterestManualVisited, POIMV.[CheckInDate], POIMV.[CheckOutDate], POIMV.[IdPointOfInterest], [ElapsedTime]
			, P.[Name] AS PointOfInterestName, P.[ContactName] AS PointOfInterestContactName, P.[ContactPhoneNumber] AS PointOfInterestContactPhoneNumber
			, P.[Latitude], P.[Longitude], P.[Identifier] AS PointOfInterestIdentifier, S.[MobileIMEI] AS PersonOfInterestIMEI
            , S.[Id] AS IdPersonOfInterest, S.[Name] AS PersonOfInterestName,  S.[LastName] AS PersonOfInterestLastName
			, S.[MobilePhoneNumber] AS PersonOfInterestMobilePhoneNumber, S.[Identifier] AS PersonOfInterestIdentifier
			, DEP.[Id] AS DepartmentId, DEP.[Name] AS DepartmentName, P.[Address] AS PointOfInterestAddress
			, POI1.[Id] AS HierarchyLevel1Id, POI1.[Name] AS HierarchyLevel1Name
			, POI2.[Id] AS HierarchyLevel2Id, POI2.[Name] AS HierarchyLevel2Name, POIMV.[Edited], POIMV.[ConfirmedVisit] AS ConfirmedVisit
			, POIMV.[CheckInImageName], POIMV.[CheckInImageUrl], POIMV.[CheckOutImageName], POIMV.[CheckOutImageUrl], POIMV.[TaskCompletition]
	FROM	vPointsManualVisited POIMV WITH (NOLOCK)
			INNER JOIN vPoints P WITH (NOLOCK) ON P.[Id] = POIMV.[IdPointOfInterest]
			INNER JOIN vPersons S WITH (NOLOCK) ON S.[Id] = POIMV.[IdPersonOfInterest]
			LEFT OUTER JOIN [dbo].[Department] DEP WITH (NOLOCK) ON DEP.[Id] = P.[IdDepartment]
			LEFT OUTER JOIN [dbo].[POIHierarchyLevel1] POI1 WITH (NOLOCK) ON POI1.[Id] = P.[GrandfatherId]
			LEFT OUTER JOIN [dbo].[POIHierarchyLevel2] POI2 WITH (NOLOCK) ON POI2.[Id] = P.[FatherId]	 


	GROUP 
	BY		POIMV.[Id], S.[Id], S.[Name], S.[LastName], POIMV.[CheckInDate],
			POIMV.[CheckOutDate], POIMV.[IdPointOfInterest], P.[Name], [ElapsedTime], P.[Latitude], P.[Longitude], P.[Identifier], 
			P.[ContactName], P.[ContactPhoneNumber], P.[Address], S.[MobileIMEI], S.[MobilePhoneNumber], S.[Identifier], DEP.[Id], DEP.[Name],
			POI1.[Id], POI1.[Name], POI2.[Id], POI2.[Name] , POIMV.[Edited], POIMV.[ConfirmedVisit],
			POIMV.[CheckInImageName], POIMV.[CheckInImageUrl], POIMV.[CheckOutImageName], POIMV.[CheckOutImageUrl], POIMV.[TaskCompletition]
END
