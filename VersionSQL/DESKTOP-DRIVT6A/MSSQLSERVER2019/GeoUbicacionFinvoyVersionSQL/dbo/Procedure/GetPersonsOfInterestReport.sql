/****** Object:  Procedure [dbo].[GetPersonsOfInterestReport]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Leonardo Repetto
-- Create date: 13/03/2014
-- Description:	SP para obtener las Personas de Interes
-- =============================================
CREATE PROCEDURE [dbo].[GetPersonsOfInterestReport]
(
	@Id [sys].[int] = NULL
)
AS
BEGIN
	SELECT	APOI.[Id], APOI.[Name], APOI.[LastName], APOI.[Identifier], APOI.[MobilePhoneNumber], APOI.[MobileIMEI], APOI.[Status], APOI.[Type], APOI.[Email],
			APOI.[IdDepartment], D.[Name] AS DepartmentName
	FROM	[dbo].[PersonOfInterest] APOI
			LEFT OUTER JOIN [dbo].[Department] D ON D.[Id] = APOI.[IdDepartment]
	WHERE	((@Id IS NULL) OR (APOI.[Id] = @Id))
END
