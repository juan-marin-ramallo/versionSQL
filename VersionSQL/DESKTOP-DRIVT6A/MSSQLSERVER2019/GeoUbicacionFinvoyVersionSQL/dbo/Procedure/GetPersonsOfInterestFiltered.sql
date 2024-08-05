/****** Object:  Procedure [dbo].[GetPersonsOfInterestFiltered]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 25/10/2012
-- Description:	SP para obtener los repositores filtrados por ciertos parámetros
-- =============================================
CREATE PROCEDURE [dbo].[GetPersonsOfInterestFiltered]
(
	 @IdDepartments [sys].[varchar](max) = NULL
	,@Types [sys].[varchar](max) = NULL
	,@Imeis [sys].[varchar](max) = NULL
	,@CellPhoneNumbers [sys].[varchar](max) = NULL
	,@PersonOfInterestIds [sys].[varchar](max) = NULL
	,@ProfilesId [sys].[varchar](max) = NULL
	,@Status [sys].[varchar](10) = NULL
	,@IdUser [sys].[int] = NULL
)
AS
BEGIN
	SELECT		S.[Id], S.[Name], S.[LastName],S.[Identifier], S.[MobilePhoneNumber], S.[MobileIMEI], S.[Status], S.[Type], S.[Email],
				 ST.[Description] AS TypeDescription, S.[IdDepartment], D.[Name] AS DepartmentName, L.[Date] AS [CurrentLocationDate]
	FROM		[dbo].[AvailablePersonOfInterest] S WITH (NOLOCK)
				LEFT OUTER JOIN [dbo].[Department] D WITH (NOLOCK) ON D.[Id] = S.[IdDepartment]
				LEFT OUTER JOIN [dbo].[PersonOfInterestType] ST WITH (NOLOCK) ON ST.[Code] = S.[Type]
				LEFT OUTER JOIN [dbo].[CurrentLocation] L WITH (NOLOCK) ON S.[Id] = L.[IdPersonOfInterest]
	WHERE		((@IdDepartments IS NULL) OR (S.[IdDepartment] IS NULL) OR (dbo.CheckValueInList(S.[IdDepartment], @IdDepartments) = 1)) AND
				((@Types IS NULL) OR (dbo.CheckCharValueInList(S.[Type], @Types) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1)) AND
				((@Imeis IS NULL) OR (dbo.CheckVarcharInList(S.[MobileIMEI], @Imeis) = 1)) AND
				((@CellPhoneNumbers IS NULL) OR (dbo.CheckVarcharInList(S.[MobilePhoneNumber], @CellPhoneNumbers) = 1)) AND
				((@PersonOfInterestIds IS NULL) OR (dbo.CheckValueInList(S.[Id], @PersonOfInterestIds) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1)) AND
				((@ProfilesId IS NULL) OR (dbo.CheckVarcharInList(ST.[Code], @ProfilesId) = 1)) AND
				((@Status IS NULL) OR (S.[Status] = @Status))
	ORDER BY	D.[Name], ST.[Description], S.[Name], S.[LastName]
END
