/****** Object:  Procedure [dbo].[GetAssetReportsFiltered]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetAssetReportsFiltered]
	@DateFrom [sys].[DATETIME] = NULL,
	@DateTo [sys].[DATETIME] = NULL,
    @AssetName [sys].[VARCHAR](max) = NULL,
	@AssetBarCode [sys].[VARCHAR](max) = NULL,
	@AssetTypeIds [sys].[VARCHAR](max) = NULL,
    @IdPointsOfInterest [sys].[VARCHAR](max) = NULL,
    @IdPersonsOfInterest [sys].[VARCHAR](max)=null,
	@IdUser [sys].[INT] = NULL
AS 
BEGIN

	SELECT		AR.[Id], AR.[IdAsset] as AssetId, AR.[IdPersonOfInterest] as PersonOfInterestId, 
				AR.[IdPointOfInterest] as PointOfInterestId, AR.[Date] AS ReportDateTime,
				A.[Identifier] AS AssetIdentifier, A.[Name] AS AssetName, A.[BarCode] AS AssetBarCode, 
				POI.[Name] as PointOfInterestName, POI.[Identifier] AS PointOfInterestIdentifier,
				T.[Id] AS AssetTypeId, T.[Name] AS AssetTypeName,
				PEOI.[Name] as PersonOfInterestName, PEOI.[LastName] AS PersonOfInterestLastName,

				ARAV.[IdAssetReportAttribute], ARAV.[Value] AS AssetReportAttributeValue, ARAV.[Id] AS IdAssetReportAttributeValue,
				ARAO.[Text] AS AssetReportAttributeOption,
				--(CASE WHEN ARAV.[ImageEncoded] IS NULL AND ARAV.[ImageUrl] IS NULL THEN 0 ELSE 1 END) AS AssetReportAttributeImage,
				ARAV.[ImageUrl] AS AssetReportAttributeImageUrl,
				ARAV.[ImageName] AS AssetReportAttributeImageName,
				ARAT.[Id] AS IdAssetReportAttributeType, ARA.[Name] AS AssetReportAttributeName

	FROM		dbo.[AssetReportDynamic] AR
				LEFT JOIN dbo.[Asset] A ON A.[Id] = AR.[IdAsset]
				LEFT JOIN dbo.[AssetType] T ON T.[Id] = A.[IdAssetType]
				LEFT JOIN dbo.[PointOfInterest] POI ON POI.[Id] = AR.[IdPointOfInterest]
				LEFT JOIN dbo.[PersonOfInterest] PEOI ON PEOI.[Id] = AR.[IdPersonOfInterest]
				LEFT JOIN dbo.[AssetReportAttributeValue] ARAV ON ARAV.[IdAssetReport] = AR.[Id]
				LEFT JOIN dbo.[AssetReportAttribute] ARA ON ARA.[Id] = ARAV.[IdAssetReportAttribute]
				LEFT JOIN dbo.[AssetReportAttributeOption] ARAO ON ARAO.[Id] = ARAV.[IdAssetReportAttributeOption]
				LEFT JOIN dbo.[AssetReportAttributeType] ARAT ON ARAT.[Id] = ARA.[IdType]

	WHERE		AR.[Date] BETWEEN @DateFrom AND @DateTo AND
				((@AssetName IS NULL) OR dbo.CheckVarcharInList (A.[Name], @AssetName) = 1)  AND
				((@AssetBarCode IS NULL) OR dbo.CheckVarcharInList (A.[BarCode], @AssetBarCode) = 1) AND
				((@AssetTypeIds IS NULL) OR dbo.CheckValueInList (A.[IdAssetType], @AssetTypeIds) = 1) AND
				((@IdPersonsOfInterest IS NULL) OR dbo.CheckValueInList (AR.[IdPersonOfinterest], @IdPersonsOfInterest) = 1) AND
				((@IdPointsOfInterest IS NULL) OR dbo.CheckValueInList (AR.[IdPointOfInterest], @IdPointsOfInterest) = 1) AND
				((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(PEOI.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(POI.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(PEOI.[IdDepartment], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(POI.[IdDepartment], @IdUser) = 1))
				AND (ARAV.[Id] IS NULL OR ARA.[Deleted] = 0) 
				AND ((@IdUser IS NULL) OR (dbo.CheckUserInAssetCompanies(A.[IdCompany], @IdUser) = 1)) 
	
	ORDER BY	AR.[Date] desc
	
END
