/****** Object:  Procedure [dbo].[GetProductRefundAttributes]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 16/07/2018
-- Description:	dEVUELVE LOS ATRIBUTOS DINAMICOS DEL CONTROL DE DEVOLUCION DE SKU
-- =============================================
CREATE PROCEDURE [dbo].[GetProductRefundAttributes]
	
AS
BEGIN
	
	SELECT		A.[Id], A.[Name], A.[DefaultValue], A.[Order], A.[Required],
				A.[Deleted], T.[Id] AS IdType, T.[Description],
				AO.[Id] AS OptionId, AO.[Text] AS OptionText, AO.[IsDefault] AS OptionIsDefault
	
	FROM		[dbo].[ProductRefundAttribute] A WITH (NOLOCK)
	INNER JOIN	[dbo].[ProductReportAttributeTypeTranslated] T WITH (NOLOCK) ON T.[Id] = A.[IdType]
	LEFT OUTER JOIN [dbo].[ProductRefundAttributeOption] AO WITH (NOLOCK) ON AO.IdProductRefundAttribute = A.[Id]
	
	WHERE		A.[Deleted] = 0 
				AND A.[FullDeleted] = 0
				AND (AO.[Id] IS NULL OR AO.[Deleted] = 0)

	ORDER BY	A.[Order] ASC

END
