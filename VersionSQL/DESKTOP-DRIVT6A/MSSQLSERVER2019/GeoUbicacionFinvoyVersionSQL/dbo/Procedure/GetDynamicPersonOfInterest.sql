/****** Object:  Procedure [dbo].[GetDynamicPersonOfInterest]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================================================  
-- Author:  Juan Marin  
-- Create date: 10/11/2023  
-- Description: SP para obtener todas las personas de interes asociada a una dinamica  
-- Modified date: 21/11/2023  
-- Description: Add parameter to include person of interest deleted  
-- =============================================================================  
CREATE PROCEDURE [dbo].[GetDynamicPersonOfInterest]  
(  
  @IdDynamic [int],  
  @IncludePersonOfInterestDeleted [bit] = 0  
)  
AS  
BEGIN  
SET NOCOUNT ON  
  
  SELECT POI.Id AS PersonOfInterestId,  POI.[Name] AS PersonOfInterestName, POI.[LastName] AS PersonOfInterestLastName, POI.Identifier AS PersonOfInterestIdentifier, POI.Deleted AS PersonOfInterestDeleted,  
   D.[Id] AS DynamicId, D.[Name] AS [Dynamic]  
  FROM [dbo].[DynamicPersonOfInterest] DPOI WITH (NOLOCK)  
  INNER JOIN [dbo].[PersonOfInterest] POI WITH (NOLOCK) ON POI.Id = DPOI.IdPersonOfInterest AND (@IncludePersonOfInterestDeleted = 1 OR POI.Deleted = 0)  
  INNER JOIN [dbo].[Dynamic] D WITH (NOLOCK) ON D.Id = DPOI.IdDynamic AND D.Deleted = 0  
  WHERE DPOI.IdDynamic = @IdDynamic  
  UNION
  SELECT POI.Id AS PersonOfInterestId,  POI.[Name] AS PersonOfInterestName, POI.[LastName] AS PersonOfInterestLastName, POI.Identifier AS PersonOfInterestIdentifier, POI.Deleted AS PersonOfInterestDeleted,  
  D.[Id] AS DynamicId, D.[Name] AS [Dynamic]  
  FROM [dbo].[Dynamic] D WITH (NOLOCK)
  LEFT JOIN [dbo].[PersonOfInterest] POI WITH (NOLOCK) ON D.[AllPersonOfInterest] = 1
  WHERE D.[Id] = @IdDynamic AND D.[AllPersonOfInterest] = 1
  ORDER BY POI.Identifier  
END
