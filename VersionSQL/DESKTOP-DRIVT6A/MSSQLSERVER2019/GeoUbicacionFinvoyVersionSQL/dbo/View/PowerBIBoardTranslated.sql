/****** Object:  View [dbo].[PowerBIBoardTranslated]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[PowerBIBoardTranslated]
AS
SELECT PBB.Id, PBB.IdPowerBIConfiguration, PBB.BoardId, PBBT.Name, PBBT.Description, PBB.IdPermission, PBB.IconUrl, PBB.ShowOnReportsPage
FROM dbo.SelectedLanguage AS L WITH (NOLOCK)
LEFT OUTER JOIN dbo.PowerBIBoardTranslation AS PBBT WITH (NOLOCK) ON PBBT.IdLanguage = L.Id
RIGHT OUTER JOIN dbo.PowerBIBoard AS PBB WITH (NOLOCK) ON PBB.Id = PBBT.IdPowerBIBoard
