/****** Object:  View [dbo].[CustomAttributeTranslated]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE   VIEW [dbo].[CustomAttributeTranslated]
AS
SELECT        CA.Id, ISNULL(CAT.Name, CA.Name) AS Name, CA.IdValueType, CA.DefaultValue, CA.CreatedDate, CA.IdUser, CA.Deleted, CA.IsObligatory, CA.IsVisible, CA.CanDelete, CA.CanEditObligatory
FROM            dbo.SelectedLanguage AS L WITH (NOLOCK) LEFT OUTER JOIN
                         dbo.CustomAttributeTranslation AS CAT WITH (NOLOCK) ON CAT.IdLanguage = L.Id RIGHT OUTER JOIN
                         dbo.CustomAttribute AS CA WITH (NOLOCK) ON CA.Id = CAT.IdCustomAttribute
