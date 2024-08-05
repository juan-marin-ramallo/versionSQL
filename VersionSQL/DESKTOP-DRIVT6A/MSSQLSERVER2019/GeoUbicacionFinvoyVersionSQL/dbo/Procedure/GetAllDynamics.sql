/****** Object:  Procedure [dbo].[GetAllDynamics]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================================================              
-- Author:  Juan Marin              
-- Create date: 08/11/2023              
-- Description: SP para obtener toda la informacion de las dinamicas para mostrar en las grillas              
-- Modified by : Cristian Barbarini            
-- Description: Se agrega parametro @IncludeDeletedOrDisabled             
-- Modified date: 21/11/2023            
-- Description: Add parameter @IncludeFormPlusDeleted to include FormPlus (Form) deleted            
-- =============================================================================              
CREATE PROCEDURE [dbo].[GetAllDynamics]              
 @IdsDynamic [varchar](500) = NULL,            
 @DateFrom [datetime] = NULL,            
 @DateTo [datetime] = NULL,            
 @IdsPointOfInterest [varchar](500) = NULL,            
 @IdsPersonOfInterest [varchar](500) = NULL,            
 @IdsProduct [varchar](500) = NULL,            
 @IncludeDeletedOrDisabled [bit] = 0,            
 @IncludeFormPlusDeleted [bit] = 0,            
 @AllDynamicsByUser [bit] = 0,  
 @IdUser [int] = 0  
AS              
BEGIN              
SET NOCOUNT ON              
              
 SELECT D.[Id] AS DynamicId, D.[Name] AS [DynamicName], D.[Disabled], D.[Deleted],              
   FP.[Id] AS FormPlusId, FP.[Deleted] AS FormPlusDeleted, F.[Id] AS FormId, F.[Name] AS FormName, F.[Deleted] AS FormDeleted, D.StartDate, D.EndDate            
  FROM [dbo].[Dynamic] D WITH (NOLOCK)              
  INNER JOIN [dbo].[FormPlus] FP WITH (NOLOCK) ON FP.[Id] = D.[IdFormPlus] AND (@IncludeFormPlusDeleted = 1 OR FP.[Deleted] = 0)            
  INNER JOIN [dbo].[Form] F WITH (NOLOCK) ON F.[Id] = FP.[IdForm]            
  LEFT JOIN [dbo].[DynamicPersonOfInterest] DPEOI WITH (NOLOCK) ON D.[Id] = DPEOI.[IdDynamic]          
  LEFT JOIN [dbo].[DynamicProductPointOfInterest] DPPOI WITH (NOLOCK) ON D.[Id] = DPPOI.[IdDynamic]          
  WHERE (@IncludeDeletedOrDisabled = 1 OR D.[Deleted] = 0)              
    AND (@IncludeFormPlusDeleted = 1 OR F.[Deleted] = 0)              
    AND ((@IdsDynamic IS NULL) OR (dbo.[CheckValueInList](D.[Id], @IdsDynamic) = 1))      
    AND (@DateFrom IS NULL OR D.[StartDate] > @DateFrom)            
    AND (@DateTo IS NULL OR D.[StartDate] < @DateTo)            
    AND ((@IdsPointOfInterest IS NULL) OR (dbo.[CheckValueInList](DPPOI.[IdPointOfInterest], @IdsPointOfInterest) = 1))            
    AND ((@IdsPersonOfInterest IS NULL) OR (D.[AllPersonOfInterest] = 1) OR (dbo.[CheckValueInList](DPEOI.[IdPersonOfInterest], @IdsPersonOfInterest) = 1) )            
    AND ((@IdsProduct IS NULL) OR (dbo.[CheckValueInList](DPPOI.[IdProduct], @IdsProduct) = 1))            
    AND (@AllDynamicsByUser = 1 OR D.[IdUser] = @IdUser)  
  GROUP BY D.[Id], D.[Name], D.[Disabled], D.[Deleted], FP.[Id], FP.[Deleted], F.[Id], F.[Name], F.[Deleted], D.StartDate, D.EndDate            
  ORDER BY D.[StartDate] DESC, D.[Id] DESC            
END
