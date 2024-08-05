/****** Object:  Procedure [dbo].[GetProductReportsForEmail]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================  
-- Author:  <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
-- =============================================  
CREATE PROCEDURE [dbo].[GetProductReportsForEmail]  
 @ProductReportIds varchar(MAX)  
AS  
BEGIN  
   
 SELECT  PRAV.[IdProductReport], PRAV.[Value] AS ProductReportAttributeValue,  
    PRAV.[Id] AS IdProductReportAttributeValue,  
    PRAO.[Text] AS ProductReportAttributeOption,  
    PRA.[Id] IdProductReportAttribute, PRA.[Name] AS ProductReportAttributeName,   
    PRA.[IdType] AS IdProductReportAttributeType,  
    P.[Name] AS ProductName, P.[Identifier] AS ProductIdentifier, P.[BarCode] AS ProductBarCode,  
    (CASE WHEN PRAV.[ImageEncoded] IS NULL THEN 0 ELSE 1 END) AS ProductReportAttributeImage,  
    PRAV.[ImageUrl] AS ProductReportAttributeImageUrl,  
    PRAV.[ImageName] AS ProductReportAttributeImageName,  
    PRA.[IdProductReportSection],  
    PRS.[Name] AS ProductReportSectionName,  
    PRAV.IdProductReportAttributeOption
 FROM  ProductReportDynamic PR  
  JOIN  ProductReportAttributeValue PRAV ON PRAV.[IdProductReport] = PR.[Id]  
  LEFT OUTER JOIN ProductReportAttributeOption PRAO ON PRAO.[IdProductReportAttribute] = PRAV.[Id]  
  JOIN  ProductReportAttribute PRA ON PRA.[Id] = PRAV.[IdProductReportAttribute]  
  JOIN  ProductReportSection PRS ON PRS.[Id] = PRA.[IdProductReportSection]  
  JOIN  Product P ON P.[Id] = PR.[IdProduct]  
  
 WHERE  dbo.CheckValueInList(PR.[Id], @ProductReportIds) = 1  
    --AND PRA.[IdType] <> 1  -- Filtrar tipo camara  
    AND PRA.[IdType] <> 10 -- Filtrar tipo titulo  
  
 ORDER BY PRAV.[IdProductReport], PRS.[Order], PRS.[Id], PRA.[Id]  
END
