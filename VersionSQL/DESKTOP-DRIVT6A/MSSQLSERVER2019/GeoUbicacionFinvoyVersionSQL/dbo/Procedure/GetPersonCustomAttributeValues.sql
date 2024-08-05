/****** Object:  Procedure [dbo].[GetPersonCustomAttributeValues]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author: Cristian Barbarini
-- Create date: 10/10/2023
-- Description: SP para obtener los valores de los atributos de las personas
-- =============================================
CREATE PROCEDURE [dbo].[GetPersonCustomAttributeValues]
AS
BEGIN
	WITH PersonCustomAttributesJoined
	AS
	(
	SELECT peoi.[Id] AS [IdPersonOfInterest], pca.[Id] AS [IdPersonCustomAttribute]
	FROM [dbo].[PersonOfInterest] peoi (NOLOCK)
	CROSS JOIN [dbo].[PersonCustomAttribute] pca (NOLOCK)
	WHERE peoi.[Deleted] = 0 AND pca.[Deleted] = 0
	)

	SELECT pcaj.[IdPersonOfInterest], pcaj.[IdPersonCustomAttribute], pcav.[Id], pcav.[Value]
	FROM PersonCustomAttributesJoined pcaj
	LEFT JOIN PersonCustomAttributeValue pcav (NOLOCK) ON pcaj.[IdPersonOfInterest] = pcav.[IdPersonOfInterest] AND pcaj.[IdPersonCustomAttribute] = pcav.[IdPersonCustomAttribute]
END
