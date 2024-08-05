/****** Object:  Procedure [dbo].[GetAttributeInfoById]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================  
-- Author:  GL  
-- Create date: 02/10/2017  
-- Description: SP para obtener los nombres de los atributos de control de stock en base a su id  
-- =============================================  
CREATE PROCEDURE [dbo].[GetAttributeInfoById]  
(  
  @IdAttributes [sys].[varchar](max) = NULL,  
  @IdProductReport [sys].[int]   
)  
AS  
BEGIN  
 SELECT  PRA.[Id] AS ProductReportAttributeId, PRA.[Name] AS ProductReportAttributeName,  
    PRA.[IdType] AS ProductReportTypeId,  
    PRAV.[Id] AS ProductReportAttributeValueId, PRAV.[Value] AS ProductReportAttributeValue,   
    PRAV.[ImageUrl] AS ProductReportImageUrl, PRAV.[ImageEncoded] AS ProductReportImageEncoded, PRAV.[ImageName] AS ProductReportImageName,  
    PRS.[Name] AS ProductReportSectionName, PRS.[Id] AS ProductReportSectionId,  
    PRAV.[IdProductReportAttributeOption] AS OptionId
 FROM  [dbo].[ProductReportAttribute] PRA  
    INNER JOIN [dbo].[ProductReportAttributeValue] PRAV ON PRA.Id = PRAV.IdProductReportAttribute   
       AND PRAV.IdProductReport = @IdProductReport  
    INNER JOIN [dbo].[ProductReportSection] PRS ON PRS.Id = PRA.IdProductReportSection  
 WHERE  ((@IdAttributes IS NULL) OR ((dbo.CheckValueInList(PRAV.IdProductReportAttribute, @IdAttributes) = 1)))   
        
 GROUP BY PRA.[Id], PRA.[Name], PRAV.[Id], PRAV.[Value],PRA.[IdType], PRAV.[ImageUrl],   
    PRAV.[ImageEncoded], PRAV.[ImageName], PRS.[Name], PRS.[Id], PRAV.[IdProductReportAttributeOption]  
 ORDER BY PRS.[Id]  
END
