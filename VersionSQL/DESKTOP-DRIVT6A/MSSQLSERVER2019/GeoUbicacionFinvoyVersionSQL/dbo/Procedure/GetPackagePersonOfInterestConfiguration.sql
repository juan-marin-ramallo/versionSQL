/****** Object:  Procedure [dbo].[GetPackagePersonOfInterestConfiguration]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- =============================================
CREATE PROCEDURE [dbo].[GetPackagePersonOfInterestConfiguration]
AS
BEGIN

	SELECT t1.[MaxPIQuantity], t2.[AvailablePIQuantity]
	FROM 
		(SELECT	PC.[Value] AS MaxPIQuantity
		FROM	[dbo].[PackageConfigurationTranslated] PC WITH (NOLOCK)
		WHERE	PC.[Name] like '%Max Stockers%') t1,

		(SELECT	COUNT(1) AS AvailablePIQuantity
		FROM	[dbo].[AvailablePersonOfInterest] A
		WHERE	NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [SuperAdmin] = 1 AND [IdPersonOfInterest] IS NOT NULL)
					OR [Id] NOT IN (SELECT [IdPersonOfInterest] FROM [dbo].[User] WHERE [SuperAdmin] = 1)) t2
	
END
