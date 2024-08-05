/****** Object:  Procedure [dbo].[GetPowerpointMarkupsProductReportById]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 08/06/2017
-- Description:	SP para obtener los diseños de powerpoints
-- =============================================
CREATE PROCEDURE [dbo].[GetPowerpointMarkupsProductReportById]	
	 @IdMarkup [sys].[int]
AS
BEGIN

	SELECT f.[Id] as MarkupProductReportId, f.[Name]  as MarkupProductReportName, F.[ShowTitles]
			, m.[Id] as MarkupId, m.[Name] as MarkupName, fe.PageIndex
			, fe.IdPowerPointMarkupElement, fe.[IdProductReportAttribute] as [ElementId], e.Name as [ElementName]
			, e.X, e.Y, e.Cx, E.Cy
	FROM [dbo].[PowerpointMarkupProductReport] f WITH (NOLOCK)
			INNER JOIN [dbo].[PowerpointMarkupProductReportElement] fe WITH (NOLOCK) on f.Id = fe.IdPowerpointMarkupProductReport
			INNER JOIN [dbo].[PowerpointMarkupElement] e WITH (NOLOCK) ON fe.IdPowerpointMarkupElement = e.id
			INNER JOIN [dbo].[PowerpointMarkupTranslated] m WITH (NOLOCK) ON e.IdPowerpointMarkup = m.id
	WHERE f.Id = @IdMarkup
	ORDER BY f.Id asc, fe.PageIndex asc, fe.Id asc
	
END
