/****** Object:  Procedure [dbo].[GetPointOfInterestById]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 14/10/2015
-- Description:	SP para obtener el punto de interes segun su id
-- =============================================
CREATE PROCEDURE [dbo].[GetPointOfInterestById]
(
	 @IdPointOfInterest [sys].[INT] = NULL
)
AS
BEGIN
	SELECT		P.[Id], P.[Name], P.[Address], P.[Identifier], P.[Latitude], P.[Longitude], P.[Radius], 
				P.[MinElapsedTimeForVisit], P.[IdDepartment], P.[Deleted], P.[Image] AS FileEncoded, P.[ImageUrl],
				P.[ContactName], P.[ContactPhoneNumber], P.[GrandfatherId] AS HierarchyLevel1Id, P.[FatherId] AS HierarchyLevel2Id,
				PHL1.[Name] AS HierarchyLevel1Name, PHL2.[Name] AS HierarchyLevel2Name,
				D.[Name] AS DepartmentName
	
	FROM		[dbo].[PointOfInterest] P WITH (NOLOCK)
				LEFT OUTER JOIN [dbo].[PointOfInterestZone] PZ WITH (NOLOCK) ON PZ.[IdPointOfInterest] = P.[Id]
				LEFT OUTER JOIN [dbo].[POIHierarchyLevel1] PHL1 WITH (NOLOCK) ON P.[GrandfatherId] = PHL1.[Id]	
				LEFT OUTER JOIN [dbo].[POIHierarchyLevel2] PHL2 WITH (NOLOCK) ON P.[FatherId] = PHL2.[Id]
				LEFT OUTER JOIN [dbo].[Department] D WITH (NOLOCK) ON P.[IdDepartment] = D.[Id]	
	
	WHERE		((@IdPointOfInterest IS NULL) OR (p.[Id] = @IdPointOfInterest)) 
	
	GROUP BY	P.[Id], P.[Name], P.[Address], P.[Identifier], P.[Latitude], P.[Longitude], 
				P.[Radius], P.[MinElapsedTimeForVisit], P.[IdDepartment], P.[Deleted], P.[Image], P.[ImageUrl],
				P.[ContactName], P.[ContactPhoneNumber], P.[GrandfatherId], P.[FatherId], PHL1.[Name], PHL2.[Name],
				D.[Name]
END
