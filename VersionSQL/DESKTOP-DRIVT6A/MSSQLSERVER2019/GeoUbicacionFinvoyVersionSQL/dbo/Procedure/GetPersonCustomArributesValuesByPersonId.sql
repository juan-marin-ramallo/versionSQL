/****** Object:  Procedure [dbo].[GetPersonCustomArributesValuesByPersonId]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author: Cristian Barbarini
-- Create date: 19/10/2023
-- Description: SP para obtener los valores de los atributos de una persona por Id
-- =============================================
CREATE PROCEDURE [dbo].[GetPersonCustomArributesValuesByPersonId]
	@IdPersonOfInterest INT
AS
BEGIN
	SELECT pcav.[Id], pca.[Id] AS [IdPersonCustomAttribute], pca.[Name] AS [PersonCustomAttributeName], pca.[IdType] AS [PersonCustomAttributeType], pcav.[Value]
	FROM [dbo].[PersonCustomAttribute] pca
	LEFT JOIN [dbo].[PersonCustomAttributeValue] pcav ON pcav.IdPersonCustomAttribute = pca.Id AND pcav.IdPersonOfInterest = @IdPersonOfInterest
	LEFT JOIN [dbo].[PersonOfInterest] peoi ON pcav.IdPersonOfInterest = peoi.Id
	WHERE pca.[Deleted] = 0
END
