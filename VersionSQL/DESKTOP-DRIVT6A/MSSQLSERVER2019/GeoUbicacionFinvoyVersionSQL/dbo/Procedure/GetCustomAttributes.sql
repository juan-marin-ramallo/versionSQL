/****** Object:  Procedure [dbo].[GetCustomAttributes]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:<Author,,Name>
-- Create date: <Create Date,,>
-- Description: <Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetCustomAttributes]
 @IncludeFixedAttributes [sys].[bit] = 0
AS
BEGIN
	SELECT CAT.Id
		, CAT.Name
		, CAT.CreatedDate
		, CAT.DefaultValue
		, CAT.IdValueType
		, t.Description
		, u.Id AS IdUser
		, u.Name AS UserName
		, u.LastName AS UserLastName
		, CAT.IsObligatory
		, CAT.IsVisible
		, CAT.CanDelete
		, CAT.CanEditObligatory
		, o.[Id] as IdOption
		, o.[Text] as OptionText
		, o.[IsDefault] as OptionIsDefault
	FROM CustomAttributeTranslated CAT WITH (NOLOCK)
		JOIN CustomAttributeValueTypeTranslated t WITH (NOLOCK) ON t.Code = CAT.IdValueType
		JOIN [User] u ON u.Id = CAT.IdUser
		LEFT OUTER JOIN [CustomAttributeOption] o WITH(NOLOCK) ON CAT.Id = o.IdCustomAttribute AND o.Deleted = 0
	WHERE CAT.Deleted = 0 AND (@IncludeFixedAttributes = 1 OR CAT.CanDelete = 1)
	ORDER BY CAT.CanDelete, CAT.Id asc, o.IsDefault desc, o.[Text] asc
END
