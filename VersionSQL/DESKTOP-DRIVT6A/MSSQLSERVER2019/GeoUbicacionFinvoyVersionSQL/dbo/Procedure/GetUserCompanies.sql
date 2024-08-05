/****** Object:  Procedure [dbo].[GetUserCompanies]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 23/07/2019
-- Description:	SP para obtener las compañias de un usuario dado
-- =============================================
CREATE PROCEDURE [dbo].[GetUserCompanies]
(
	@IdUser [sys].[int]
)
AS
BEGIN
	SELECT		C.[Id], C.[Name]
	FROM		[dbo].[Company] C
				INNER JOIN [dbo].[UserCompany] UC ON UC.[IdCompany] = C.[Id]
	WHERE		UC.[IdUser] = @IdUser AND C.[Deleted]  = 0
END
