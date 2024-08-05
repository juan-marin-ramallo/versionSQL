/****** Object:  Procedure [dbo].[DeleteCatalog]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================  
-- Author:  <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
-- =============================================  
CREATE PROCEDURE [dbo].[DeleteCatalog]  
   @Id int  
AS   
BEGIN   
  
 IF EXISTS(SELECT IdCatalog FROM ScheduleProfileCatalog NOLOCK WHERE IdCatalog = @Id) OR EXISTS(SELECT IdCatalog FROM CatalogPointOfInterest NOLOCK WHERE IdCatalog = @Id) BEGIN
  SELECT STUFF((SELECT CONCAT(', ', poi.[Name]) FROM CatalogPointOfInterest (NOLOCK) cpoi LEFT JOIN PointOfInterest (NOLOCK) poi ON cpoi.IdPointOfInterest = poi.Id WHERE cpoi.IdCatalog = @Id FOR XML PATH('')), 1, 2, '') AS PointOfInterestAssigned,
    STUFF((SELECT CONCAT(', ', sp.[Description]) FROM ScheduleProfileCatalog (NOLOCK) spc LEFT JOIN ScheduleProfile (NOLOCK) sp ON spc.IdScheduleProfile = sp.Id WHERE spc.IdCatalog = @Id FOR XML PATH('')), 1, 2, '') AS ScheduleProfileAssigned;
 END
 ELSE BEGIN
  DECLARE @Now [sys].[datetime]  
     SET @Now = GETUTCDATE()  
   
  UPDATE pcl  
  SET  pcl.[LastUpdatedDate] = @Now  
  from [dbo].[ProductPointOfInterestChangeLog] pcl  
   INNER JOIN dbo.ProductPointOfInterest ppp ON pcl.IdPointOfInterest = ppp.IdPointOfInterest  
  WHERE ppp.IdCatalog = @Id  
   
  INSERT INTO [dbo].[ProductPointOfInterestChangeLog]  ([IdPointOfInterest], [LastUpdatedDate])  
  SELECT poi.[Id], @Now  
  FROM [dbo].[PointOfInterest] AS poi  
    INNER JOIN dbo.ProductPointOfInterest ppp ON poi.id = ppp.IdPointOfInterest  
  WHERE POI.[Deleted] = 0 AND ppp.IdCatalog = @Id  
    AND NOT EXISTS (SELECT 1 FROM [dbo].[ProductPointOfInterestChangeLog] AS prpoi   
        WHERE prpoi.[IdPointOfInterest] = poi.[Id])  
   
  DELETE FROM dbo.[ProductPointOfInterest]   
  WHERE IdCatalog = @Id  
       
  UPDATE [dbo].[Catalog]  
  SET  [Deleted] = 1  
  WHERE [Id] = @Id  
 END
END
