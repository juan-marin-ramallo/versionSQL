/****** Object:  View [dbo].[AssetReportAttributeVisibilityTypeTranslated]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[AssetReportAttributeVisibilityTypeTranslated]
AS
SELECT        ARAVT.Id, ARAVTT.Description
FROM            dbo.SelectedLanguage AS L WITH (NOLOCK) LEFT OUTER JOIN
                         dbo.AssetReportAttributeVisibilityTypeTranslation AS ARAVTT WITH (NOLOCK) ON ARAVTT.IdLanguage = L.Id RIGHT OUTER JOIN
                         dbo.AssetReportAttributeVisibilityType AS ARAVT WITH (NOLOCK) ON ARAVT.Id = ARAVTT.IdAssetReportAttributeVisibilityType
