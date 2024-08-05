/****** Object:  Procedure [dbo].[GetProductReportStarAttributes]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetProductReportStarAttributes]
AS
BEGIN
	
	SELECT A.[Id], A.[Name], A.[DefaultValue], A.[Order], A.[Required],
		   T.[Id] AS IdType, T.[Description],
		   S.[Name] AS SectionName

	FROM ProductReportAttribute A WITH (NOLOCK)
	JOIN ProductReportAttributeTypeTranslated T WITH (NOLOCK) ON T.[Id] = A.[IdType]
	JOIN ProductReportSection S WITH (NOLOCK) ON S.[Id] = A.[IdProductReportSection]

	WHERE A.[IsStar] = 1 
	  AND A.[Deleted] = 0
	  AND A.[FullDeleted] = 0
	  AND S.[Deleted] = 0
	  AND S.[FullDeleted] = 0

END
