/****** Object:  Procedure [dbo].[IsPersonsLicenseMaxedOut]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[IsPersonsLicenseMaxedOut]
AS
BEGIN
	
	DECLARE @MaxPersonsOfInterestCount int = (SELECT PC.[Value] FROM [dbo].[PackageConfigurationTranslated] PC WITH(NOLOCK) WHERE PC.Id = 1)
	DECLARE @PersonsOfInterestCount int = (SELECT Count(1) FROM	[dbo].[AvailablePersonOfInterest] A
									WHERE	NOT EXISTS (SELECT 1 FROM [dbo].[User] WITH(NOLOCK) WHERE [SuperAdmin] = 1 AND [IdPersonOfInterest] IS NOT NULL)
											OR [Id] NOT IN (SELECT [IdPersonOfInterest] FROM [dbo].[User] WITH(NOLOCK) WHERE [SuperAdmin] = 1))

	SELECT (CASE WHEN @PersonsOfInterestCount >= @MaxPersonsOfInterestCount THEN 1 ELSE 0 END) AS IsMaxedOut,
		   (SELECT CONCAT(PC.Value, ' ', PC.ErrorMessage)
			FROM [dbo].[PackageConfigurationTranslated] PC WITH(NOLOCK) WHERE PC.Id = 1) AS MaxedOutMessage

END
