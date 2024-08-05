/****** Object:  Procedure [dbo].[GetPowerpointMarkupsPhotoReport]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetPowerpointMarkupsPhotoReport]
AS
BEGIN
	
	SELECT	P.[Id] AS MarkupPhotoReportId, P.[Name]  AS MarkupPhotoReportName,
			M.[Id] AS MarkupId, M.[Name] AS MarkupName, PE.[PageIndex],
			PE.[IdPowerPointMarkupElement], PE.[IdPhotoReportExportAttribute] AS [ElementId], 
			E.[Name] AS [ElementName], E.[X], E.[Y], E.[Cx], E.[Cy]
	
	FROM	[dbo].[PowerpointMarkupPhotoReport] P
			INNER JOIN [dbo].[PowerpointMarkupPhotoReportElement] PE on P.[Id] = PE.[IdPowerpointMarkupPhotoReport]
			INNER JOIN [dbo].[PowerpointMarkupElement] E ON PE.[IdPowerpointMarkupElement] = E.[Id]
			INNER JOIN [dbo].[PowerpointMarkupTranslated] M ON E.[IdPowerpointMarkup] = M.[Id]
	
	ORDER BY P.Id ASC, PE.PageIndex ASC, PE.Id ASC

END
