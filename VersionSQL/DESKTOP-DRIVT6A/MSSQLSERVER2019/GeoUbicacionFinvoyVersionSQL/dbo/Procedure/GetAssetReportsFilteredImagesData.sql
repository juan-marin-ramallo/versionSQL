/****** Object:  Procedure [dbo].[GetAssetReportsFilteredImagesData]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 25/11/2021
-- Description:	SP para obtener los reportes de activos
--				únicamente con los atributos de tipo Cámara
-- =============================================
CREATE PROCEDURE [dbo].[GetAssetReportsFilteredImagesData]
	 @DateFrom [sys].[DATETIME] = NULL
	,@DateTo [sys].[DATETIME] = NULL
    ,@AssetName [sys].[VARCHAR](max) = NULL
	,@AssetBarCode [sys].[VARCHAR](max) = NULL
	,@AssetTypeIds [sys].[VARCHAR](max) = NULL
    ,@IdPointsOfInterest [sys].[VARCHAR](max) = NULL
    ,@IdPersonsOfInterest [sys].[VARCHAR](max) = NULL
	,@IdUser [sys].[INT] = NULL
AS 
BEGIN

	SELECT		AR.[Id], AR.[IdAsset] as AssetId, AR.[IdPersonOfInterest] as PersonOfInterestId, 
				AR.[IdPointOfInterest] as PointOfInterestId, AR.[Date] AS ReportDateTime,
				A.[Identifier] AS AssetIdentifier, A.[Name] AS AssetName, A.[BarCode] AS AssetBarCode, 
				POI.[Name] as PointOfInterestName, POI.[Identifier] AS PointOfInterestIdentifier,
				T.[Id] AS AssetTypeId, T.[Name] AS AssetTypeName,
				PEOI.[Name] as PersonOfInterestName, PEOI.[LastName] AS PersonOfInterestLastName,

				ARAV.[IdAssetReportAttribute], ARAV.[Value] AS AssetReportAttributeValue, ARAV.[Id] AS IdAssetReportAttributeValue,
				ARAV.[ImageEncoded] AS AssetReportAttributeImage,
				ARAV.[ImageUrl] AS AssetReportAttributeImageUrl,
				ARAV.[ImageName] AS AssetReportAttributeImageName,
				ARAT.[Id] AS IdAssetReportAttributeType,
				ARAV.[ImageEncoded] AS AssetReportAttributeImageArray, ARA.[Name] AS AssetReportAttributeName,
				C.[Id] as IdCompany, C.[Name] as CompanyName,
				A.[IdCategory], A.[IdSubCategory], AC1.[Name] AS CategoryName, AC2.[Name] AS SubCategoryName,
				AC1.[Identifier] AS CategoryIdentifier, AC2.[Identifier] AS SubCategoryIdentifier

	FROM		dbo.[AssetReportDynamic] AR
				INNER JOIN dbo.[Asset] A WITH (NOLOCK) ON A.[Id] = AR.[IdAsset]
				LEFT OUTER JOIN dbo.[AssetCategory] AC1 ON AC1.[Id] = A.[IdCategory]
				LEFT OUTER JOIN dbo.[AssetCategory] AC2 ON AC2.[Id] = A.[IdSubCategory]
				LEFT OUTER JOIN dbo.[AssetType] T WITH (NOLOCK) ON T.[Id] = A.[IdAssetType]
				INNER JOIN dbo.[PointOfInterest] POI WITH (NOLOCK) ON POI.[Id] = AR.[IdPointOfInterest]
				INNER JOIN dbo.[PersonOfInterest] PEOI WITH (NOLOCK) ON PEOI.[Id] = AR.[IdPersonOfInterest]
				INNER JOIN dbo.[AssetReportAttributeValue] ARAV WITH (NOLOCK) ON ARAV.[IdAssetReport] = AR.[Id]
				INNER JOIN dbo.[AssetReportAttribute] ARA WITH (NOLOCK) ON ARA.[Id] = ARAV.[IdAssetReportAttribute]
				INNER JOIN dbo.[AssetReportAttributeType] ARAT WITH (NOLOCK) ON ARAT.[Id] = ARA.[IdType] AND ARAT.[Id] = 1 -- Cámara
				LEFT OUTER JOIN dbo.[Company] C WITH (NOLOCK) ON C.[Id] = A.[IdCompany]

	WHERE		AR.[Date] BETWEEN @DateFrom AND @DateTo AND
				(ARAV.[ImageName] IS NOT NULL AND (ARAV.[ImageEncoded] IS NOT NULL OR ARAV.[ImageUrl] IS NOT NULL)) AND
				((@AssetName IS NULL) OR dbo.CheckVarcharInList (A.[Name], @AssetName) = 1)  AND
				((@AssetBarCode IS NULL) OR dbo.CheckVarcharInList (A.[BarCode], @AssetBarCode) = 1) AND
				((@AssetTypeIds IS NULL) OR dbo.CheckValueInList (A.[IdAssetType], @AssetTypeIds) = 1) AND
				((@IdPersonsOfInterest IS NULL) OR dbo.CheckValueInList (AR.[IdPersonOfinterest], @IdPersonsOfInterest)=1) AND
				((@IdPointsOfInterest IS NULL) OR dbo.CheckValueInList (AR.[IdPointOfInterest], @IdPointsOfInterest)=1) AND
				((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(PEOI.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(POI.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(PEOI.[IdDepartment], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(POI.[IdDepartment], @IdUser) = 1))
				AND (ARAV.[Id] IS NULL OR ARA.[Deleted] = 0)
				AND ((@IdUser IS NULL) OR (dbo.CheckUserInAssetCompanies(A.[IdCompany], @IdUser) = 1)) 
	
	ORDER BY	AR.[Date] desc
	
END
