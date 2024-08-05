/****** Object:  Procedure [dbo].[GetDynamicReferences]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================    
-- Author: Cristian Barbarbini    
-- Create date: 10/11/2023    
-- Description: SP para obtener las referencias reportadas en una dinámica    
-- =============================================    
CREATE PROCEDURE [dbo].[GetDynamicReferences]    
(    
 @IdDynamic [int]    
)    
AS    
BEGIN    
 SELECT dr.[Name] AS [DynamicName]    
 FROM [dbo].[DynamicReferenceCompletedForm] drcf (NOLOCK)    
 INNER JOIN [dbo].[DynamicCompletedForm] dcf (NOLOCK) ON drcf.[IdDynamicCompletedForm] = dcf.[Id]    
 LEFT JOIN [dbo].[DynamicReference] dr (NOLOCK) ON drcf.IdDynamicReference = dr.[Id]    
 WHERE dcf.[IdDynamic] = @IdDynamic    
 GROUP BY dr.[Name]    
END
