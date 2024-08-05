/****** Object:  Procedure [dbo].[GetPersonCustomAttributes]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================  
-- Author: Cristian Barbarini  
-- Create date: 03/10/2023  
-- Description: SP para obtener los atributos de las personas  
-- =============================================  
CREATE PROCEDURE [dbo].[GetPersonCustomAttributes]  
AS  
BEGIN  
 SELECT pca.[Id], pca.[Name], cavt.[Code] AS IdType, cavt.[Description] AS TypeDescription, pca.[IdUser], pca.[Deleted]  
 FROM [dbo].[PersonCustomAttribute] pca  
 INNER JOIN [dbo].[CustomAttributeValueType] cavt ON pca.IdType = cavt.Code  
 WHERE pca.[Deleted] = 0  
END
