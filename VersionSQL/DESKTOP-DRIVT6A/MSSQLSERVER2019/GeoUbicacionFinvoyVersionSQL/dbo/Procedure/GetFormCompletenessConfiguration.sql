/****** Object:  Procedure [dbo].[GetFormCompletenessConfiguration]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetFormCompletenessConfiguration]
AS
BEGIN
	
	DECLARE @MaxBadPercentage int = (SELECT [Value] FROM [ConfigurationTranslated] WITH (NOLOCK) WHERE [Name] = 'FormCompletenessFaceValueBad')
	DECLARE @MaxGoodPercentage int = (SELECT [Value] FROM [ConfigurationTranslated] WITH (NOLOCK) WHERE [Name] = 'FormCompletenessFaceValueGood')

	SELECT @MaxBadPercentage AS MaxBadPercentage, @MaxGoodPercentage AS MaxGoodPercentage
END
