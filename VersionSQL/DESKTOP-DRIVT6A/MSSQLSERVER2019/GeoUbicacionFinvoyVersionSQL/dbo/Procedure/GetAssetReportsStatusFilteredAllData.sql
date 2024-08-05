/****** Object:  Procedure [dbo].[GetAssetReportsStatusFilteredAllData]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author: Cbarbarini
-- Create date: 06/12/2021
-- Description: SP para obtener los activos contratados
-- =============================================
CREATE PROCEDURE [dbo].[GetAssetReportsStatusFilteredAllData]
	 @DateFrom DATETIME = NULL
	,@DateTo DATETIME = NULL
	,@AssetNames VARCHAR(MAX) = NULL
	,@AssetBarCode VARCHAR(MAX) = NULL
	,@AssetTypeIds VARCHAR(MAX) = NULL
	,@IdPointsOfInterest VARCHAR(MAX) = NULL
	,@IdPersonsOfInterest VARCHAR(MAX) = NULL
	,@IdUser INT = NULL
AS
BEGIN
	;WITH AssetReportDynamicLastDate(Id, IdAsset, Date, IdPointOfInterest, IdPersonOfInterest) AS
	(
		SELECT MAX(ard.Id) AS Id, ard.IdAsset, MAX(ard.Date) AS Date, MAX(ard.IdPointOfInterest), MAX(ard.IdPersonOfInterest)
		FROM AssetReportDynamic (NOLOCK) ard  
		WHERE ard.Date BETWEEN @DateFrom AND @DateTo -- Filtro por rango de fecha  
		GROUP BY ard.IdAsset, ard.IdPointOfInterest, ard.IdPersonOfInterest
	),
	PointOfInterestWithOwnAsset(IdPointOfInterest, NamePointOfInterest, IdAsset, NameAsset, BarCodeAsset, IdAssetType, IdCompany, CompanyName, GrandfatherId, FatherId) AS
	( -- Contratados
		SELECT poi.Id AS IdPointOfInterest, poi.Name AS NamePointOfInterest, a.Id AS IdAsset, a.Name AS NameAsset, a.BarCode AS BarCodeAsset, a.IdAssetType, c.Id AS IdCompany, c.Name AS CompanyName, poi.GrandfatherId, poi.FatherId
		FROM PointOfInterest (NOLOCK) poi
		INNER JOIN AssetPointOfInterest (NOLOCK) apoi ON poi.Id = apoi.IdPointOfInterest
		INNER JOIN Asset (NOLOCK) a ON apoi.IdAsset = a.Id AND a.Deleted = 0
		INNER JOIN Company (NOLOCK) c ON a.IdCompany = c.Id AND c.Deleted = 0 AND c.IsMain = 1 -- Compañia propia
		WHERE poi.Deleted = 0 
			AND (  (apoi.DateTo IS NULL AND apoi.DateFrom <= @DateTo)
				OR (apoi.DateTo IS NOT NULL AND apoi.DateTo >= @DateFrom AND (apoi.DateFrom < @DateFrom OR apoi.DateFrom between @DateFrom AND @DateTo))
				)
	)
	SELECT DISTINCT poiwoa.IdAsset AS Id
		, poiwoa.NameAsset AS Name
		, at.Name AS Type
		, arap.Text AS Status
		, poiwoa.CompanyName AS Company
		, poiwoa.IdPointOfInterest AS IdPointOfInterest
		, poiwoa.NamePointOfInterest AS PointOfInterestName
		, ISNULL(arav.Value, 0) AS Present
		, ardld2.IdPersonOfinterest
		, phl1.Name AS Hierarchy1
		, phl2.Name AS Hierarchy2
		, ardld2.Id AS IdAssetReportDynamic
	FROM PointOfInterestWithOwnAsset poiwoa WITH (NOLOCK)
	INNER JOIN AssetReportDynamicLastDate ardld WITH (NOLOCK) ON poiwoa.IdPointOfInterest = ardld.IdPointOfInterest
	LEFT JOIN AssetReportDynamicLastDate ardld2 WITH (NOLOCK) ON poiwoa.IdAsset = ardld2.IdAsset AND poiwoa.IdPointOfInterest = ardld2.IdPointOfInterest
	LEFT JOIN AssetReportAttributeValue (NOLOCK) arav ON ardld2.Id = arav.IdAssetReport AND arav.IdAssetReportAttribute = 1000 AND arav.Value = '1' AND poiwoa.IdPointOfInterest = ardld2.IdPointOfInterest -- Esta presente
	LEFT JOIN AssetReportAttributeValue (NOLOCK) arav2 ON ardld2.Id = arav2.IdAssetReport AND arav2.IdAssetReportAttribute = 1001 -- Tiene estado?
	LEFT JOIN AssetReportAttributeOption (NOLOCK) arap ON arav2.IdAssetReportAttributeOption = arap.Id AND arap.Deleted = 0 -- Cual es el estado?
	LEFT JOIN AssetType (NOLOCK) at ON poiwoa.IdAssetType = at.Id AND at.Deleted = 0
	LEFT JOIN POIHierarchyLevel1 (NOLOCK) phl1 ON poiwoa.GrandfatherId = phl1.Id
	LEFT JOIN POIHierarchyLevel2 (NOLOCK) phl2 ON poiwoa.FatherId = phl2.Id
	WHERE ((@IdUser IS NULL) OR (dbo.CheckUserInAssetCompanies(poiwoa.IdCompany, @IdUser) = 1))
		AND ((@AssetNames IS NULL) OR dbo.CheckVarcharInList (poiwoa.NameAsset, @AssetNames) = 1) -- Filtro por nombre de activo
		AND ((@AssetBarCode IS NULL) OR (dbo.CheckVarcharInList(poiwoa.BarCodeAsset, @AssetBarCode) = 1)) -- Filtro por código de barra
		AND (@AssetTypeIds IS NULL OR dbo.CheckValueInList(IIF(poiwoa.IdAssetType IS NULL, 0, poiwoa.IdAssetType), @AssetTypeIds) = 1) -- Filtro por tipo de activo
		AND ((@IdPointsOfInterest IS NULL) OR dbo.CheckValueInList (poiwoa.IdPointOfInterest, @IdPointsOfInterest) = 1) -- Filtro por punto de interes
		AND ((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(poiwoa.IdPointOfInterest, @IdUser) = 1))
		AND ((@IdPersonsOfInterest IS NULL) OR dbo.CheckValueInList (ardld2.IdPersonOfinterest, @IdPersonsOfInterest) = 1) -- Filtro por persona de interes
		AND ((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(ardld2.IdPersonOfinterest, @IdUser) = 1))
	ORDER BY poiwoa.NamePointOfInterest
END
