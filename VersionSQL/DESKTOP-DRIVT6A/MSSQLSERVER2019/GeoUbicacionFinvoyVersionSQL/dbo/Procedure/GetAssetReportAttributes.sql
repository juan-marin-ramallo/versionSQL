/****** Object:  Procedure [dbo].[GetAssetReportAttributes]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetAssetReportAttributes]
AS
BEGIN
	
	SELECT A.[Id], A.[Name], A.[CreatedDate], A.[DefaultValue], 
		   A.[IdType], A.[Enabled], A.[Order], A.[Required], A.[DefaultAttribute],
		   T.[Description],
		   A.[IdVisibilityType], AVT.[Description] AS VisibilityDescription,
		   A.[CanEditRequired], A.[CanEditVisibility],
		   U.[Name] AS UserName, U.[LastName] AS UserLastName,
		   O.[Id] AS IdOption, O.[Text], O.[IsDefault]
	FROM [AssetReportAttribute] A WITH (NOLOCK)
		JOIN [AssetReportAttributeTypeTranslated] T WITH (NOLOCK) ON T.[Id] = A.[IdType]
		LEFT OUTER JOIN [AssetReportAttributeVisibilityTypeTranslated] AVT WITH (NOLOCK) ON AVT.[Id] = A.[IdVisibilityType]
		LEFT OUTER JOIN [AssetReportAttributeOption] O WITH (NOLOCK) 
			ON O.[IdAssetReportAttribute] = A.[Id] AND O.[Deleted] = 0
		JOIN [User] U WITH (NOLOCK) ON U.[Id] = A.[IdUser]
	WHERE A.[Deleted] = 0
	ORDER BY A.[Order] ASC

END
