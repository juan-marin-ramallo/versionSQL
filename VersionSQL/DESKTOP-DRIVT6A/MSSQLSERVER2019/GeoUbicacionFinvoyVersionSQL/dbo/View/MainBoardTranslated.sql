/****** Object:  View [dbo].[MainBoardTranslated]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[MainBoardTranslated]
AS
SELECT MB.Id, MBT.[Name], MBT.[Description], MB.[Order], MB.IdPermission, MB.IconUrl, MB.ActionUrl
FROM dbo.SelectedLanguage AS L WITH (NOLOCK)
LEFT OUTER JOIN dbo.MainBoardTranslation AS MBT WITH (NOLOCK) ON MBT.IdLanguage = L.Id
RIGHT OUTER JOIN dbo.MainBoard AS MB WITH (NOLOCK) ON MB.Id = MBT.IdMainBoard
