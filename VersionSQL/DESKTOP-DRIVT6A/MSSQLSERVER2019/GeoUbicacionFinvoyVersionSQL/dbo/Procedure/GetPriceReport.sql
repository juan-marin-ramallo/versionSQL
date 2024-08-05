/****** Object:  Procedure [dbo].[GetPriceReport]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 04/08/2016
-- Description:	SP para obtener el reporte de faltantes, en base al inventario teórico
-- =============================================
CREATE PROCEDURE [dbo].[GetPriceReport]
(
	 @DateFrom [sys].[datetime]
	,@DateTo [sys].[datetime]
	,@IdProduct [sys].[varchar](max) = NULL
	,@IdPointOfInterest [sys].[varchar](max) = NULL
	,@IdPersonOfInterest [sys].[varchar](max) = NULL
	,@ProductBarCodes [sys].[varchar](max) = NULL
    ,@ProductCategoriesId [sys].[varchar](max) = NULL
	,@IdUser [sys].INT = NULL
)
AS
BEGIN

	DECLARE @DateFromTruncated [sys].[date]
	DECLARE @DateToTruncated [sys].[date]

	SET @DateFromTruncated = CAST(@DateFrom AS [sys].[date])
	SET @DateToTruncated = CAST(@DateTo AS [sys].[date])


	SELECT		PR.[Id], PR.[ReportDateTime] AS ReportDate, PR.[Price] AS RealPrice, PR.[Comment],
				PR.[IdPointOfInterest] AS PointOfInterestId, POI.[Name] AS PointOfInterestName, POI.[Identifier] AS PointOfInterestIdentifier,
				PR.[IdPersonOfInterest] AS PersonOfInterestId, S.[Name] AS PersonOfInterestName, S.[LastName] AS PersonOfInterestLastName,
				P.[Id] AS ProductId, P.[Name] AS ProductName, P.[Identifier] AS ProductIdentifier, P.[BarCode] AS ProductBarCode,
				PR.[TheoricalPrice], PC.[Id] AS ProductCategoryId, PC.[Name] AS ProductCategoryName

	FROM		dbo.[ProductReport] PR
				INNER JOIN [dbo].[Product] P ON P.[Id] = PR.[IdProduct]			
				INNER JOIN [dbo].[PointOfInterest] POI ON POI.[Id] = PR.[IdPointOfInterest]
				INNER JOIN [dbo].[PersonOfInterest] S ON S.[Id] = PR.[IdPersonOfInterest]
				LEFT JOIN	[dbo].[ProductCategoryList] PCL ON PCL.[IdProduct] = P.[Id]
				LEFT JOIN	[dbo].[ProductCategory] PC ON PCL.[IdProductCategory] = PC.[Id]

	WHERE		(CAST(PR.[ReportDateTime] AS [sys].[date]) BETWEEN @DateFromTruncated AND @DateToTruncated) AND
				((@IdPointOfInterest IS NULL) OR (dbo.CheckValueInList(POI.[Id], @IdPointOfInterest) = 1)) AND
				((@IdPersonOfInterest IS NULL) OR (dbo.CheckValueInList(S.[Id], @IdPersonOfInterest) = 1)) AND
				((@IdProduct IS NULL) OR (dbo.CheckValueInList(P.[Id], @IdProduct) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(POI.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(POI.[IdDepartment], @IdUser) = 1)) AND
				((@ProductBarCodes IS NULL) OR (dbo.CheckVarcharInList(P.[BarCode], @ProductBarCodes) = 1))
				AND PR.[Price] IS NOT NULL  AND
				((@ProductBarCodes IS NULL) OR (dbo.CheckVarcharInList(P.[BarCode], @ProductBarCodes) = 1)) AND
				((@ProductCategoriesId IS NULL) OR (dbo.CheckValueInList(PCL.[IdProductCategory], @ProductCategoriesId) = 1))

	ORDER BY	PR.[ReportDateTime] DESC
END
