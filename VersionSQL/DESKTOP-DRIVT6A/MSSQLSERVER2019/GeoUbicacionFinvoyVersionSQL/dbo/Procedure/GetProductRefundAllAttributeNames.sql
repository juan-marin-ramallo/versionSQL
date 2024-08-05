/****** Object:  Procedure [dbo].[GetProductRefundAllAttributeNames]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetProductRefundAllAttributeNames]
AS
BEGIN

	SELECT A.[Id], A.[Name], T.[Id] AS IdType

	FROM [dbo].[ProductRefundAttribute] A WITH (NOLOCK)
	INNER JOIN	[dbo].[ProductReportAttributeTypeTranslated] T WITH (NOLOCK) ON T.[Id] = A.[IdType]

	WHERE A.[FullDeleted] = 0 
	
	ORDER BY	A.[Order] ASC

END
