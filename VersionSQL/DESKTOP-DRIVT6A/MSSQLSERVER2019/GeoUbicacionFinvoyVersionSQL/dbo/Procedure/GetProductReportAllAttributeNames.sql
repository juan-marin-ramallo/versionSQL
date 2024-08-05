/****** Object:  Procedure [dbo].[GetProductReportAllAttributeNames]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetProductReportAllAttributeNames]
AS
BEGIN

	SELECT A.[Id], A.[Name], T.[Id] AS TypeId

	FROM [dbo].[ProductReportAttribute] A WITH (NOLOCK)
	INNER JOIN	[dbo].[ProductReportAttributeTypeTranslated] T WITH (NOLOCK) ON T.[Id] = A.[IdType]
	LEFT OUTER JOIN	[dbo].[ProductReportSection] S WITH (NOLOCK) ON S.[Id] = A.[IdProductReportSection]

	WHERE A.[FullDeleted] = 0 
	  AND (S.[Id] IS NULL OR S.[FullDeleted] = 0)
	
	ORDER BY	S.[Id] ASC, A.[Order] ASC

END
