/****** Object:  Procedure [dbo].[GetCurrentLocationsOnlyActive]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Diego Caceres
-- Create date: 24/08/20166
-- Description:	SP para obtener las ubicaciones actuales de los repositores solo ACTIVOS
-- =============================================
CREATE PROCEDURE [dbo].[GetCurrentLocationsOnlyActive]
(
	 @IdDepartments [sys].[varchar](max) = NULL
	,@Types [sys].[varchar](max) = NULL
	,@IdPersonsOfInterest [sys].[varchar](max) = NULL
	,@IdUser [sys].[int] = NULL
)
AS
BEGIN
    ;WITH vCurrentLocations([IdLocation], [Date], [DateSystem], [Latitude], [Longitude], [IdPersonOfInterest], [BatteryLevel]) AS
    (
        SELECT	CL.[IdLocation], CL.[Date], Tzdb.FromUtc(CL.[Date]) AS DateSystem,
                CL.[Latitude], CL.[Longitude], CL.[IdPersonOfInterest], CL.[BatteryLevel]
	    FROM	[dbo].[CurrentLocation] CL WITH (NOLOCK)
    )

	SELECT	CL.[IdLocation] AS Id, CL.[Date], CL.[Latitude], CL.[Longitude], 0 AS Processed, CL.[IdPersonOfInterest], 
			S.[Name] AS PersonOfInterestName, S.[LastName] AS PersonOfInterestLastName, S.[Identifier] AS PersonOfInterestIdentifier, 
			S.[MobilePhoneNumber] AS PersonOfInterestMobilePhoneNumber,
			--CASE WHEN LMV.[Type] = 'FS' THEN 1 ELSE 0 END AS PersonOfInterestHasLoggedOut,
			--VP.[PlateNumber] AS VehiclePlateNumber,
			CL.[BatteryLevel]
	FROM	[dbo].[PersonOfInterest] S WITH (NOLOCK)
			INNER JOIN vCurrentLocations CL WITH (NOLOCK) ON CL.[IdPersonOfInterest] = S.[Id]
			--LEFT OUTER JOIN LastMarkView LMV WITH (NOLOCK) ON LMV.[IdPersonOfInterest] = S.[Id]			
	WHERE	S.[Deleted] = 0 AND
			--(LMV.RowNumber IS NULL OR LMV.RowNumber = 1) AND
			((@IdDepartments IS NULL) OR (S.[IdDepartment] IS NULL) OR (dbo.CheckValueInList(S.[IdDepartment], @IdDepartments) = 1)) AND
			((@Types IS NULL) OR (dbo.CheckCharValueInList(S.[Type], @Types) = 1)) AND
			((@IdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(S.[Id], @IdPersonsOfInterest) = 1)) AND
			--((@IdVehiclePlates IS NULL) OR (dbo.CheckValueInList(VP.[Id], @IdVehiclePlates) = 1)) AND
			((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1)) AND
			((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1))
			AND DATEDIFF(DAY, CL.[DateSystem], Tzdb.FromUtc(GETUTCDATE())) = 0
END

-- OLD)
-- BEGIN
-- 	SELECT	CL.[IdLocation] AS Id, CL.[Date], CL.[Latitude], CL.[Longitude], 0 AS Processed, CL.[IdPersonOfInterest], 
-- 			S.[Name] AS PersonOfInterestName, S.[LastName] AS PersonOfInterestLastName, S.[MobilePhoneNumber] AS PersonOfInterestMobilePhoneNumber,
-- 			--CASE WHEN LMV.[Type] = 'FS' THEN 1 ELSE 0 END AS PersonOfInterestHasLoggedOut,
-- 			--VP.[PlateNumber] AS VehiclePlateNumber,
-- 			CL.[BatteryLevel]
-- 	FROM	[dbo].[PersonOfInterest] S WITH (NOLOCK)
-- 			INNER JOIN [dbo].[CurrentLocation] CL WITH (NOLOCK) ON CL.[IdPersonOfInterest] = S.[Id]
-- 			--LEFT OUTER JOIN LastMarkView LMV WITH (NOLOCK) ON LMV.[IdPersonOfInterest] = S.[Id]			
-- 	WHERE	S.[Deleted] = 0 AND
-- 			--(LMV.RowNumber IS NULL OR LMV.RowNumber = 1) AND
-- 			((@IdDepartments IS NULL) OR (S.[IdDepartment] IS NULL) OR (dbo.CheckValueInList(S.[IdDepartment], @IdDepartments) = 1)) AND
-- 			((@Types IS NULL) OR (dbo.CheckCharValueInList(S.[Type], @Types) = 1)) AND
-- 			((@IdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(S.[Id], @IdPersonsOfInterest) = 1)) AND
-- 			--((@IdVehiclePlates IS NULL) OR (dbo.CheckValueInList(VP.[Id], @IdVehiclePlates) = 1)) AND
-- 			((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1)) AND
-- 			((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1))
-- 			AND Tzdb.AreSameSystemDates(CL.Date, GETUTCDATE()) = 1


-- END
