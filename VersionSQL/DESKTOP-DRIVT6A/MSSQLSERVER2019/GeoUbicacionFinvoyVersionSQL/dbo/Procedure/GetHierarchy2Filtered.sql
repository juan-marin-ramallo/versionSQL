/****** Object:  Procedure [dbo].[GetHierarchy2Filtered]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 10/05/2017
-- Description:	SP para obtener las JERARQUIAS NIVEL 1
-- =============================================
CREATE PROCEDURE [dbo].[GetHierarchy2Filtered]
(
	 @IdHierarchy1 [sys].[varchar](max) = NULL
	,@IdHierarchy2 [sys].[varchar](max) = NULL
	,@IdPointsOfInterest [sys].[varchar](max) = NULL
	,@IdUser [sys].[int] = NULL
)
AS
BEGIN
	
	SELECT		F.[Id], F.[Name], F.[SapId] AS Identifier, F.[HierarchyLevel1Id], G.[Name] AS HierarchyLevel1Name

	FROM		[dbo].[POIHierarchyLevel2] F
				LEFT JOIN [dbo].[PointOfInterest] P ON P.[FatherId] =  F.[Id]
				LEFT JOIN [dbo].[POIHierarchyLevel1] G ON G.[Id] =  F.[HierarchyLevel1Id]
	
	WHERE		F.[Deleted] = 0 AND
				((@IdHierarchy1 IS NULL) OR (dbo.CheckValueInList(G.[Id], @IdHierarchy1) = 1)) AND
				((@IdHierarchy2 IS NULL) OR (dbo.CheckValueInList(F.[Id], @IdHierarchy2) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1)) AND
				((@IdPointsOfInterest IS NULL) OR (dbo.CheckValueInList(P.[Id], @IdPointsOfInterest) = 1))
	
	GROUP BY	F.[Id], F.[Name], F.[SapId], F.[HierarchyLevel1Id], G.[Name]
	ORDER BY	F.[Name]
END
