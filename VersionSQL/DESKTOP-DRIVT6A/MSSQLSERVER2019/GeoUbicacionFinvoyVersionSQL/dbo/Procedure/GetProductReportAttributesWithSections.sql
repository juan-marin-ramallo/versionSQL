/****** Object:  Procedure [dbo].[GetProductReportAttributesWithSections]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetProductReportAttributesWithSections]
	@IncludeDeleted bit = 0
AS
BEGIN
	
	SELECT		S.Id as IdSection, S.[Name] as SectionName, S.[Order] AS SectionOrder,
				A.[Id], A.[Name], A.[DefaultValue], A.[Order], A.[Required],
				A.[Deleted], A.[FullDeleted], A.[IsStar],
				T.[Id] AS IdType, T.[Description]
	
	FROM		dbo.ProductReportSection S WITH (NOLOCK)
				INNER JOIN dbo.ProductReportAttribute A WITH (NOLOCK) ON S.Id = A.IdProductReportSection AND (@IncludeDeleted = 1 OR A.[FullDeleted] = 0)
				INNER JOIN	dbo.ProductReportAttributeTypeTranslated T WITH (NOLOCK) ON T.[Id] = A.[IdType]
	
	WHERE		(@IncludeDeleted = 1 OR S.[FullDeleted] = 0)
	ORDER BY	S.[Order] ASC, S.[Id] asc, A.[Order] ASC, A.[Id] asc

END
