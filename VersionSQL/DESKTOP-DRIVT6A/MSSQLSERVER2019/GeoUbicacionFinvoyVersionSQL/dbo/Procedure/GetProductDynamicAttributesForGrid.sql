/****** Object:  Procedure [dbo].[GetProductDynamicAttributesForGrid]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: <Create Date,,>
-- Description:	Devuelve atributos din[amicos de productos
-- =============================================
CREATE PROCEDURE [dbo].[GetProductDynamicAttributesForGrid]
AS
BEGIN
	SELECT	c.[Id], c.[Name], c.[Description], c.[ColumnName], 
			c.[Disabled],c.[Deleted], c.[EditedDate], c.[IdValueType], t.[Description] as ValueTypeDescription,
			u.[Id] AS IdUser, u.[Name] AS UserName, u.[LastName] AS UserLastName
	FROM	[ProductDynamicAttribute] c WITH (NOLOCK)
			JOIN [CustomAttributeValueTypeTranslated] t WITH (NOLOCK) ON t.[Code] = c.[IdValueType]
			JOIN [User] u ON u.[Id] = c.[IdUser]
	WHERE	c.[Deleted] = 0
	order by c.[Disabled] 
END
