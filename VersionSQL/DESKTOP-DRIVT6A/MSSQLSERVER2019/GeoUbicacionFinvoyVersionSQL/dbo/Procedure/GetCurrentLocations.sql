/****** Object:  Procedure [dbo].[GetCurrentLocations]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 28/09/2012
-- Description:	SP para obtener las ubicaciones actuales de los repositores
-- =============================================
CREATE PROCEDURE [dbo].[GetCurrentLocations]
(
	 @IdDepartments [sys].[varchar](max) = NULL
	,@Types [sys].[varchar](max) = NULL
	,@IdPersonsOfInterest [sys].[varchar](max) = NULL
	,@IdUser [sys].[int] = NULL
)
AS
BEGIN
	SELECT	CL.[IdLocation] AS Id, CL.[Date], CL.[Latitude], CL.[Longitude], 0 AS Processed, CL.[IdPersonOfInterest], 
			S.[Name] AS PersonOfInterestName, S.[LastName] AS PersonOfInterestLastName, S.[Identifier] AS PersonOfInterestIdentifier, 
			S.[MobilePhoneNumber] AS PersonOfInterestMobilePhoneNumber,
			--CASE WHEN LMV.[Type] = 'FS' THEN 1 ELSE 0 END AS PersonOfInterestHasLoggedOut,
			--VP.[PlateNumber] AS VehiclePlateNumber,
			CL.[BatteryLevel]
	FROM	[dbo].[PersonOfInterest] S WITH (NOLOCK)
			INNER JOIN [dbo].[CurrentLocation] CL WITH (NOLOCK) ON CL.[IdPersonOfInterest] = S.[Id]
			--LEFT OUTER JOIN LastMarkView LMV WITH (NOLOCK) ON LMV.[IdPersonOfInterest] = S.[Id]			
	WHERE	S.[Deleted] = 0 AND
			--(LMV.RowNumber IS NULL OR LMV.RowNumber = 1) AND
			((@IdDepartments IS NULL) OR (S.[IdDepartment] IS NULL) OR (dbo.CheckValueInList(S.[IdDepartment], @IdDepartments) = 1)) AND
			((@Types IS NULL) OR (dbo.CheckCharValueInList(S.[Type], @Types) = 1)) AND
			((@IdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(S.[Id], @IdPersonsOfInterest) = 1)) AND
			--((@IdVehiclePlates IS NULL) OR (dbo.CheckValueInList(VP.[Id], @IdVehiclePlates) = 1)) AND
			((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1)) AND
			((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1))

	--;WITH LocationsView AS
	--(
	--	SELECT	ROW_NUMBER() OVER(PARTITION BY [IdPersonOfInterest] ORDER BY [Date] DESC) as RowNumber,
	--			[Id], [IdPersonOfInterest], [Date], [Latitude], [Longitude], [Processed], [BatteryLevel]
	--	FROM	[dbo].[Location] WITH (NOLOCK)
	--)
	
	----,
	----LastMarkView AS
	----(
	----	SELECT	ROW_NUMBER() OVER(PARTITION BY [IdPersonOfInterest] ORDER BY [Id] DESC) as RowNumber,
	----			[IdPersonOfInterest], [Type], [IdPlate]
	----	FROM	[dbo].[Mark] WITH (NOLOCK)
	----)
	
	--SELECT	LV.[Id], LV.[Date], LV.[Latitude], LV.[Longitude], LV.[Processed], LV.[IdPersonOfInterest], 
	--		S.[Name] AS PersonOfInterestName, S.[LastName] AS PersonOfInterestLastName, S.[MobilePhoneNumber] AS PersonOfInterestMobilePhoneNumber,
	--		--CASE WHEN LMV.[Type] = 'FS' THEN 1 ELSE 0 END AS PersonOfInterestHasLoggedOut,
	--		--VP.[PlateNumber] AS VehiclePlateNumber,
	--		LV.[BatteryLevel]
	--FROM	[dbo].[PersonOfInterest] S WITH (NOLOCK)
	--		INNER JOIN LocationsView LV WITH (NOLOCK) ON LV.[IdPersonOfInterest] = S.[Id]
	--		--LEFT OUTER JOIN LastMarkView LMV WITH (NOLOCK) ON LMV.[IdPersonOfInterest] = S.[Id]			
	--WHERE	S.[Deleted] = 0 AND LV.RowNumber = 1 AND 
	--		--(LMV.RowNumber IS NULL OR LMV.RowNumber = 1) AND
	--		((@IdDepartments IS NULL) OR (S.[IdDepartment] IS NULL) OR (dbo.CheckValueInList(S.[IdDepartment], @IdDepartments) = 1)) AND
	--		((@Types IS NULL) OR (dbo.CheckCharValueInList(S.[Type], @Types) = 1)) AND
	--		((@IdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(S.[Id], @IdPersonsOfInterest) = 1)) AND
	--		--((@IdVehiclePlates IS NULL) OR (dbo.CheckValueInList(VP.[Id], @IdVehiclePlates) = 1)) AND
	--		((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1)) AND
	--		((@IdUser IS NULL) OR (dbo.CheckZoneInUserZones(S.[IdZone], @IdUser) = 1))
END
