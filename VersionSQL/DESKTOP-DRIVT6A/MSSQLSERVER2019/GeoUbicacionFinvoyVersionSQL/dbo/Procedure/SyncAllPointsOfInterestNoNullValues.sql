/****** Object:  Procedure [dbo].[SyncAllPointsOfInterestNoNullValues]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================  
-- Author: Cristian Barbarini  
-- Create date: 27/04/2015  
-- Description: SP para sincronizar los PUNTOS DESDE LA API sin actualizar parámetros nulls  
-- =============================================  
CREATE PROCEDURE [dbo].[SyncAllPointsOfInterestNoNullValues]  
(  
 @Data PointOfInterestTableTypeAllowNulls READONLY  
)  
AS  
BEGIN  
 SET ANSI_WARNINGS OFF;  
  
 UPDATE PR SET PR.Identifier = ISNULL(P.Id, PR.Identifier),  
  PR.Name = ISNULL(P.Name, PR.Name),  
  PR.Address = ISNULL(P.Address, PR.Address),  
  PR.Latitude = ISNULL(P.Latitude, PR.Latitude),  
  PR.Longitude = ISNULL(P.Longitude, PR.Longitude),  
  PR.LatLong = GEOGRAPHY::STPointFromText('POINT(' + CAST(P.Longitude AS VARCHAR(25)) + ' ' + CAST(P.Latitude AS VARCHAR(25)) + ')', 4326),  
  PR.Radius = ISNULL(P.Radius, PR.Radius),  
  PR.MinElapsedTimeForVisit = ISNULL(P.MinElapsedTimeForVisit, PR.MinElapsedTimeForVisit),  
  PR.IdDepartment = ISNULL(P.ProvinceId, PR.IdDepartment),  
  PR.ContactName = ISNULL(P.ContactName, PR.ContactName),  
  PR.Emails = ISNULL(P.Emails, PR.Emails),  
  PR.ContactPhoneNumber = ISNULL(P.ContactPhoneNumber, PR.ContactPhoneNumber),  
  PR.NFCTagId = ISNULL(P.NFCTagId, PR.NFCTagId),  
  PR.GrandfatherId = ISNULL(H1.Id, PR.GrandfatherId),  
  PR.EditedDate = GETUTCDATE(),  
  PR.FatherId = ISNULL(H2.Id, PR.FatherId)  
 FROM dbo.PointOfInterest PR  
 INNER JOIN @Data AS P ON PR.Identifier = P.Id  
 LEFT OUTER JOIN dbo.Department D ON d.Id = P.ProvinceId  
 LEFT OUTER JOIN dbo.POIHierarchyLevel1 H1 ON H1.SapId = P.HierarchyLevel1Id  
 LEFT OUTER JOIN dbo.POIHierarchyLevel2 H2 ON H2.SapId = P.HierarchyLevel2Id  
 WHERE PR.Deleted = 0  
  AND (P.ProvinceId IS NULL OR D.Id IS NOT NULL)  
  AND (H1.Id IS NULL OR H1.Deleted = 0)  
  AND (H2.Id IS NULL OR H2.Deleted = 0)  
  
 INSERT INTO PointOfInterest(Identifier, Name, Address, Latitude, Longitude, LatLong, Radius,  
  MinElapsedTimeForVisit, IdDepartment, ContactName, ContactPhoneNumber, Deleted, NFCTagId, GrandfatherId, FatherId, Emails, CreatedDate)  
 SELECT P.Id, P.Name, P.Address, P.Latitude, P.Longitude,  
  GEOGRAPHY::STPointFromText('POINT(' + CAST(P.Longitude AS VARCHAR(25)) + ' ' + CAST(P.Latitude AS VARCHAR(25)) + ')', 4326),  
 P.Radius, P.MinElapsedTimeForVisit, P.ProvinceId, P.ContactName, P.ContactPhoneNumber, 0, P.NFCTagId, H1.Id, H2.Id, P.Emails, GETUTCDATE()  
 FROM @Data P  
 LEFT OUTER JOIN PointOfInterest as PR WITH (NOLOCK) ON PR.Identifier = P.Id AND PR.Deleted = 0  
 LEFT OUTER JOIN Department D WITH (NOLOCK) ON d.Id = P.ProvinceId  
 LEFT OUTER JOIN POIHierarchyLevel1 H1 WITH (NOLOCK) ON H1.SapId = P.HierarchyLevel1Id  
 LEFT OUTER JOIN POIHierarchyLevel2 H2 WITH (NOLOCK) ON H2.SapId = P.HierarchyLevel2Id  
 WHERE PR.Id IS NULL AND  
  (P.ProvinceId IS NULL OR D.Id IS NOT NULL)  
  AND (H1.Id IS NULL OR H1.Deleted = 0)  
  AND (H2.Id IS NULL OR H2.Deleted = 0)  

 UPDATE POI SET POI.Deleted = 1
 FROM PointOfInterest POI WITH (NOLOCK)
 LEFT JOIN @Data P ON POI.Identifier = P.Id
 WHERE P.Id IS NULL
  
 SET ANSI_WARNINGS ON;  
END
