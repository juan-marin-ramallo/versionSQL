/****** Object:  Procedure [dbo].[GetUsersWithOnlyCompany]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		FS
-- Create date: 19-07-31
-- Description:	Obtener los usuarios que solo tiene asignada una compañía
-- =============================================
CREATE PROCEDURE [dbo].[GetUsersWithOnlyCompany]
	@IdCompany [sys].[int]
AS
BEGIN
	SET NOCOUNT ON;

    SELECT u.[Id], u.[Name], u.[LastName], u.[Email], u.[UserName]
	FROM dbo.[User]	u
		INNER JOIN dbo.[UserCompany] UC ON u.[Id] = uc.[IdUser]
		INNER JOIN dbo.[UserCompany] UC2 ON u.[Id] = uc2.[IdUser]
	WHERE U.SuperAdmin = 0 AND u.[Status] = 'H' AND uc.[IdCompany] = @IdCompany
	GROUP BY u.[Id], u.[Name], u.[LastName], u.[Email], u.[UserName]
	HAVING COUNT(uc2.IdUser) = 1

END
