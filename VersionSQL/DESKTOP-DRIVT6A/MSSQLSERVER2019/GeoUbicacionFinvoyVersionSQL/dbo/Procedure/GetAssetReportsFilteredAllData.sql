/****** Object:  Procedure [dbo].[GetAssetReportsFilteredAllData]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetAssetReportsFilteredAllData]
	 @DateFrom [sys].[DATETIME] = NULL
	,@DateTo [sys].[DATETIME] = NULL
	,@AssetNames [sys].[VARCHAR](max) = NULL
	,@AssetBarCode [sys].[VARCHAR](max) = NULL
	,@AssetTypeIds [sys].[VARCHAR](max) = NULL
    ,@IdPointsOfInterest [sys].[VARCHAR](max) = NULL
    ,@IdPersonsOfInterest [sys].[VARCHAR](max) = NULL
	,@IdUser [sys].[INT] = NULL
AS 
BEGIN

		DECLARE @DateFromLocal datetime = @DateFrom
		DECLARE @DateToLocal datetime = @DateTo
		DECLARE @IdPersonOfInterestLocal varchar(max) = @IdPersonsOfInterest
		DECLARE @IdPointOfInterestLocal varchar(max) = @IdPointsOfInterest
		DECLARE @AssetBarCodeLocal [sys].[varchar](max) = @AssetBarCode
		DECLARE @AssetTypeIdsLocal [sys].[varchar](max) = @AssetTypeIds
		DECLARE @IdUserLocal int = @IdUser
		DECLARE @AssetNamesLocal varchar(max) = @AssetNames

		CREATE TABLE #TempResultAssets
    ( 
		AssetId int,
		AssetIdentifier varchar(50), 
		AssetName varchar(100),
		AssetBarCode varchar(100),
		AssetTypeId int, 
		AssetTypeName varchar(50),
		CompanyId int, 
		CompanyIdentifier varchar(50), 
		CompanyName  varchar(50),
		IdCategory int,
		IdSubCategory int,
		CategoryName varchar(50),
		SubCategoryName varchar(50)
    );


	INSERT INTO #TempResultAssets(AssetId, AssetIdentifier, AssetName ,AssetBarCode,AssetTypeId , AssetTypeName ,CompanyId, CompanyIdentifier, CompanyName, IdCategory, IdSubCategory, CategoryName, SubCategoryName)
	
	SELECT  A.[Id], A.[Identifier], A.[Name], A.[BarCode], A.[IdAssetType], ATY.[Name], A.[IdCompany], C.[Identifier], C.[Name],
			A.[IdCategory], A.[IdSubCategory], AC1.[Name] AS CategoryName, AC2.[Name] AS SubCategoryName

	FROM	[dbo].[Asset] A WITH (NOLOCK)
			LEFT JOIN [dbo].[AssetType] ATY WITH (NOLOCK) ON A.[IdAssetType] = ATY.[Id] 
			LEFT JOIN [dbo].[Company] C WITH (NOLOCK) ON C.[Id] = A.[IdCompany] 
			LEFT JOIN dbo.[AssetCategory] AC1 ON AC1.[Id] = A.[IdCategory]
			LEFT JOIN dbo.[AssetCategory] AC2 ON AC2.[Id] = A.[IdSubCategory]

	WHERE	((@AssetNamesLocal IS NULL) OR dbo.CheckVarcharInList (A.[Name], @AssetNamesLocal)=1) AND
			((@AssetBarCodeLocal IS NULL) OR (dbo.CheckVarcharInList(A.BarCode, @AssetBarCodeLocal) = 1))
			AND (@AssetTypeIdsLocal IS NULL OR dbo.CheckValueInList(IIF(A.[IdAssetType] IS NULL, 0, A.[IdAssetType]), @AssetTypeIdsLocal) = 1)
			AND ((@IdUserLocal IS NULL) OR (dbo.CheckUserInAssetCompanies(A.IdCompany, @IdUserLocal) = 1))
	
	CREATE TABLE #TempResultAssetReportDynamic
    ( 
		AssetReportId int, 
		AssetId int, 
		PersonOfInterestId int, 
		PointOfInterestId int,
		ReportDateTime datetime

    );

	INSERT INTO #TempResultAssetReportDynamic(AssetReportId, AssetId, PersonOfInterestId, PointOfInterestId,ReportDateTime)
	
	SELECT  PR.[Id], PR.[IdAsset] as AssetId, PR.[IdPersonOfInterest] as PersonOfInterestId, 
			PR.[IdPointOfInterest] AS PointOfInterestId, PR.[Date]
	FROM   [dbo].[AssetReportDynamic] PR WITH (NOLOCK)

	WHERE 	(pr.[Date] BETWEEN @DateFromLocal AND @DateToLocal) AND
			((@IdPersonOfInterestLocal IS NULL) OR dbo.CheckValueInList (PR.[IdPersonOfinterest], @IdPersonOfInterestLocal) =1) AND
			((@IdPointOfInterestLocal IS NULL) OR dbo.CheckValueInList (PR.[IdPointOfInterest], @IdPointOfInterestLocal) =1) AND
			((@IdUserLocal IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(PR.[IdPersonOfinterest], @IdUserLocal) = 1)) AND
			((@IdUserLocal IS NULL) OR (dbo.CheckUserInPointOfInterestZones(PR.[IdPointOfInterest], @IdUserLocal) = 1))

	CREATE TABLE #TempResultAssetReport
    ( 
		AssetReportId int, 
		AssetId int, 
		PersonOfInterestId int, 
		PointOfInterestId int,
		ReportDateTime datetime,
		IdAssetReportAttribute int, 
		AssetReportAttributeValue varchar(max), 
		IdAssetReportAttributeValue int,
		IdAssetReportAttributeType int, 
		AssetReportAttributeOption varchar(100),
		AssetReportAttributeName varchar(100), 
		AssetReportAttributeImageUrl varchar(5000),
		AssetReportAttributeImageName  varchar(100)
    );

		CREATE TABLE #TempResultPointOfInterest
    ( 
		PointOfInterestId int ,
		PointOfInterestName varchar(100), 
		PointOfInterestIdentifier varchar (50), 
		PointOfInterestAddress varchar (250),
		IdDepartment int,
		DepartmentName  varchar (50),
		POIHierarchyLevel1Id int, 
		POIHierarchyLevel1Name varchar (100), 
		POIHierarchyLevel1SapId  varchar (100), 
		POIHierarchyLevel2Id int, 
		POIHierarchyLevel2Name  varchar (100), 
		POIHierarchyLevel2SapId  varchar (100),
		CustomAttributeName  varchar (100), 
		CustomAttributeId int, 
		CustomAttributeValueType int,
		CustomAttributeValue  varchar(max),
		PointOfInterestContactName varchar (50),
		PointOfInterestContactPhoneNumber varchar (50)
    );

	CREATE TABLE #TempResultPersonOfInterest
    ( 
		PersonOfInterestId int ,
		PersonOfInterestName varchar(50), PersonOfInterestLastName varchar(50), PersonOfInterestIdentifier varchar(20),
		PersonOfInterestMobile varchar(20),PersonOfInterestIMEI varchar(40)
    );

	INSERT INTO #TempResultAssetReport(AssetReportId, AssetId, 
				PersonOfInterestId, PointOfInterestId,ReportDateTime,IdAssetReportAttribute , AssetReportAttributeValue, 
				IdAssetReportAttributeValue,IdAssetReportAttributeType, AssetReportAttributeOption,AssetReportAttributeName, AssetReportAttributeImageUrl,
				AssetReportAttributeImageName)
	
	SELECT  PR.AssetReportId, PR.AssetId, PR.PersonOfInterestId, 
			PR.PointOfInterestId, PR.[ReportDateTime],
			PRAV.[IdAssetReportAttribute], PRAV.[Value] AS AssetReportAttributeValue, PRAV.[Id] AS IdAssetReportAttributeValue,
			PRAT.[IdType] AS IdAssetReportAttributeType, 
			PRO.[Text] AS AssetReportAttributeOption,PRAT.[Name] AS AssetReportAttributeName
			, PRAV.[ImageUrl] AS AssetReportAttributeImageUrl,
			PRAV.[ImageName] AS AssetReportAttributeImageName
	FROM   #TempResultAssetReportDynamic PR WITH (NOLOCK)
			LEFT JOIN   [dbo].[AssetReportAttributeValue] PRAV WITH (NOLOCK) ON PRAV.[IdAssetReport] = PR.AssetReportId
			LEFT JOIN   [dbo].[AssetReportAttribute] PRAT WITH (NOLOCK) ON PRAT.[Id] = PRAV.[IdAssetReportAttribute]
			LEFT JOIN   [dbo].[AssetReportAttributeOption] PRO WITH (NOLOCK) ON PRO.[Id] = PRAV.[IdAssetReportAttributeOption]

	WHERE 	(PRAV.[Id] IS NULL OR PRAT.[Deleted] = 0)

	
	INSERT INTO #TempResultPointOfInterest(PointOfInterestId ,PointOfInterestName, PointOfInterestIdentifier, POI.PointOfInterestAddress ,IdDepartment,
				DepartmentName ,POIHierarchyLevel1Id , POIHierarchyLevel1Name , POIHierarchyLevel1SapId , POIHierarchyLevel2Id , POIHierarchyLevel2Name  , 
				POIHierarchyLevel2SapId  ,CustomAttributeName, CustomAttributeId , CustomAttributeValueType ,CustomAttributeValue,PointOfInterestContactName,
			PointOfInterestContactPhoneNumber)	
	SELECT POI.[PointOfInterestId],POI.PointOfInterestName, POI.PointOfInterestIdentifier, POI.PointOfInterestAddress,
			POI.IdDepartment,POI.DepartmentName,POI.POIHierarchyLevel1Id, POI.POIHierarchyLevel1Name, POI.POIHierarchyLevel1SapId, POI.POIHierarchyLevel2Id, 
			POI.POIHierarchyLevel2Name, POI.POIHierarchyLevel2SapId,POI.CustomAttributeName, POI.CustomAttributeId, 
			POI.CustomAttributeValueType,POI.CustomAttributeValue, POI.PointOfInterestContactName, POI.PointOfInterestContactPhoneNumber
	FROM    [dbo].[PointOfInterestInfo] POI WITH (NOLOCK)

	WHERE 	((@IdUserLocal IS NULL) OR (dbo.CheckDepartmentInUserDepartments(POI.[IdDepartment], @IdUserLocal) = 1))

	INSERT INTO #TempResultPersonOfInterest(PersonOfInterestId ,
				PersonOfInterestName, PersonOfInterestLastName, PersonOfInterestIdentifier, PersonOfInterestMobile ,PersonOfInterestIMEI)
	SELECT  PEOI.Id, PEOI.[Name], PEOI.[LastName], PEOI.[Identifier] ,
			PEOI.[MobilePhoneNumber] , PEOI.[MobileIMEI] 
	FROM	[dbo].[PersonOfInterest] PEOI WITH (NOLOCK)

	WHERE 	((@IdUserLocal IS NULL) OR (dbo.CheckDepartmentInUserDepartments(PEOI.[IdDepartment], @IdUserLocal) = 1)) 
	
	SELECT *, NULL AssetReportAttributeImage
	FROM #TempResultAssetReport
	ORDER BY [ReportDateTime] ASC, [AssetReportId]

	SELECT *, NULL AssetReportAttributeImage
	FROM #TempResultAssets

	SELECT *
	FROM #TempResultPointOfInterest

	SELECT * 
	FROM #TempResultPersonOfInterest


	--SELECT		AR.[Id], AR.[IdAsset] as AssetId, AR.[IdPersonOfInterest] as PersonOfInterestId, 
	--			AR.[IdPointOfInterest] as PointOfInterestId, AR.[Date] AS ReportDateTime,
	--			A.[Identifier] AS AssetIdentifier, A.[Name] AS AssetName, A.[BarCode] AS AssetBarCode, 
	--			POI.[Name] as PointOfInterestName, POI.[Identifier] AS PointOfInterestIdentifier,
	--			T.[Id] AS AssetTypeId, T.[Name] AS AssetTypeName,
	--			PEOI.[Name] as PersonOfInterestName, PEOI.[LastName] AS PersonOfInterestLastName,

	--			ARAV.[IdAssetReportAttribute], ARAV.[Value] AS AssetReportAttributeValue, ARAV.[Id] AS IdAssetReportAttributeValue,
	--			ARAO.[Text] AS AssetReportAttributeOption,
	--			ARAV.[ImageEncoded] AS AssetReportAttributeImage,
	--			ARAV.[ImageUrl] AS AssetReportAttributeImageUrl,
	--			ARAV.[ImageName] AS AssetReportAttributeImageName,
	--			ARAT.[Id] AS IdAssetReportAttributeType,
	--			ARAV.[ImageEncoded] AS AssetReportAttributeImageArray, ARA.[Name] AS AssetReportAttributeName,
	--			C.[Id] as IdCompany, C.[Name] as CompanyName

	--FROM		dbo.[AssetReportDynamic] AR
	--			LEFT JOIN dbo.[Asset] A WITH (NOLOCK) ON A.[Id] = AR.[IdAsset]
	--			LEFT JOIN dbo.[AssetType] T WITH (NOLOCK) ON T.[Id] = A.[IdAssetType]
	--			LEFT JOIN dbo.[PointOfInterest] POI WITH (NOLOCK) ON POI.[Id] = AR.[IdPointOfInterest]
	--			LEFT JOIN dbo.[PersonOfInterest] PEOI WITH (NOLOCK) ON PEOI.[Id] = AR.[IdPersonOfInterest]
	--			LEFT JOIN dbo.[AssetReportAttributeValue] ARAV WITH (NOLOCK) ON ARAV.[IdAssetReport] = AR.[Id]
	--			LEFT JOIN dbo.[AssetReportAttribute] ARA WITH (NOLOCK) ON ARA.[Id] = ARAV.[IdAssetReportAttribute]
	--			LEFT JOIN dbo.[AssetReportAttributeOption] ARAO WITH (NOLOCK) ON ARAO.[Id] = ARAV.[IdAssetReportAttributeOption]
	--			LEFT JOIN dbo.[AssetReportAttributeType] ARAT WITH (NOLOCK) ON ARAT.[Id] = ARA.[IdType]
	--			LEFT JOIN dbo.[Company] C WITH (NOLOCK) ON C.[Id] = A.[IdCompany]

	--WHERE		AR.[Date] BETWEEN @DateFrom AND @DateTo AND
	--			((@AssetName IS NULL) OR dbo.CheckVarcharInList (A.[Name], @AssetName) = 1)  AND
	--			((@AssetBarCode IS NULL) OR dbo.CheckVarcharInList (A.[BarCode], @AssetBarCode) = 1) AND
	--			((@AssetTypeIds IS NULL) OR dbo.CheckValueInList (A.[IdAssetType], @AssetTypeIds) = 1) AND
	--			((@IdPersonsOfInterest IS NULL) OR dbo.CheckValueInList (AR.[IdPersonOfinterest], @IdPersonsOfInterest)=1) AND
	--			((@IdPointsOfInterest IS NULL) OR dbo.CheckValueInList (AR.[IdPointOfInterest], @IdPointsOfInterest)=1) AND
	--			((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(PEOI.[Id], @IdUser) = 1)) AND
	--			((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(POI.[Id], @IdUser) = 1)) AND
	--			((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(PEOI.[IdDepartment], @IdUser) = 1)) AND
	--			((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(POI.[IdDepartment], @IdUser) = 1))
	--			AND (ARAV.[Id] IS NULL OR ARA.[Deleted] = 0)
	--			AND ((@IdUser IS NULL) OR (dbo.CheckUserInAssetCompanies(A.[IdCompany], @IdUser) = 1)) 
	
	--ORDER BY	AR.[Date] desc
	
END
