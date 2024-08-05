/****** Object:  Procedure [dbo].[GetPossibleCustomAttributes]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetPossibleCustomAttributes]
AS
BEGIN
	
	SELECT	CAT.[Id], CAT.[Name], CAT.[DefaultValue], CAT.IdValueType	
	FROM	[dbo].[CustomAttributeTranslated] CAT	
	WHERE	CAT.Deleted = 0
	ORDER BY CAT.[Id]
END
