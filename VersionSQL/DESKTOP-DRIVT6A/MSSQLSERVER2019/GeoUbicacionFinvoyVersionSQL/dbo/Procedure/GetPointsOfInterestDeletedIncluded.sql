/****** Object:  Procedure [dbo].[GetPointsOfInterestDeletedIncluded]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		gl
-- Create date: 01/02/2019
-- Description:	SP para obtener los puntos de interés aun eliminados
-- =============================================
CREATE PROCEDURE [dbo].[GetPointsOfInterestDeletedIncluded]
(
	 @IdPointsOfInterest [sys].[varchar](max) = NULL
	,@IdUser [sys].[int] = NULL
)
AS
BEGIN
	SELECT		P.[Id], P.[Name], P.[Address], P.[Identifier], P.[Latitude], P.[Longitude], 
				P.[Radius], P.[MinElapsedTimeForVisit], P.[NFCTagId],
				P.[IdDepartment], D.[Name] AS DepartmentName, P.[ContactName], P.[ContactPhoneNumber],
				CAT.[Name] AS CustomAttributeName, CAV.[Value] AS CustomAttributeValue, CAT.[Id] AS CustomAttributeId,
				H1.[Id] AS IdHierarchyLevel1, H1.[Name] AS HierarchyLevel1Name,
				H2.[Id] AS IdHierarchyLevel2, H2.[Name] AS HierarchyLevel2Name
						

	FROM		[dbo].[PointOfInterest] P WITH (NOLOCK)
				LEFT OUTER JOIN dbo.Department D WITH (NOLOCK) ON D.Id = P.IdDepartment
				LEFT JOIN [dbo].[CustomAttributeValue] CAV WITH (NOLOCK) ON CAV.[IdPointOfInterest] = P.[Id]
				LEFT JOIN [dbo].[CustomAttributeTranslated] CAT WITH (NOLOCK) ON CAV.[IdCustomAttribute] = CAT.[Id] AND CAT.[Deleted] = 0
				LEFT JOIN [dbo].[POIHierarchyLevel1] H1 WITH (NOLOCK) ON H1.[Id] = P.[GrandfatherId]
				LEFT JOIN [dbo].[POIHierarchyLevel2] H2 WITH (NOLOCK) ON H2.[Id] = P.[FatherId]

	WHERE		((@IdPointsOfInterest IS NULL) OR (dbo.CheckValueInList(P.[Id], @IdPointsOfInterest) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1))
	
	GROUP BY	P.[Id], P.[Name], P.[Address], P.[Identifier], P.[Latitude], P.[Longitude], P.[Radius], P.[MinElapsedTimeForVisit], 
				P.[IdDepartment], D.[Name], P.[NFCTagId], P.[ContactName], P.[ContactPhoneNumber],
				CAT.[Name], CAV.[Value], CAT.[Id], H1.[Id], H1.[Name], H2.[Id], H2.[Name]

	order by	P.[Id]
END
