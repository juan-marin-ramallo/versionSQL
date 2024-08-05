/****** Object:  Procedure [dbo].[GetHierarchy1Filtered]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 10/05/2017
-- Description:	SP para obtener las JERARQUIAS NIVEL 1
-- =============================================
CREATE PROCEDURE [dbo].[GetHierarchy1Filtered]
(
	 @IdHierarchy [sys].[varchar](max) = NULL
	,@IdPointsOfInterest [sys].[varchar](max) = NULL
	,@IdUser [sys].[int] = NULL
)
AS
BEGIN
	
	SELECT		G.[Id], G.[Name], G.[SapId] AS Identifier

	FROM		[dbo].[POIHierarchyLevel1] G
				LEFT JOIN [dbo].[PointOfInterest] P ON P.[GrandfatherId] =  G.[Id]
	
	WHERE		G.[Deleted] = 0 AND 
				((@IdHierarchy IS NULL) OR (dbo.CheckValueInList(G.[Id], @IdHierarchy) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1)) AND
				((@IdPointsOfInterest IS NULL) OR (dbo.CheckValueInList(P.[Id], @IdPointsOfInterest) = 1))
	
	GROUP BY	G.[Id], G.[Name], G.[SapId]
	ORDER BY	G.[Name]
END
