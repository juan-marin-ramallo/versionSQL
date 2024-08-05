/****** Object:  Procedure [dbo].[GetPersonsOfInterestFilteredForTemplate]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 07/09/2020
-- Description:	SP para obtener los repositores filtrados por ciertos parámetros PARA TEMPLATE EXCEL
-- =============================================
CREATE PROCEDURE [dbo].[GetPersonsOfInterestFilteredForTemplate]
(
	 @Imeis [sys].[varchar](max) = NULL
	,@CellPhoneNumbers [sys].[varchar](max) = NULL
	,@PersonOfInterestIds [sys].[varchar](max) = NULL
	,@ProfilesId [sys].[varchar](max) = NULL
	,@IdUser [sys].[int] = NULL
)
AS
BEGIN
	
	SELECT		S.[Id], S.[Name], S.[LastName], S.[Identifier], S.[MobilePhoneNumber], S.[MobileIMEI], S.[Type], S.[Email],
				S.[IdDepartment], S.[Status]
	
	FROM		[dbo].[AvailablePersonOfInterest] S
	
	WHERE		((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1)) AND
				((@Imeis IS NULL) OR (dbo.CheckVarcharInList(S.[MobileIMEI], @Imeis) = 1)) AND
				((@CellPhoneNumbers IS NULL) OR (dbo.CheckVarcharInList(S.[MobilePhoneNumber], @CellPhoneNumbers) = 1)) AND
				((@PersonOfInterestIds IS NULL) OR (dbo.CheckValueInList(S.[Id], @PersonOfInterestIds) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1)) AND
				((@ProfilesId IS NULL) OR (dbo.CheckCharValueInList(S.[Type], @ProfilesId) = 1))
	
	ORDER BY	S.[Name], S.[LastName]
END
