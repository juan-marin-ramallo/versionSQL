/****** Object:  Procedure [dbo].[GetPersonsForFilter]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetPersonsForFilter]
	@IncludeDeleted bit = 0,
	@IdUser int = NULL
AS
BEGIN

	SELECT P.[Id], P.[Name], P.[LastName], P.[Identifier], P.[Deleted], P.[IdDepartment], P.[Status], PZ.[IdZone]
	FROM PersonOfInterest P WITH (NOLOCK)
		LEFT JOIN PersonOfInterestZone PZ WITH (NOLOCK) ON PZ.[IdPersonOfInterest] = P.[Id]
	WHERE ((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1)) 
	  AND ((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(P.[Id], @IdUser) = 1))
	ORDER BY P.[Deleted], P.[Identifier]

END
