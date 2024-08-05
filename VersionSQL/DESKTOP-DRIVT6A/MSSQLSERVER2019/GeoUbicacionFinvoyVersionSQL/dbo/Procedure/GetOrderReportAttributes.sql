/****** Object:  Procedure [dbo].[GetOrderReportAttributes]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: <Create Date,,>
-- Description:	Devuelve los atributos configurados para los pedidos
-- =============================================
CREATE PROCEDURE [dbo].[GetOrderReportAttributes]
AS
BEGIN
	
	SELECT A.[Id], A.[Name], A.[CreatedDate], A.[DefaultValue], A.[IdType], A.[Enabled], A.[Order], A.[Required],
		   T.[Description], U.[Name] AS UserName, U.[LastName] AS UserLastName, O.[Id] AS IdOption, O.[Text], O.[IsDefault]
	
	FROM [dbo].[OrderReportAttribute] A WITH (NOLOCK)
		JOIN [dbo].[ProductReportAttributeTypeTranslated] T WITH (NOLOCK) ON T.[Id] = A.[IdType]
		LEFT OUTER JOIN [dbo].[OrderReportAttributeOption] O WITH (NOLOCK) ON O.[IdOrderReportAttribute] = A.[Id] AND O.[Deleted] = 0
		JOIN [dbo].[User] U WITH (NOLOCK) ON U.[Id] = A.[IdUser]
	
	WHERE A.[Deleted] = 0
	ORDER BY A.[Order] ASC

END
