/****** Object:  Procedure [dbo].[GetIRData]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author: FS
-- Create date: 14/06/2022
-- Description: SP para obtener información general de RI
-- =============================================
CREATE PROCEDURE [dbo].[GetIRData]
	@IdIRData VARCHAR(256)
AS
BEGIN
	SELECT ir.Id, ir.IdCategory,
		  ir.IdShareOfShelf, ir.IdMissingProduct
		, ir.[IdPointOfInterest] AS PointOfInterestId, POI.[Name] AS PointOfInterestName, POI.[Identifier] AS PointOfInterestIdentifier, POI.IdDepartment AS [PointOfInterestDepartment], POI.[Address] AS [PointOfInterestAddress]
		, POI.ContactName AS [PointOfInterestContactName], POI.ContactPhoneNumber AS [PointOfInterestContactPhoneNumber]  
		, POI.[GrandfatherId] AS HierarchyLevel1Id, POI.[FatherId] AS HierarchyLevel2Id, PHL1.[Name] AS HierarchyLevel1Name, PHL2.[Name] AS HierarchyLevel2Name, PHL1.SapId AS [HierarchyLevel1SapId], PHL2.SapId AS [HierarchyLevel2SapId]  

	FROM dbo.IRData ir WITH (NOLOCK) 
		INNER JOIN dbo.PointOfInterest poi ON ir.IdPointOfInterest = poi.Id
		LEFT OUTER JOIN [dbo].[POIHierarchyLevel1] PHL1 WITH (NOLOCK) ON POI.[GrandfatherId] = PHL1.[Id]   
		LEFT OUTER JOIN [dbo].[POIHierarchyLevel2] PHL2 WITH (NOLOCK) ON POI.[FatherId] = PHL2.[Id]  
	WHERE ir.Id = @IdIRData
END;
