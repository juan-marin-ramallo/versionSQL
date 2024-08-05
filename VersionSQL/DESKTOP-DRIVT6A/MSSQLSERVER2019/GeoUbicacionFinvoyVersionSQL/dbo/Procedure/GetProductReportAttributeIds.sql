/****** Object:  Procedure [dbo].[GetProductReportAttributeIds]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetProductReportAttributeIds]
	@IdSection int
AS
BEGIN
	
	SELECT A.[Id]
	FROM [dbo].[ProductReportAttribute] A
	WHERE A.[IdProductReportSection] = @IdSection
	  AND A.[Deleted] = 0
	ORDER BY A.[Order] ASC

END
