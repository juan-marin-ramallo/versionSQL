/****** Object:  Procedure [dbo].[GetPointsOfInterestByFilters]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetPointsOfInterestByFilters] 
( 	
	@IdDepartment [sys].[int]= NULL,
	@IdDepartmentLocation [sys].[int]= NULL,
	@IdHierarchy1 [sys].[int]= NULL,
	@IdHierarchy2 [sys].[int]= NULL
)
AS
BEGIN
	
	DECLARE @DepartmentLocationName [sys].[varchar](100)
	IF @IdDepartmentLocation IS NOT NULL
	BEGIN
		SET @DepartmentLocationName = (SELECT [Name] FROM [dbo].[DepartmentLocation] WHERE [Id] = @IdDepartmentLocation)
	END

	SELECT	P.[Id] AS PointOfInterestId, P.[Name] AS PointOfInterestName, P.[Identifier] AS PointOfInterestIdentifier, 
			P.[Address] AS PointOfInterestAddress, 
			P.[Latitude] AS PointOfInterestLatitude, P.[Longitude] AS PointOfInterestLongitude, 
			P.[Radius] AS PointOfInterestRadius
		
	FROM	[dbo].[PointOfInterest] P WITH (NOLOCK)		
			LEFT JOIN [dbo].[CustomAttributeValue] CAV WITH (NOLOCK) ON CAV.[IdPointOfInterest] = P.[Id] 
						
	WHERE	P.[Deleted] = 0 AND (@IdDepartment IS NULL OR P.[IdDepartment] = @IdDepartment)
			AND (@IdHierarchy1 IS NULL OR P.[GrandfatherId] = @IdHierarchy1)
			AND (@IdHierarchy2 IS NULL OR P.[FatherId] = @IdHierarchy2)
			AND (@IdDepartmentLocation IS NULL OR CAV.[Value] = @DepartmentLocationName)
	
	GROUP BY P.[Id], P.[Name], P.[Identifier], P.[Address], P.[Latitude], P.[Longitude], P.[Radius], P.[NFCTagId]
END
