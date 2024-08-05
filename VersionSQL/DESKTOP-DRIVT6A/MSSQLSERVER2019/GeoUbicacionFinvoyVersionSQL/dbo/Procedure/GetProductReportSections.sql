/****** Object:  Procedure [dbo].[GetProductReportSections]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetProductReportSections]
	@SectionIds varchar(MAX) = NULL
AS
BEGIN
	
	SELECT	P.[Id], P.[Name], P.[Description], P.[Order], P.[Deleted], P.[FullDeleted] 
	FROM	dbo.[ProductReportSection] P WITH (NOLOCK)
	WHERE	P.[Deleted] = 0
			AND ((@SectionIds IS NULL) OR (dbo.[CheckValueInList](P.[Id], @SectionIds) = 1))
	ORDER BY [Deleted], [Order] ASC

END
