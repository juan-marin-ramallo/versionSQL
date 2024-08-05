/****** Object:  Procedure [dbo].[GetPhotoReportExportAttributes]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetPhotoReportExportAttributes]
AS
BEGIN
	
	SELECT A.[Id], A.[Name]
	FROM [dbo].[PhotoReportExportAttributeTranslated] A WITH (NOLOCK)

END
