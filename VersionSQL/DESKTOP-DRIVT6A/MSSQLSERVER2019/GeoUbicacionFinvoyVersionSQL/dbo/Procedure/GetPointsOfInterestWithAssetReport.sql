/****** Object:  Procedure [dbo].[GetPointsOfInterestWithAssetReport]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetPointsOfInterestWithAssetReport]
	@DateFrom [sys].[DATETIME] = NULL,
	@DateTo [sys].[DATETIME] = NULL,
    @AssetName [sys].[VARCHAR](max) = NULL,
	@AssetBarCode [sys].[VARCHAR](max) = NULL,
	@AssetTypeIds [sys].[VARCHAR](max) = NULL,
    @IdPointsOfInterest [sys].[VARCHAR](max) = NULL,
    @IdPersonsOfInterest [sys].[VARCHAR](max) = NULL,
	@IdUser [sys].[INT] = NULL
AS 
BEGIN

	SELECT		P.[Id], P.[Name], 
				P.[Address], P.[Latitude], P.[Longitude], P.[Radius], P.[MinElapsedTimeForVisit], P.[IdDepartment],
				P.[Identifier]
	
	FROM		dbo.[AssetReportDynamic] AR
				INNER JOIN [dbo].[PointOfInterest] P ON P.[Id] = AR.[IdPointOfInterest]
				INNER JOIN dbo.[Asset] A ON A.[Id] = AR.[IdAsset]
				LEFT JOIN dbo.PersonOfInterest PEOI ON PEOI.[Id] = AR.[IdPersonOfInterest]
	
	WHERE		AR.[Date] BETWEEN @DateFrom AND @DateTo AND
				((@AssetName IS NULL) OR dbo.CheckVarcharInList (A.[Name], @AssetName) = 1)  AND
				((@AssetBarCode IS NULL) OR dbo.CheckVarcharInList (A.[BarCode], @AssetBarCode) = 1) AND
				((@AssetTypeIds IS NULL) OR dbo.CheckValueInList (A.[IdAssetType], @AssetTypeIds) = 1) AND
				((@IdPersonsOfInterest IS NULL) OR dbo.CheckValueInList (AR.[IdPersonOfinterest], @IdPersonsOfInterest)=1) AND
				((@IdPointsOfInterest IS NULL) OR dbo.CheckValueInList (AR.[IdPointOfInterest], @IdPointsOfInterest)=1) AND
				((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(PEOI.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(PEOI.[IdDepartment], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1))
				AND ((@IdUser IS NULL) OR (dbo.CheckUserInAssetCompanies(A.[IdCompany], @IdUser) = 1)) 
	
	GROUP BY	P.[Id], P.[Name], 
				P.[Address], P.[Latitude], P.[Longitude], P.[Radius], P.[MinElapsedTimeForVisit], P.[IdDepartment],
				P.[Identifier]
	
END
