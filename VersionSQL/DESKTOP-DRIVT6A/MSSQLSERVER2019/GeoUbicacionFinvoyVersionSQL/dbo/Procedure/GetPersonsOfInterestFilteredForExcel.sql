/****** Object:  Procedure [dbo].[GetPersonsOfInterestFilteredForExcel]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 25/10/2012
-- Description:	SP para obtener los repositores filtrados por ciertos parámetros P[ARA EXCEL
-- =============================================
CREATE PROCEDURE [dbo].[GetPersonsOfInterestFilteredForExcel]
(
	 @IdDepartments [sys].[varchar](max) = NULL
	,@Types [sys].[varchar](max) = NULL
	,@Imeis [sys].[varchar](max) = NULL
	,@CellPhoneNumbers [sys].[varchar](max) = NULL
	,@PersonOfInterestIds [sys].[varchar](max) = NULL
	,@ProfilesId [sys].[varchar](max) = NULL
	,@Status [sys].[varchar](10) = NULL
	,@IdUser [sys].[int] = NULL
	,@Identifiers [sys].[varchar](max) = NULL
	,@IncludeDeleted [sys].[bit] = 0
)
AS
BEGIN
	
	IF @IncludeDeleted = 0
	BEGIN
		SELECT		S.[Id], S.[Name], S.[LastName],S.[Identifier], S.[MobilePhoneNumber], S.[MobileIMEI], S.[Status], S.[Type], S.[Email],
					ST.[Description] AS TypeDescription, S.[IdDepartment], S.[Name] as DepartmentName,S.DeviceBrand, S.DeviceModel, S.AndroidVersion,
					Z.[Id] AS IdZone , Z.[Description] AS ZoneName, L.[Date] AS [CurrentLocationDate], 0 AS Deleted
	
		FROM		[dbo].[AvailablePersonOfInterest] S WITH (NOLOCK)
					LEFT OUTER JOIN [dbo].[Department] D WITH (NOLOCK) ON D.[Id] = S.[IdDepartment]
					LEFT OUTER JOIN [dbo].[PersonOfInterestType] ST WITH (NOLOCK) ON ST.[Code] = S.[Type]
					LEFT OUTER JOIN [dbo].[PersonOfInterestZone] PZ WITH (NOLOCK) ON S.[Id] = PZ.[IdPersonOfInterest]
					LEFT OUTER JOIN [dbo].[ZoneTranslated] Z WITH (NOLOCK) ON Z.[Id] = PZ.[IdZone] AND Z.[ApplyToAllPersonOfInterest] = 0
					LEFT OUTER JOIN [dbo].[CurrentLocation] L WITH (NOLOCK) ON S.[Id] = L.[IdPersonOfInterest]
	
		WHERE		((@IdDepartments IS NULL) OR (S.[IdDepartment] IS NULL) OR (dbo.CheckValueInList(S.[IdDepartment], @IdDepartments) = 1)) AND
					((@Types IS NULL) OR (dbo.CheckCharValueInList(S.[Type], @Types) = 1)) AND
					((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1)) AND
					((@Imeis IS NULL) OR (dbo.CheckVarcharInList(S.[MobileIMEI], @Imeis) = 1)) AND
					((@CellPhoneNumbers IS NULL) OR (dbo.CheckVarcharInList(S.[MobilePhoneNumber], @CellPhoneNumbers) = 1)) AND
					((@PersonOfInterestIds IS NULL) OR (dbo.CheckValueInList(S.[Id], @PersonOfInterestIds) = 1)) AND
					((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1)) AND
					((@ProfilesId IS NULL) OR (dbo.CheckVarcharInList(ST.[Code], @ProfilesId) = 1)) AND
					((@Status IS NULL) OR (S.[Status] = @Status)) AND
					(@Identifiers IS NULL OR dbo.CheckVarcharInList(S.Identifier, @Identifiers) = 1)
	
		ORDER BY	S.[Name], S.[LastName]
	END
	ELSE
	BEGIN
		SELECT		S.[Id], S.[Name], S.[LastName],S.[Identifier], S.[MobilePhoneNumber], S.[MobileIMEI], S.[Status], S.[Type], S.[Email],
					ST.[Description] AS TypeDescription, S.[IdDepartment], S.[Name] as DepartmentName,S.DeviceBrand, S.DeviceModel, S.AndroidVersion,
					Z.[Id] AS IdZone , Z.[Description] AS ZoneName, L.[Date] AS [CurrentLocationDate], S.[Deleted] as Deleted
	
		FROM		[dbo].[PersonOfInterest] S WITH (NOLOCK)
					LEFT OUTER JOIN [dbo].[Department] D WITH (NOLOCK) ON D.[Id] = S.[IdDepartment]
					LEFT OUTER JOIN [dbo].[PersonOfInterestType] ST WITH (NOLOCK) ON ST.[Code] = S.[Type]
					LEFT OUTER JOIN [dbo].[PersonOfInterestZone] PZ WITH (NOLOCK) ON S.[Id] = PZ.[IdPersonOfInterest]
					LEFT OUTER JOIN [dbo].[ZoneTranslated] Z WITH (NOLOCK) ON Z.[Id] = PZ.[IdZone] AND Z.[ApplyToAllPersonOfInterest] = 0
					LEFT OUTER JOIN [dbo].[CurrentLocation] L WITH (NOLOCK) ON S.[Id] = L.[IdPersonOfInterest]
	
		WHERE		((@IdDepartments IS NULL) OR (S.[IdDepartment] IS NULL) OR (dbo.CheckValueInList(S.[IdDepartment], @IdDepartments) = 1)) AND
					((@Types IS NULL) OR (dbo.CheckCharValueInList(S.[Type], @Types) = 1)) AND
					((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1)) AND
					((@Imeis IS NULL) OR (dbo.CheckVarcharInList(S.[MobileIMEI], @Imeis) = 1)) AND
					((@CellPhoneNumbers IS NULL) OR (dbo.CheckVarcharInList(S.[MobilePhoneNumber], @CellPhoneNumbers) = 1)) AND
					((@PersonOfInterestIds IS NULL) OR (dbo.CheckValueInList(S.[Id], @PersonOfInterestIds) = 1)) AND
					((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1)) AND
					((@ProfilesId IS NULL) OR (dbo.CheckVarcharInList(ST.[Code], @ProfilesId) = 1)) AND
					((@Status IS NULL) OR (S.[Status] = @Status)) AND
					(@Identifiers IS NULL OR dbo.CheckVarcharInList(S.Identifier, @Identifiers) = 1)
	
		ORDER BY	S.[Name], S.[LastName]

	END
END
