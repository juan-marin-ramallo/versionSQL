/****** Object:  Procedure [dbo].[GetGlossaryList]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================    
-- Author:  Cristian Barbarini    
-- Create date: 16/01/2023    
-- Description: SP para obtener la lista de glosarios    
-- =============================================    
CREATE PROCEDURE [dbo].[GetGlossaryList]    
(    
     @IncludeDeleted [sys].[bit] = 0    
)    
AS    
BEGIN    
    SELECT      AR.[Name], AR.[Description]    
    FROM        [dbo].[AbsenceReason] AR WITH (NOLOCK)    
    WHERE       (@IncludeDeleted = 1 OR AR.[Deleted] = 0 OR AR.[Deleted] IS NULL)    
    ORDER BY    AR.[Name];    
END
