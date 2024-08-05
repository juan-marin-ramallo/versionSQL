/****** Object:  Procedure [dbo].[GetPersonsOfInterestPending]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 08/11/2013
-- Description:	SP para obtener las Personas de Interes Pendientes
-- =============================================
CREATE PROCEDURE [dbo].[GetPersonsOfInterestPending]
(
	 @Imeis [sys].[varchar](max) = NULL
	,@CellPhoneNumbers [sys].[varchar](max) = NULL
	,@PersonOfInterestIds [sys].[varchar](max) = NULL
	,@ProfilesId [sys].[varchar](max) = NULL
	,@IdUser [sys].[int] = NULL
)
AS
BEGIN
	SELECT	P.[Id], P.[Name], P.[LastName], P.[Identifier], P.[MobilePhoneNumber], P.[MobileIMEI], P.[Email],
			P.[Status], P.[Type], P.[IdDepartment]

	FROM	[dbo].[PersonOfInterest] P

	WHERE	[Deleted] = 0 AND [Status] = 'D' AND
			((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1)) AND
			((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(P.[Id], @IdUser) = 1)) AND
			((@Imeis IS NULL) OR (dbo.CheckVarcharInList(P.[MobileIMEI], @Imeis) = 1)) AND
			((@CellPhoneNumbers IS NULL) OR (dbo.CheckVarcharInList(P.[MobilePhoneNumber], @CellPhoneNumbers) = 1)) AND
			((@ProfilesId IS NULL) OR (dbo.CheckVarcharInList(P.[Type], @ProfilesId) = 1)) AND
			((@PersonOfInterestIds IS NULL) OR (dbo.CheckValueInList(P.[Id], @PersonOfInterestIds) = 1))			
END
