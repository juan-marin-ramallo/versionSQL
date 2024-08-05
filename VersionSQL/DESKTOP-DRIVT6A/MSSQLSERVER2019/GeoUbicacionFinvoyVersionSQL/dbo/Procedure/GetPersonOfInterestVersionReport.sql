/****** Object:  Procedure [dbo].[GetPersonOfInterestVersionReport]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 22/09/2016
-- Description:	SP para obtener un reporte de VERSIONES
-- =============================================
create PROCEDURE [dbo].[GetPersonOfInterestVersionReport]
(
	 @IdPersonsOfInterest [sys].[varchar](max) = NULL
	,@IdUser [sys].[int] = NULL
)
AS
BEGIN

	SELECT		PV.[Version], S.[Id] AS IdPersonOfInterest, S.[Name] AS PersonOfInterestName, 
				S.[LastName] AS PersonOfInterestLastName, PV.[Date]
	
	FROM		dbo.[PersonOfInterestMobileVersion] PV
				INNER JOIN [dbo].[PersonOfInterest] S ON S.[Id]= PV.[IdPersonOfInterest]
	
	WHERE		((@IdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(S.[Id], @IdPersonsOfInterest) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1))
				AND S.[Deleted] = 0
	
	ORDER BY	PV.[Date] DESC
END
