/****** Object:  Procedure [dbo].[GetDynamicsPersonOfInterestForTemplate]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================================================
-- Author:		Juan Marin
-- Create date: 02/11/2023
-- Description:	SP para obtener la informacion de las dinamicas y personas de interes para el template
-- =============================================================================
CREATE PROCEDURE [dbo].[GetDynamicsPersonOfInterestForTemplate] 
AS
BEGIN
	SELECT	D.[Id] AS DynamicId, D.[Name] AS [Dynamic], 
			POI.[Id] AS PersonOfInterestId, POI.[Name] AS PersonOfInterestName, POI.[Identifier] AS PersonOfInterestIdentifier
	FROM	[dbo].[DynamicPersonOfInterest] DPOI WITH (NOLOCK)
	INNER JOIN [dbo].[Dynamic] D WITH (NOLOCK) ON D.[Id] = DPOI.[IdDynamic] AND D.[Disabled] = 0 AND D.[Deleted] = 0
	INNER JOIN [dbo].[PersonOfInterest] POI WITH (NOLOCK) ON POI.[Id] = DPOI.[IdPersonOfInterest] AND POI.[Deleted] = 0
	ORDER BY D.[Name], POI.[Identifier]
END
