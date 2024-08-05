/****** Object:  Procedure [dbo].[GetAssetReportAttributeImagesByAssetReportId]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================  
-- Author:Cbarbarini  
-- Create date: 13/12/2021  
-- Description: SP para obtener todas las imagenes de atributos del reporte de activos por Id  
-- =============================================  
CREATE PROCEDURE [dbo].[GetAssetReportAttributeImagesByAssetReportId]  
 @AssetReportId INT  
AS  
BEGIN  
 SELECT apav.Id
  , apav.ImageEncoded AS FileEncoded
  , apav.ImageName
  , apav.ImageUrl
  , ard.Date
  , poi.Name AS PointOfInterestName
 FROM dbo.AssetReportAttributeValue (NOLOCK) apav  
 LEFT OUTER JOIN AssetReportAttribute (NOLOCK) ara ON apav.IdAssetReportAttribute = ara.Id  
 LEFT OUTER JOIN AssetReportDynamic (NOLOCK)  ard ON apav.IdAssetReport = ard.Id  
 LEFT OUTER JOIN PointOfInterest (NOLOCK) poi ON ard.IdPointOfInterest = poi.Id  
 WHERE ara.IdType = 1 -- Cámara  
  AND ara.Deleted = 0  
  AND apav.ImageName IS NOT NULL  
  AND apav.ImageUrl IS NOT NULL  
  AND apav.IdAssetReport = @AssetReportId  
END
