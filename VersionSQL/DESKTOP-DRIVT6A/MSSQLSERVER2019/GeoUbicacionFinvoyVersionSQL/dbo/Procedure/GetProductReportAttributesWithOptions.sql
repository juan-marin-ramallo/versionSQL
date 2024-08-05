/****** Object:  Procedure [dbo].[GetProductReportAttributesWithOptions]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetProductReportAttributesWithOptions]
	@IdSection int
AS
BEGIN
	
	SELECT A.[Id], A.[Name], A.[DefaultValue], A.[Order], A.[Required], A.[IsStar],
		   T.[Id] AS IdType, T.[Description],
		   AO.[Id] AS OptionId, AO.[Text] AS OptionText, AO.[IsDefault] AS OptionIsDefault

	FROM		[dbo].[ProductReportAttribute] A WITH (NOLOCK)
	INNER JOIN	[dbo].[ProductReportAttributeTypeTranslated] T WITH (NOLOCK) ON T.[Id] = A.[IdType] 
	LEFT OUTER JOIN [dbo].[ProductReportAttributeOption] AO WITH (NOLOCK) ON AO.IdProductReportAttribute = A.[Id]

	WHERE A.[IdProductReportSection] = @IdSection 
	  AND A.[Deleted] = 0 
	  AND A.[FullDeleted] = 0
	  AND (AO.[Id] IS NULL OR AO.[Deleted] = 0)

	ORDER BY A.[Order] ASC

END
