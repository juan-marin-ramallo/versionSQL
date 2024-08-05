/****** Object:  Procedure [dbo].[GetProductReportAttributes]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetProductReportAttributes]
	@IdSection int
AS
BEGIN
	
	SELECT		A.[Id], A.[Name], A.[DefaultValue], A.[Order], A.[Required],
				A.[Deleted], A.[IsStar], A.[IdProductReportSection] AS IdSection,
				T.[Id] AS IdType, T.[Description]
	
	FROM		dbo.ProductReportAttribute A WITH (NOLOCK)
	INNER JOIN	dbo.ProductReportAttributeTypeTranslated T WITH (NOLOCK) ON T.[Id] = A.[IdType]
	
	WHERE		A.[IdProductReportSection] = @IdSection AND A.[FullDeleted] = 0
	ORDER BY	A.[Order] ASC

END
