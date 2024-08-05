/****** Object:  Procedure [dbo].[GetPowerBIBoards]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:Jesús Portillo
-- Create date: 31/05/2021
-- Description: SP para obtener la información de los tableros de PowerBI disponibles
-- =============================================
CREATE PROCEDURE [dbo].[GetPowerBIBoards]
	@IdUser [sys].[int]
AS
BEGIN
	SELECT		PBB.[Id], PBB.[IdPowerBIConfiguration], PBB.[BoardId], PBB.[Name], PBB.[Description], PBB.[IdPermission], PBB.[IconUrl], PBB.[ShowOnReportsPage]
	FROM		[dbo].[PowerBIBoardTranslated] PBB WITH (NOLOCK)
				INNER JOIN [dbo].[Permission] P WITH (NOLOCK) ON P.[Id] = PBB.[IdPermission]
				INNER JOIN [dbo].[UserPermission] UP WITH (NOLOCK) ON UP.[IdPermission] = P.[Id]
	WHERE		P.[Enabled] = 1
				AND UP.[IdUser] = @IdUser
	ORDER BY	P.[Order]
END
