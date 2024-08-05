/****** Object:  Procedure [dbo].[GetProductReportsFilteredAllData]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetProductReportsFilteredAllData]
	@DateFrom datetime,
	@DateTo datetime,
    @IdProduct varchar(max) = null,
    @IdPersonOfInterest varchar(max)=null,
    @IdPointOfInterest varchar(max)=null,
	@ProductBarCodes [sys].[varchar](max) = NULL,
    @ProductCategoriesId [sys].[varchar](max) = NULL
	,@IdCompany [sys].[varchar](max) = NULL
	,@IdProductBrand [sys].[varchar](max) = NULL,
	@ConditionQuery varchar(max)=NULL,
	@IdUser [sys].INT = NULL
AS 
BEGIN
    SET NOCOUNT ON;
	
	--SET @DateTo = DATEADD (ms, -1, DATEADD(dd, 1, @DateTo))

	IF @ConditionQuery IS NULL
	BEGIN
		DECLARE @DateFromLocal datetime = @DateFrom
		DECLARE @DateToLocal datetime = @DateTo
		DECLARE @IdProductLocal varchar(max) = @IdProduct
		DECLARE @IdPersonOfInterestLocal varchar(max) = @IdPersonOfInterest
		DECLARE @IdPointOfInterestLocal varchar(max) = @IdPointOfInterest
		DECLARE @ProductBarCodesLocal [sys].[varchar](max) = @ProductBarCodes
		DECLARE @ProductCategoriesIdLocal [sys].[varchar](max) = @ProductCategoriesId
		DECLARE @IdCompanyLocal [sys].[varchar](max) = @IdCompany
		DECLARE @IdProductBrandLocal [sys].[varchar](max) = @IdProductBrand
		DECLARE @ConditionQueryLocal varchar(max)=@ConditionQuery
		DECLARE @IdUserLocal int = @IdUser

		SELECT	PR.[Id], PR.[IdProduct], PR.[IdPersonOfInterest], 
				PR.[IdPointOfInterest], PR.[ReportDateTime], PR.[TheoricalStock], PR.[TheoricalPrice],
				PRAV.[IdProductReportAttribute], PRAV.[Value] AS ProductReportAttributeValue, PRAV.[Id] AS IdProductReportAttributeValue,
				PRAT.[IdType] AS IdProductReportAttributeType, 
				PRO.[Text] AS ProductReportAttributeOption,PRAT.[Name] AS ProductReportAttributeName,
				PRAV.[ImageEncoded] AS ProductReportAttributeImage, PRAV.[ImageUrl] AS ProductReportAttributeImageUrl,
				PRAV.[ImageName] AS ProductReportAttributeImageName
		INTO	#ProductReportWithAttributes
		FROM	[dbo].[ProductReportDynamic] PR WITH (NOLOCK)
				LEFT JOIN [dbo].[ProductReportAttributeValue] PRAV WITH (NOLOCK) ON PRAV.[IdProductReport] = PR.[Id]
				LEFT JOIN [dbo].[ProductReportAttribute] PRAT WITH (NOLOCK) ON PRAT.[Id] = PRAV.[IdProductReportAttribute]
				LEFT JOIN [dbo].[ProductReportAttributeOption] PRO WITH (NOLOCK) ON PRO.[Id] = PRAV.[IdProductReportAttributeOption]
		WHERE	(pr.[ReportDateTime] BETWEEN @DateFromLocal AND @DateToLocal)
				AND (PRAV.[Id] IS NULL OR PRAT.[FullDeleted] = 0)
				AND (CASE WHEN PRAV.[Id] IS NULL THEN 0 ELSE PRAT.[FullDeleted] END) = 0
				AND (CASE WHEN @IdProductLocal IS NULL THEN 1 ELSE dbo.CheckValueInList (PR.[IdProduct], @IdProductLocal) END) = 1
				AND (CASE WHEN @IdPersonOfInterestLocal IS NULL THEN 1 ELSE dbo.CheckValueInList (PR.[IdPersonOfinterest], @IdPersonOfInterestLocal) END) = 1
				AND (CASE WHEN @IdPointOfInterestLocal IS NULL THEN 1 ELSE dbo.CheckValueInList (PR.[IdPointOfInterest], @IdPointOfInterestLocal) END) = 1

		SELECT	CAV.[IdPointOfInterest], CAV.[Value], CAT.[Id] AS CustomAttributeId, CAT.[Name] AS CustomAttributeName, CAT.[IdValueType] AS CustomAttributeValueType
		INTO	#CustomAttributeWithValue
		FROM	[dbo].[CustomAttributeValue] CAV WITH (NOLOCK)
				LEFT JOIN [dbo].[CustomAttributeTranslated] CAT WITH (NOLOCK) ON CAV.[IdCustomAttribute] = CAT.[Id] AND CAT.[Deleted] = 0

		SELECT	POI.[Id], POI.[Name], POI.[Identifier], POI.[Address], POI.[IdDepartment], D.[Name] as DepartmentName, POI.[FatherId], POI.[GrandfatherId],
				POIH1.[Id] as POIHierarchyLevel1Id, POIH1.[Name] as POIHierarchyLevel1Name, POIH1.[SapId] as POIHierarchyLevel1SapId,
				POIH2.[Id] as POIHierarchyLevel2Id, POIH2.[Name] as POIHierarchyLevel2Name, POIH2.[SapId] as POIHierarchyLevel2SapId, POI.[ContactName], POI.[ContactPhoneNumber],
				CAV.[CustomAttributeName], CAV.[CustomAttributeId], CAV.[CustomAttributeValueType],
				CAV.[Value] AS CustomAttributeValue
		INTO	#PointOfInterest
		FROM	[dbo].[PointOfInterest] POI WITH (NOLOCK)
				LEFT JOIN [dbo].[Department] D WITH (NOLOCK) ON D.[Id] = POI.[IdDepartment]
				LEFT JOIN [dbo].[POIHierarchyLevel1] POIH1 WITH (NOLOCK) ON POIH1.[Id] = POI.[GrandfatherId]
				LEFT JOIN [dbo].[POIHierarchyLevel2] POIH2 WITH (NOLOCK) ON POIH2.[Id] = POI.[FatherId]
				LEFT JOIN #CustomAttributeWithValue CAV WITH (NOLOCK) ON CAV.[IdPointOfInterest] = POI.[Id]
		WHERE	(CASE WHEN @IdUserLocal IS NULL THEN 1 ELSE dbo.CheckUserInPointOfInterestZones(POI.[Id], @IdUserLocal) END) = 1
				AND (CASE WHEN @IdUserLocal IS NULL THEN 1 ELSE dbo.CheckDepartmentInUserDepartments(POI.[IdDepartment], @IdUserLocal) END) = 1

		SELECT	PEOI.[Id], PEOI.[Name], PEOI.[LastName], PEOI.[Identifier], PEOI.[MobilePhoneNumber], PEOI.[MobileIMEI]
		INTO	#PersonOfInterest
		FROM	[dbo].[PersonOfInterest] PEOI WITH (NOLOCK)
		WHERE	(CASE WHEN @IdUserLocal IS NULL THEN 1 ELSE dbo.CheckUserInPersonOfInterestZones(PEOI.[Id], @IdUserLocal) END) = 1
				AND (CASE WHEN @IdUserLocal IS NULL THEN 1 ELSE dbo.CheckDepartmentInUserDepartments(PEOI.[IdDepartment], @IdUserLocal) END) = 1

		SELECT	PCL.[Id] AS ProductCategoryListId, PCL.[IdProduct], PC.[Id] AS ProductCategoryId, PC.[Name] AS ProductCategoryName
		INTO	#ProductCategoryInfo
		FROM	[dbo].[ProductCategoryList] PCL WITH (NOLOCK)
				LEFT JOIN [dbo].[ProductCategory] PC WITH (NOLOCK) ON PCL.[IdProductCategory] = PC.[Id]
		WHERE	(CASE WHEN @ProductCategoriesIdLocal IS NULL THEN 1 ELSE dbo.CheckValueInList(PCL.[IdProductCategory], @ProductCategoriesIdLocal) END) = 1

		SELECT	P.[Id], P.[Identifier], P.[Name], P.[BarCode], P.[Indispensable],
				PB.[Id] AS BrandId, PB.[Identifier] AS BrandIdentifier, PB.[Name] AS BrandName,
				C.[Id] AS CompanyId, C.[Identifier] AS CompanyIdentifier, C.[Name] AS CompanyName
		INTO	#Products
		FROM	[dbo].[Product] P WITH (NOLOCK)
				LEFT JOIN [dbo].[ProductBrand] PB WITH (NOLOCK) ON P.IdProductBrand = PB.Id
				LEFT JOIN [dbo].[Company] C WITH (NOLOCK) ON PB.IdCompany = C.Id
				LEFT JOIN [dbo].[ProductCategoryList] PCL WITH (NOLOCK) ON PCL.[IdProduct] = P.[Id] --Temporal
				LEFT JOIN [dbo].[ProductCategory] PC WITH (NOLOCK) ON PCL.[IdProductCategory] = PC.[Id]--Temporal
		WHERE	(CASE WHEN @ProductBarCodesLocal IS NULL THEN 1 ELSE dbo.CheckVarcharInList(P.[BarCode], @ProductBarCodesLocal) END) = 1
				AND (CASE WHEN @IdUserLocal IS NULL THEN 1 ELSE dbo.CheckUserInProductCompanies(P.[IdProductBrand], @IdUserLocal) END) = 1
				AND (CASE WHEN @IdProductBrandLocal IS NULL THEN 1 ELSE dbo.CheckValueInList(IIF(PB.[Id] IS NULL, 0, PB.[Id]), @IdProductBrandLocal) END) = 1
				AND (CASE WHEN @IdCompanyLocal IS NULL THEN 1 ELSE dbo.CheckValueInList(IIF(C.[Id] IS NULL, 0, C.[Id]), @IdCompanyLocal) END) = 1
				AND (CASE WHEN @ProductCategoriesIdLocal IS NULL THEN 1 ELSE dbo.CheckValueInList(PCL.[IdProductCategory], @ProductCategoriesIdLocal) END) = 1--Temporal

		SELECT		PR.[Id], PR.[IdProduct] as ProductId, PR.[IdPersonOfInterest] as PersonOfInterestId, 
					PR.[IdPointOfInterest] AS PointOfInterestId, PR.[ReportDateTime], PR.[TheoricalStock], PR.[TheoricalPrice],
					P.[Identifier] AS ProductIdentifier, P.[Name] as ProductName, P.[BarCode] AS ProductBarCode, P.[Indispensable] AS ProductIndispensable,
					POI.[Name] AS PointOfInterestName, POI.[Identifier] AS PointOfInterestIdentifier, POI.[Address] AS PointOfInterestAddress,
					POI.[ContactName] AS PointOfInterestContactName,POI.[ContactPhoneNumber] AS PointOfInterestContactPhoneNumber,
					POI.[IdDepartment], POI.[DepartmentName],
					POI.[POIHierarchyLevel1Id], POI.[POIHierarchyLevel1Name], POI.[POIHierarchyLevel1SapId],
					POI.[POIHierarchyLevel2Id], POI.[POIHierarchyLevel2Name], POI.[POIHierarchyLevel2SapId],
					PEOI.[Name] as PersonOfInterestName, PEOI.[LastName] AS PersonOfInterestLastName, PEOI.[Identifier] AS PersonOfInterestIdentifier,
					PEOI.[MobilePhoneNumber] AS PersonOfInterestMobile, PEOI.[MobileIMEI] AS PersonOfInterestIMEI,
					POI.[CustomAttributeName], POI.[CustomAttributeId], POI.[CustomAttributeValueType],
					POI.[CustomAttributeValue],
					PR.[IdProductReportAttribute], PR.[ProductReportAttributeValue], PR.[IdProductReportAttributeValue],
					PR.[IdProductReportAttributeType], 
					PR.[ProductReportAttributeOption], PR.[ProductReportAttributeName],
					PR.[ProductReportAttributeImage], PR.[ProductReportAttributeImageUrl],
					PR.[ProductReportAttributeImageName],
					P.[BrandId], P.[BrandIdentifier], P.[BrandName],
					P.[CompanyId], P.[CompanyIdentifier], P.[CompanyName]
		INTO		#Data
		FROM		#Products P WITH (NOLOCK)
					INNER JOIN #ProductReportWithAttributes PR WITH (NOLOCK) ON P.[Id] = PR.[IdProduct]
					INNER JOIN #PersonOfInterest PEOI WITH (NOLOCK) ON PEOI.[Id] = PR.[IdPersonOfInterest]
					INNER JOIN #PointOfInterest POI WITH (NOLOCK) ON POI.[Id] = PR.[IdPointOfInterest]

		SELECT		[Id], [ProductId], [PersonOfInterestId], 
					[PointOfInterestId], [ReportDateTime], [TheoricalStock], [TheoricalPrice],
					[ProductIdentifier], [ProductName], [ProductBarCode], [ProductIndispensable],
					[PointOfInterestName], [PointOfInterestIdentifier], [PointOfInterestAddress],
					[PointOfInterestContactName], [PointOfInterestContactPhoneNumber],
					[IdDepartment], [DepartmentName],
					[POIHierarchyLevel1Id], [POIHierarchyLevel1Name], [POIHierarchyLevel1SapId],
					[POIHierarchyLevel2Id], [POIHierarchyLevel2Name], [POIHierarchyLevel2SapId],
					[PersonOfInterestName], [PersonOfInterestLastName], [PersonOfInterestIdentifier],
					[PersonOfInterestMobile], [PersonOfInterestIMEI],
					PCI.[ProductCategoryId], PCI.[ProductCategoryName],
					[CustomAttributeName], [CustomAttributeId], [CustomAttributeValueType],
					[CustomAttributeValue],
					[IdProductReportAttribute], [ProductReportAttributeValue], [IdProductReportAttributeValue],
					[IdProductReportAttributeType], 
					[ProductReportAttributeOption], [ProductReportAttributeName],
					[ProductReportAttributeImage], [ProductReportAttributeImageUrl],
					[ProductReportAttributeImageName],
					[BrandId], [BrandIdentifier], [BrandName],
					[CompanyId], [CompanyIdentifier], [CompanyName]
		FROM		#Data WITH (NOLOCK)
					--LEFT JOIN	#CustomAttributeWithValue CAV ON CAV.[IdPointOfInterest] = [PointOfInterestId]
					LEFT JOIN #ProductCategoryInfo PCI ON PCI.[IdProduct] = [ProductId]
		GROUP BY	[Id],
					[ProductId], [PersonOfInterestId], 
					[PointOfInterestId], [ReportDateTime], [TheoricalStock], [TheoricalPrice],
					[ProductIdentifier], [ProductName], [ProductBarCode], [ProductIndispensable],
					[PointOfInterestName], [PointOfInterestIdentifier], [PointOfInterestAddress],
					[PointOfInterestContactName], [PointOfInterestContactPhoneNumber],
					[IdDepartment], [DepartmentName],
					[POIHierarchyLevel1Id], [POIHierarchyLevel1Name], [POIHierarchyLevel1SapId],
					[POIHierarchyLevel2Id], [POIHierarchyLevel2Name], [POIHierarchyLevel2SapId],
					[PersonOfInterestName], [PersonOfInterestLastName], [PersonOfInterestIdentifier],
					[PersonOfInterestMobile], [PersonOfInterestIMEI],
					PCI.[ProductCategoryId], PCI.[ProductCategoryName],
					[CustomAttributeName], [CustomAttributeId], [CustomAttributeValueType],
					[CustomAttributeValue],
					[IdProductReportAttribute], [ProductReportAttributeValue], [IdProductReportAttributeValue],
					[IdProductReportAttributeType],
					[ProductReportAttributeOption], [ProductReportAttributeName],
					[ProductReportAttributeImage], [ProductReportAttributeImageUrl],
					[ProductReportAttributeImageName],
					[BrandId], [BrandIdentifier], [BrandName],
					[CompanyId], [CompanyIdentifier], [CompanyName],
					PCI.[ProductCategoryListId]
		ORDER BY	[ReportDateTime], [Id], PCI.[ProductCategoryListId]

		DROP TABLE #ProductReportWithAttributes
		DROP TABLE #PointOfInterest
		DROP TABLE #PersonOfInterest
		DROP TABLE #ProductCategoryInfo
		DROP TABLE #Products
		DROP TABLE #CustomAttributeWithValue
		DROP TABLE #Data

		-- OLD)
		--SELECT PR.[Id], PR.[IdProduct] as ProductId, PR.[IdPersonOfInterest] as PersonOfInterestId, 
		--	PR.[IdPointOfInterest] AS PointOfInterestId, PR.[ReportDateTime], PR.[TheoricalStock], PR.[TheoricalPrice],
		--	P.[Identifier] AS ProductIdentifier, P.[Name] as ProductName, P.[BarCode] AS ProductBarCode,
		--	POI.[Name] AS PointOfInterestName, POI.[Identifier] AS PointOfInterestIdentifier, POI.[Address] AS PointOfInterestAddress,
		--	D.[Id] AS IdDepartment, D.[Name] AS DepartmentName,
		--	POIH1.[Id] AS POIHierarchyLevel1Id, POIH1.[Name] AS POIHierarchyLevel1Name, POIH1.[SapId] AS POIHierarchyLevel1SapId,
		--	POIH2.[Id] AS POIHierarchyLevel2Id, POIH2.[Name] AS POIHierarchyLevel2Name, POIH2.[SapId] AS POIHierarchyLevel2SapId,
		--	PEOI.[Name] as PersonOfInterestName, PEOI.[LastName] AS PersonOfInterestLastName, PEOI.[Identifier] AS PersonOfInterestIdentifier,
		--	PEOI.[MobilePhoneNumber] AS PersonOfInterestMobile, PEOI.[MobileIMEI] AS PersonOfInterestIMEI,
		--	PC.[Id] AS ProductCategoryId, PC.[Name] AS ProductCategoryName,
		--	CA.[Name] AS CustomAttributeName, CA.[Id] AS CustomAttributeId, CA.[IdValueType] AS CustomAttributeValueType,
		--	CAV.[Value] AS CustomAttributeValue,
		--	PRAV.[IdProductReportAttribute], PRAV.[Value] AS ProductReportAttributeValue, PRAV.[Id] AS IdProductReportAttributeValue,
		--	PRAT.[IdType] AS IdProductReportAttributeType, 
		--	PRO.[Text] AS ProductReportAttributeOption,PRAT.[Name] AS ProductReportAttributeName,
		--	PRAV.[ImageEncoded] AS ProductReportAttributeImage, PRAV.[ImageUrl] AS ProductReportAttributeImageUrl,
		--	PRAV.[ImageName] AS ProductReportAttributeImageName
		--	,PB.[Id] AS BrandId, PB.[Identifier] AS BrandIdentifier, PB.[Name] AS BrandName
		--	,C.[Id] AS CompanyId, C.[Identifier] AS CompanyIdentifier, C.[Name] AS CompanyName
		--FROM	[dbo].[ProductReportDynamic] PR WITH (NOLOCK)
		--		INNER JOIN	[dbo].[Product] P WITH (NOLOCK) ON P.[Id] = PR.[IdProduct] 
		--		INNER JOIN	[dbo].[PointOfInterest] POI WITH (NOLOCK) ON POI.[Id] = PR.[IdPointOfInterest]
		--		INNER JOIN	[dbo].[PersonOfInterest] PEOI WITH (NOLOCK) ON PEOI.[Id] = PR.[IdPersonOfInterest]
		--		LEFT JOIN	[dbo].[ProductBrand] PB WITH(NOLOCK) ON P.IdProductBrand = PB.Id
		--		LEFT JOIN	[dbo].[Company] C WITH(NOLOCK) ON PB.IdCompany = C.Id
		--		LEFT JOIN	[dbo].[ProductCategoryList] PCL WITH (NOLOCK) ON PCL.[IdProduct] = P.[Id]
		--		LEFT JOIN	[dbo].[ProductCategory] PC WITH (NOLOCK) ON PCL.[IdProductCategory] = PC.[Id]
		--		LEFT JOIN	[dbo].[Department] D WITH (NOLOCK) ON D.[Id] = POI.[IdDepartment]
		--		LEFT JOIN	[dbo].[POIHierarchyLevel1] POIH1 WITH (NOLOCK) ON POIH1.[Id] = POI.[GrandfatherId]
		--		LEFT JOIN	[dbo].[POIHierarchyLevel2] POIH2 WITH (NOLOCK) ON POIH2.[Id] = POI.[FatherId]
		--		LEFT JOIN	[dbo].[CustomAttributeValue] CAV WITH (NOLOCK) ON CAV.[IdPointOfInterest] = POI.[Id]
		--		LEFT JOIN	[dbo].[CustomAttribute] CA WITH (NOLOCK) ON CAV.[IdCustomAttribute] = CA.[Id] AND CA.[Deleted] = 0
		--		LEFT JOIN   [dbo].[ProductReportAttributeValue] PRAV WITH (NOLOCK) ON PRAV.[IdProductReport] = PR.[Id]
		--		LEFT JOIN   [dbo].[ProductReportAttribute] PRAT WITH (NOLOCK) ON PRAT.[Id] = PRAV.[IdProductReportAttribute]
		--		LEFT JOIN   [dbo].[ProductReportAttributeOption] PRO WITH (NOLOCK) ON PRO.[Id] = PRAV.[IdProductReportAttributeOption]
		
		--WHERE	(pr.[ReportDateTime] BETWEEN @DateFromLocal AND @DateToLocal) AND	
		--	((@IdProductLocal IS NULL) OR dbo.CheckValueInList (PR.[IdProduct], @IdProductLocal)=1) AND
		--	((@IdPersonOfInterestLocal IS NULL) OR dbo.CheckValueInList (PR.[IdPersonOfinterest], @IdPersonOfInterestLocal) =1) AND
		--	((@IdPointOfInterestLocal IS NULL) OR dbo.CheckValueInList (PR.[IdPointOfInterest], @IdPointOfInterestLocal) =1) AND
		--	((@IdUserLocal IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(PEOI.[Id], @IdUserLocal) = 1)) AND
		--	((@IdUserLocal IS NULL) OR (dbo.CheckUserInPointOfInterestZones(POI.[Id], @IdUserLocal) = 1)) AND
		--	((@IdUserLocal IS NULL) OR (dbo.CheckDepartmentInUserDepartments(PEOI.[IdDepartment], @IdUserLocal) = 1)) AND
		--	((@IdUserLocal IS NULL) OR (dbo.CheckDepartmentInUserDepartments(POI.[IdDepartment], @IdUserLocal) = 1)) AND
		--	((@ProductBarCodesLocal IS NULL) OR (dbo.CheckVarcharInList(P.[BarCode], @ProductBarCodesLocal) = 1)) AND
		--	((@ProductCategoriesIdLocal IS NULL) OR (dbo.CheckValueInList(PCL.[IdProductCategory], @ProductCategoriesIdLocal) = 1))				
		--	AND (@IdProductBrandLocal IS NULL OR dbo.CheckValueInList(IIF(PB.[Id] IS NULL, 0, PB.[Id]), @IdProductBrandLocal) = 1)
		--	AND (@IdCompanyLocal IS NULL OR dbo.CheckValueInList(IIF(C.[Id] IS NULL, 0, C.[Id]), @IdCompanyLocal) = 1)
		--	AND ((@IdUserLocal IS NULL) OR (dbo.CheckUserInProductCompanies(P.[IdProductBrand], @IdUserLocal) = 1)) AND
		--	(PRAV.[Id] IS NULL OR PRAT.[FullDeleted] = 0)
		--GROUP BY PR.[Id], PR.[ReportDateTime], PCL.[Id] , PR.[IdProduct], PR.[IdPersonOfInterest], PR.[IdPointOfInterest], PR.[ReportDateTime], PR.[TheoricalStock], PR.[TheoricalPrice],
		--	P.[Identifier], P.[Name], P.[BarCode],POI.[Name], POI.[Identifier], POI.[Address],D.[Id], D.[Name],POIH1.[Id], POIH1.[Name], POIH1.[SapId],
		--	POIH2.[Id], POIH2.[Name], POIH2.[SapId],PEOI.[Name], PEOI.[LastName], PEOI.[Identifier],PEOI.[MobilePhoneNumber], PEOI.[MobileIMEI],PC.[Id], PC.[Name],
		--	CA.[Name], CA.[Id], CA.[IdValueType],CAV.[Value],PRAV.[IdProductReportAttribute], PRAV.[Value], PRAV.[Id],PRAT.[IdType], PRO.[Text],
		--	PRAV.[ImageEncoded], PRAV.[ImageUrl],PRAV.[ImageName],PRAT.[Name],PB.[Id], PB.[Identifier], PB.[Name],C.[Id], C.[Identifier], C.[Name]
		--ORDER BY PR.[ReportDateTime], PR.[Id], PCL.[Id]
	END
	ELSE
	BEGIN
		DECLARE @SqlQuery nvarchar(max)
		SET @SqlQuery = 
			N'SELECT PR.[Id], PR.[IdProduct] as ProductId, PR.[IdPersonOfInterest] as PersonOfInterestId, 
				PR.[IdPointOfInterest] AS PointOfInterestId, PR.[ReportDateTime], PR.[TheoricalStock], PR.[TheoricalPrice],
				P.[Identifier] AS ProductIdentifier, P.[Name] as ProductName, P.[BarCode] AS ProductBarCode,
				POI.[Name] AS PointOfInterestName, POI.[Identifier] AS PointOfInterestIdentifier, POI.[Address] AS PointOfInterestAddress,
				D.[Id] AS IdDepartment, D.[Name] AS DepartmentName,
				POIH1.[Id] AS POIHierarchyLevel1Id, POIH1.[Name] AS POIHierarchyLevel1Name, POIH1.[SapId] AS POIHierarchyLevel1SapId,
				POIH2.[Id] AS POIHierarchyLevel2Id, POIH2.[Name] AS POIHierarchyLevel2Name, POIH2.[SapId] AS POIHierarchyLevel2SapId,
				PEOI.[Name] as PersonOfInterestName, PEOI.[LastName] AS PersonOfInterestLastName, PEOI.[Identifier] AS PersonOfInterestIdentifier,
				PEOI.[MobilePhoneNumber] AS PersonOfInterestMobile, PEOI.[MobileIMEI] AS PersonOfInterestIMEI,
				PC.[Id] AS ProductCategoryId, PC.[Name] AS ProductCategoryName,
				CAT.[Name] AS CustomAttributeName, CAT.[Id] AS CustomAttributeId, CAT.[IdValueType] AS CustomAttributeValueType,
				CAV.[Value] AS CustomAttributeValue,
				PRAV.[IdProductReportAttribute], PRAV.[Value] AS ProductReportAttributeValue,
				PRAT.[IdType] AS IdProductReportAttributeType, 
				PRO.[Text] AS ProductReportAttributeOption,
				PRAV.[ImageEncoded] AS ProductReportAttributeImage, PRAV.[ImageUrl] AS ProductReportAttributeImageUrl,
				PRAV.[ImageName] AS ProductReportAttributeImageName
				,PB.[Id] AS BrandId, PB.[Identifier] AS BrandIdentifier, PB.[Name] AS BrandName
				,C.[Id] AS CompanyId, C.[Identifier] AS CompanyIdentifier, C.[Name] AS CompanyName
			FROM	[dbo].[ProductReportDynamic] PR WITH (NOLOCK)
					INNER JOIN	[dbo].[Product] P WITH (NOLOCK) ON P.[Id] = PR.[IdProduct] 
					INNER JOIN	[dbo].[PointOfInterest] POI WITH (NOLOCK) ON POI.[Id] = PR.[IdPointOfInterest]
					INNER JOIN	[dbo].[PersonOfInterest] PEOI WITH (NOLOCK) ON PEOI.[Id] = PR.[IdPersonOfInterest]
					LEFT JOIN	[dbo].[ProductBrand] PB WITH(NOLOCK) ON P.IdProductBrand = PB.Id
					LEFT JOIN	[dbo].[Company] C WITH(NOLOCK) ON PB.IdCompany = C.Id
					LEFT JOIN	[dbo].[ProductCategoryList] PCL WITH (NOLOCK) ON PCL.[IdProduct] = P.[Id]
					LEFT JOIN	[dbo].[ProductCategory] PC WITH (NOLOCK) ON PCL.[IdProductCategory] = PC.[Id]
					LEFT JOIN	[dbo].[Department] D WITH (NOLOCK) ON D.[Id] = POI.[IdDepartment]
					LEFT JOIN	[dbo].[POIHierarchyLevel1] POIH1 WITH (NOLOCK) ON POIH1.[Id] = POI.[GrandfatherId]
					LEFT JOIN	[dbo].[POIHierarchyLevel2] POIH2 WITH (NOLOCK) ON POIH2.[Id] = POI.[FatherId]
					LEFT JOIN	[dbo].[CustomAttributeValue] CAV WITH (NOLOCK) ON CAV.[IdPointOfInterest] = POI.[Id]
					LEFT JOIN	[dbo].[CustomAttributeTranslated] CAT WITH (NOLOCK) ON CAV.[IdCustomAttribute] = CAT.[Id] AND CAT.[Deleted] = 0
					LEFT JOIN   [dbo].[ProductReportAttributeValue] PRAV WITH (NOLOCK) ON PRAV.[IdProductReport] = PR.[Id]
					LEFT JOIN   [dbo].[ProductReportAttribute] PRAT WITH (NOLOCK) ON PRAT.[Id] = PRAV.[IdProductReportAttribute]
					LEFT JOIN   [dbo].[ProductReportAttributeOption] PRO WITH (NOLOCK) ON PRO.[IdProductReportAttribute] = PRAT.[Id]
		
			WHERE (pr.[ReportDateTime] BETWEEN @DateFrom AND @DateTo) AND	
				((@IdProduct IS NULL) OR dbo.CheckValueInList (PR.[IdProduct], @IdProduct)=1) AND
				((@IdPersonOfInterest IS NULL) OR dbo.CheckValueInList (PR.[IdPersonOfinterest], @IdPersonOfInterest) =1) AND
				((@IdPointOfInterest IS NULL) OR dbo.CheckValueInList (PR.[IdPointOfInterest], @IdPointOfInterest) =1) AND
				((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(PEOI.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(POI.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(PEOI.[IdDepartment], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(POI.[IdDepartment], @IdUser) = 1)) AND
				((@ProductBarCodes IS NULL) OR (dbo.CheckVarcharInList(P.[BarCode], @ProductBarCodes) = 1)) AND
				((@ProductCategoriesId IS NULL) OR (dbo.CheckValueInList(PCL.[IdProductCategory], @ProductCategoriesId) = 1)) 			
				AND (@IdProductBrand IS NULL OR dbo.CheckValueInList(IIF(PB.[Id] IS NULL, 0, PB.[Id]), @IdProductBrand) = 1)
				AND (@IdCompany IS NULL OR dbo.CheckValueInList(IIF(C.[Id] IS NULL, 0, C.[Id]), @IdCompany) = 1)
				AND ((@IdUser IS NULL) OR (dbo.CheckUserInProductCompanies(P.[IdProductBrand], @IdUser) = 1))
				AND ' + @ConditionQuery + '  

				GROUP BY PR.[Id], PR.[ReportDateTime], PCL.[Id] , PR.[IdProduct], PR.[IdPersonOfInterest], PR.[IdPointOfInterest], PR.[ReportDateTime], PR.[TheoricalStock], PR.[TheoricalPrice],
					P.[Identifier], P.[Name], P.[BarCode],POI.[Name], POI.[Identifier], POI.[Address],D.[Id], D.[Name],POIH1.[Id], POIH1.[Name], POIH1.[SapId],
					POIH2.[Id], POIH2.[Name], POIH2.[SapId],PEOI.[Name], PEOI.[LastName], PEOI.[Identifier],PEOI.[MobilePhoneNumber], PEOI.[MobileIMEI],PC.[Id], PC.[Name],
					CAT.[Name], CAT.[Id], CAT.[IdValueType],CAV.[Value],PRAV.[IdProductReportAttribute], PRAV.[Value], PRAV.[Id],PRAT.[IdType], PRO.[Text],
					PRAV.[ImageEncoded], PRAV.[ImageUrl],PRAV.[ImageName],PB.[Id], PB.[Identifier], PB.[Name],C.[Id], C.[Identifier], C.[Name]

				ORDER BY ReportDateTime, Id, PCL.[Id]'

		EXECUTE sp_executesql @SqlQuery, N'@DateFrom datetime,
							@DateTo datetime,
							@IdProduct varchar(max),
							@IdPersonOfInterest varchar(max),
							@IdPointOfInterest varchar(max),
							@IdUser [sys].INT = NULL,
							@ProductBarCodes [sys].[varchar](max) = NULL,
							@ProductCategoriesId [sys].[varchar](max) = NULL',
							@DateFrom = @DateFrom,
							@DateTo = @DateTo,
							@IdProduct = @IdProduct,
							@IdPersonOfInterest = @IdPersonOfInterest,
							@IdPointOfInterest = @IdPointOfInterest,
							@IdUser = @IdUser,
							@ProductBarCodes = @ProductBarCodes,
							@ProductCategoriesId = @ProductCategoriesId
	END
END
