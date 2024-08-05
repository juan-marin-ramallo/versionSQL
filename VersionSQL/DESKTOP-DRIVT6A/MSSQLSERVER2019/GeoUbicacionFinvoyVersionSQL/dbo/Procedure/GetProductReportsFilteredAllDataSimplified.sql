/****** Object:  Procedure [dbo].[GetProductReportsFilteredAllDataSimplified]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetProductReportsFilteredAllDataSimplified]
	@DateFrom datetime,
	@DateTo datetime,
    @IdPersonOfInterest varchar(max)=null,
    @IdPointOfInterest varchar(max)=null,
	@IdUser [sys].INT = NULL
AS 
BEGIN
    SET NOCOUNT ON;
	
	--SET @DateTo = DATEADD (ms, -1, DATEADD(dd, 1, @DateTo))

	SELECT PR.[Id], PR.[IdProduct] as ProductId, PR.[IdPersonOfInterest] as PersonOfInterestId, 
		PR.[IdPointOfInterest] AS PointOfInterestId, PR.[ReportDateTime], PR.[TheoricalStock], PR.[TheoricalPrice],
		P.[Identifier] AS ProductIdentifier, P.[Name] as ProductName, P.[BarCode] AS ProductBarCode,
		POI.[Name] AS PointOfInterestName, POI.[Identifier] AS PointOfInterestIdentifier, POI.[Address] AS PointOfInterestAddress,
		D.[Id] AS IdDepartment, D.[Name] AS DepartmentName,
		POIH1.[Id] AS POIHierarchyLevel1Id, POIH1.[Name] AS POIHierarchyLevel1Name, POIH1.[SapId] AS POIHierarchyLevel1SapId,
		POIH2.[Id] AS POIHierarchyLevel2Id, POIH2.[Name] AS POIHierarchyLevel2Name, POIH2.[SapId] AS POIHierarchyLevel2SapId,
		PEOI.[Name] as PersonOfInterestName, PEOI.[LastName] AS PersonOfInterestLastName, PEOI.[Identifier] AS PersonOfInterestIdentifier,
		PEOI.[MobilePhoneNumber] AS PersonOfInterestMobile, PEOI.[MobileIMEI] AS PersonOfInterestIMEI,
		PRAV.[IdProductReportAttribute], PRAV.[Value] AS ProductReportAttributeValue, PRAV.[Id] AS IdProductReportAttributeValue,
		PRAT.[IdType] AS IdProductReportAttributeType, 
		PRO.[Text] AS ProductReportAttributeOption,
		PRAV.[ImageEncoded] AS ProductReportAttributeImage, PRAV.[ImageUrl] AS ProductReportAttributeImageUrl,
		PRAV.[ImageName] AS ProductReportAttributeImageName
		
	FROM	[dbo].[ProductReportDynamic] PR WITH (NOLOCK) 
			INNER JOIN	[dbo].[Product] P WITH (NOLOCK) ON P.[Id] = PR.[IdProduct] 
			INNER JOIN	[dbo].[PointOfInterest] POI WITH (NOLOCK) ON POI.[Id] = PR.[IdPointOfInterest]
			INNER JOIN	[dbo].[PersonOfInterest] PEOI WITH (NOLOCK) ON PEOI.[Id] = PR.[IdPersonOfInterest]
			LEFT JOIN	[dbo].[Department] D WITH (NOLOCK) ON D.[Id] = POI.[IdDepartment]
			LEFT JOIN	[dbo].[POIHierarchyLevel1] POIH1 WITH (NOLOCK) ON POIH1.[Id] = POI.[GrandfatherId]
			LEFT JOIN	[dbo].[POIHierarchyLevel2] POIH2 WITH (NOLOCK) ON POIH2.[Id] = POI.[FatherId]
			LEFT JOIN   [dbo].[ProductReportAttributeValue] PRAV WITH (NOLOCK) ON PRAV.[IdProductReport] = PR.[Id]
			LEFT JOIN   [dbo].[ProductReportAttribute] PRAT WITH (NOLOCK) ON PRAT.[Id] = PRAV.[IdProductReportAttribute]
			LEFT JOIN   [dbo].[ProductReportAttributeOption] PRO WITH (NOLOCK) ON PRO.[Id] = PRAV.[IdProductReportAttributeOption]
		
	WHERE	(pr.[ReportDateTime] BETWEEN @DateFrom AND @DateTo) AND	
			((@IdPersonOfInterest IS NULL) OR dbo.CheckValueInList (PR.[IdPersonOfinterest], @IdPersonOfInterest) =1) AND
			((@IdPointOfInterest IS NULL) OR dbo.CheckValueInList (PR.[IdPointOfInterest], @IdPointOfInterest) =1) AND
			((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(PEOI.[Id], @IdUser) = 1)) AND
			((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(POI.[Id], @IdUser) = 1)) AND
			((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(PEOI.[IdDepartment], @IdUser) = 1)) AND
			((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(POI.[IdDepartment], @IdUser) = 1)) AND
			((@IdUser IS NULL) OR (dbo.CheckUserInProductCompanies(P.[IdProductBrand], @IdUser) = 1)) 
			AND (PRAV.[Id] IS NULL OR PRAT.[FullDeleted] = 0)
		
	ORDER BY PR.[ReportDateTime], PR.[Id]
	
END
