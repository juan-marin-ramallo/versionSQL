/****** Object:  Procedure [dbo].[GetUsers]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 05/11/2012
-- Description:	SP para obtener los usuarios
-- Change: Matias Corso	- 27/10/2016 - devuelvo valor de superadmin
-- =============================================
CREATE PROCEDURE [dbo].[GetUsers]
(
	@IdUser [sys].[int] = NULL
	,@UsersId [sys].[varchar](1000) = NULL
)
AS
BEGIN
	SELECT		[Id], [Name], [LastName], [Email], [UserName], [FirstTimeLogin], 
				[Type], [Status], [SuperAdmin], [IdPersonOfInterest], [AppUserStatus], [CreatedAtKioskMode],
				[MicrosoftAccessToken], [MicrosoftAccessToken], [MicrosoftAccessTokenExpiration], [MicrosoftRefreshToken], [MicrosoftCalendarId], [LastLoginDate]
	FROM		[dbo].[User] WITH (NOLOCK)
				LEFT OUTER JOIN [dbo].[UserDepartment] UD WITH (NOLOCK) ON UD.[IdUser] = [Id]
	WHERE		([SuperAdmin] = 0 OR ([Id] = @IdUser AND [SuperAdmin] = 1))
				AND ((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(UD.[IdDepartment], @IdUser) = 1))
				AND (@UsersId IS NULL OR dbo.CheckValueInList([Id], @UsersId) > 0)
	GROUP BY	[Id], [Name], [LastName], [Email], [UserName], [FirstTimeLogin], 
				[Type], [Status], [SuperAdmin], [IdPersonOfInterest], [AppUserStatus], [CreatedAtKioskMode],
				[MicrosoftAccessToken], [MicrosoftAccessToken], [MicrosoftAccessTokenExpiration], [MicrosoftRefreshToken], [MicrosoftCalendarId],[LastLoginDate]
	ORDER BY	[Name], [LastName]
END
