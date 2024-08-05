/****** Object:  Procedure [dbo].[GetMobileScripts]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		FS
-- Create date: 26/03/20
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[GetMobileScripts]
AS
BEGIN
	SELECT Id, Name
	FROM dbo.MobileScriptTranslated
	ORDER BY Id ASC
END
