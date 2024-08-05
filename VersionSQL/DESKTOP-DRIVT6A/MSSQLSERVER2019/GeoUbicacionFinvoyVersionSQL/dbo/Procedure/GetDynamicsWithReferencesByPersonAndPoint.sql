/****** Object:  Procedure [dbo].[GetDynamicsWithReferencesByPersonAndPoint]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================    
-- Author:  Jesús Portillo    
-- Create date: 01/11/2023    
-- Description: SP para obtener las dinámicas    
--              asociadas a una persona de    
--              interés con sus referencias y    
--              valores    
-- =============================================    
CREATE PROCEDURE [dbo].[GetDynamicsWithReferencesByPersonAndPoint]    
(    
     @IdPersonOfInterest [int]    
    ,@IdPointOfInterest [int]    
)    
AS    
BEGIN    
    SELECT      DPPOI.[IdProduct], DPPOI.[IdDynamic], DRV.[IdDynamicReference], DRV.[Value]    
    FROM        [dbo].[Dynamic] D WITH (NOLOCK)    
                INNER JOIN [dbo].[DynamicProductPointOfInterest] DPPOI WITH (NOLOCK) ON DPPOI.[IdDynamic] = D.[Id] AND DPPOI.[IdPointOfInterest] = @IdPointOfInterest    
                LEFT OUTER JOIN [dbo].[DynamicReference] DR WITH (NOLOCK) ON DR.[IdDynamic] = D.[Id] AND DR.[Deleted] = 0    
                LEFT OUTER JOIN [dbo].[DynamicReferenceValue] DRV WITH (NOLOCK) ON DRV.[IdDynamicReference] = DR.[Id] AND DRV.[IdDynamicProductPointOfInterest] = DPPOI.[Id]    
    WHERE       D.[Disabled] = 0    
                AND D.[EndDate] > GETDATE()    
                AND D.[StartDate] < GETDATE()    
                AND D.[Deleted] = 0                    
                AND (D.[AllPersonOfInterest] = 1 OR EXISTS (    
                    SELECT  TOP (1) 1    
                    FROM    [dbo].[DynamicPersonOfInterest] DPI WITH (NOLOCK)    
                    WHERE   DPI.[IdDynamic] = D.[Id]    
                            AND DPI.[IdPersonOfInterest] = @IdPersonOfInterest    
                ))    
                AND EXISTS (    
                    SELECT  TOP (1) 1    
                    FROM    [dbo].[Product] P WITH (NOLOCK)    
                    WHERE   P.[Id] = DPPOI.[IdProduct]    
                            AND P.[Deleted] = 0    
                )    
    ORDER BY    DPPOI.[IdProduct], DPPOI.[IdDynamic], DRV.[IdDynamicReference];    
END
