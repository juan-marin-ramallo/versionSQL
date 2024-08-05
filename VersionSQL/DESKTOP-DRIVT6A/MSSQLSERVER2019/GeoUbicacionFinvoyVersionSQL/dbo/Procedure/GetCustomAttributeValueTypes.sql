/****** Object:  Procedure [dbo].[GetCustomAttributeValueTypes]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetCustomAttributeValueTypes]
AS
BEGIN
	SELECT [Code], [Description]
	FROM [CustomAttributeValueTypeTranslated] WITH (NOLOCK)

END
