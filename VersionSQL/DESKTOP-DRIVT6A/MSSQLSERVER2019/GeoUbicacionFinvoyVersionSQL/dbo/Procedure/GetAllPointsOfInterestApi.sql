/****** Object:  Procedure [dbo].[GetAllPointsOfInterestApi]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 17/07/2020
-- Description:	SP para obtener todos los puntos de interés JUNTO CON SUS AGRUPACIONES para ser utilizado en la api
-- =============================================
CREATE PROCEDURE [dbo].[GetAllPointsOfInterestApi]
(
	 @IdPointsOfInterest [sys].[varchar](max) = NULL
	,@IdUser [sys].[int] = NULL
)
AS
BEGIN
	SELECT		P.[Id], P.[Name], P.[Address], P.[Identifier], P.[Latitude], P.[Longitude], 
				P.[Radius], P.[MinElapsedTimeForVisit], P.[NFCTagId], P.[Deleted],
				P.[IdDepartment], D.[Name] AS DepartmentName, P.[ContactName], P.[ContactPhoneNumber],
				CAT.[Name] AS CustomAttributeName, ISNULL(CAO.[Text], CAV.[Value]) AS CustomAttributeValue, CAT.[Id] AS CustomAttributeId, CAT.[IdValueType] AS CustomAttributeIdValueType,
				H1.[Id] AS IdHierarchyLevel1, H1.[Name] AS HierarchyLevel1Name, H1.[SapId] AS HierarchyLevel1Identifier,
				H2.[Id] AS IdHierarchyLevel2, H2.[Name] AS HierarchyLevel2Name,H2.[SapId] AS HierarchyLevel2Identifier,
				Z.[Id] AS IdZone, Z.[Description] AS ZoneDescription, Z.ApplyToAllPointOfInterest, Z.ApplyToAllPersonOfInterest, CAV.Id as CustomAttributeIdValueId

	FROM		[dbo].[PointOfInterest] P WITH (NOLOCK)
				LEFT OUTER JOIN [dbo].[PointOfInterestZone] PZ WITH (NOLOCK) ON PZ.[IdPointOfInterest] = P.[Id]
				LEFT OUTER JOIN dbo.Department D WITH (NOLOCK) ON D.Id = P.IdDepartment
				LEFT OUTER JOIN dbo.[Zone] Z WITH (NOLOCK) ON Z.Id = PZ.IdZone
				LEFT JOIN [dbo].[CustomAttributeValue] CAV WITH (NOLOCK) ON CAV.[IdPointOfInterest] = P.[Id]
				LEFT OUTER JOIN [dbo].[CustomAttributeOption] CAO WITH (NOLOCK) ON CAV.IdCustomAttributeOption = CAO.Id
				LEFT JOIN [dbo].[CustomAttributeTranslated] CAT WITH (NOLOCK) ON CAV.[IdCustomAttribute] = CAT.[Id] AND CAT.[Deleted] = 0
				LEFT JOIN [dbo].[POIHierarchyLevel1] H1 WITH (NOLOCK) ON H1.[Id] = P.[GrandfatherId]
				LEFT JOIN [dbo].[POIHierarchyLevel2] H2 WITH (NOLOCK) ON H2.[Id] = P.[FatherId]

	WHERE		((@IdPointsOfInterest IS NULL) OR (dbo.CheckValueInList(P.[Id], @IdPointsOfInterest) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckZoneInUserZones(PZ.[IdZone], @IdUser) = 1))
	ORDER BY P.Id
END
