/****** Object:  Procedure [dbo].[GetSearchPOIFilters]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetSearchPOIFilters]

AS
BEGIN
	SELECT		1 AS [Type], D.[Id] AS Id, D.[Name] AS [Name], 0 AS IdFather	
	FROM		[dbo].[Department] D WITH (NOLOCK)

	UNION

	SELECT		2 AS [Type], DL.[Id] AS Id, DL.[Name] AS [Name], DL.[IdDepartment] AS IdFather
	FROM		[dbo].[DepartmentLocation] DL WITH (NOLOCK)

	UNION

	SELECT		3 AS [Type], POI1.[Id] AS Id, POI1.[Name] AS [Name], 0 AS IdFather
	FROM		[dbo].[POIHierarchyLevel1] POI1 WITH (NOLOCK)
	WHERE		[Deleted] = 0

	UNION

	SELECT		4 AS [Type], POI2.[Id] AS Id, POI2.[Name] AS [Name], POI2.[HierarchyLevel1Id] AS IdFather
	FROM		[dbo].[POIHierarchyLevel2] POI2 WITH (NOLOCK)
	WHERE		[Deleted] = 0
END
