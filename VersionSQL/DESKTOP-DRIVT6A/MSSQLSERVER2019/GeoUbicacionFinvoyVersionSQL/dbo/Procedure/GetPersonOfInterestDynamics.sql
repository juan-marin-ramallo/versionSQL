/****** Object:  Procedure [dbo].[GetPersonOfInterestDynamics]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================      
-- Author:  Jesús Portillo      
-- Create date: 01/11/2023      
-- Description: SP para obtener las dinámicas      
--              asociadas a una persona de      
--              interés      
-- =============================================      
CREATE PROCEDURE [dbo].[GetPersonOfInterestDynamics]      
(      
    @IdPersonOfInterest [int]      
)      
AS      
BEGIN      
    SELECT      D.[Id], [D].[Name], D.[StartDate], D.[EndDate], [FP].[IdForm] IdFormPlus, DR.[Id] AS IdDynamicReference, DR.[Name] AS DynamicReferenceName      
    FROM        [dbo].[Dynamic] D WITH (NOLOCK)      
    INNER JOIN [dbo].[FormPlus] FP WITH (NOLOCK) ON FP.[Id] = D.[IdFormPlus] AND FP.[Deleted] = 0      
    INNER JOIN [dbo].[Form] F WITH (NOLOCK) ON Fp.[IdForm] = F.[Id]    
                LEFT OUTER JOIN [dbo].[DynamicReference] DR WITH (NOLOCK) ON DR.[IdDynamic] = D.[Id] AND DR.[Deleted] = 0      
 WHERE       D.[Disabled] = 0      
                AND D.[Deleted] = 0      
                AND F.[Deleted] = 0      
                AND D.[EndDate] > GETDATE()      
                AND D.[StartDate] < GETDATE()      
                AND (D.[AllPersonOfInterest] = 1 OR EXISTS (      
                    SELECT  TOP (1) 1      
                    FROM    [dbo].[DynamicPersonOfInterest] DPI WITH (NOLOCK)      
                    WHERE   DPI.[IdDynamic] = D.[Id]      
                            AND DPI.[IdPersonOfInterest] = @IdPersonOfInterest      
                ))      
 ORDER BY    D.[Id], DR.[Id];      
END
