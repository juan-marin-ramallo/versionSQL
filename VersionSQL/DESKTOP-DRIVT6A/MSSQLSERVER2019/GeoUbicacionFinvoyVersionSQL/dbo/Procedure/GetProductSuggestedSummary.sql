/****** Object:  Procedure [dbo].[GetProductSuggestedSummary]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 25/11/2017
-- Description:	SP para obtener el resumen de sugeridos de stock
-- =============================================
CREATE PROCEDURE [dbo].[GetProductSuggestedSummary]
(
	 @IdUser [sys].INT = NULL
)
AS
BEGIN
	DECLARE @DateFrom [sys].[datetime] = Tzdb.ToUtc((select DATEADD(HOUR , DATEPART(HOUR, convert(time, value)), DATEADD(minute, DATEPART(minute, convert(time, value)), convert(datetime, convert(date, DATEADD(day, -1, Tzdb.FromUtc(GETUTCDATE())))))) from ConfigurationTranslated WITH (NOLOCK) where id = 23))
	DECLARE @DateTo [sys].[datetime] = Tzdb.ToUtc((select DATEADD(HOUR , DATEPART(HOUR, convert(time, value)), DATEADD(minute, DATEPART(minute, convert(time, value)), convert(datetime, convert(date, Tzdb.FromUtc(GETUTCDATE()))))) from ConfigurationTranslated WITH (NOLOCK) where id = 23))

	SELECT		PR.[Id], PR.[ReportDateTime] AS ProductSuggestedDate, PR.[Suggested] as Quantity, PR.[Comment] AS Comment,
				PR.[IdPointOfInterest] AS PointOfInterestId, POI.[Name] AS PointOfInterestName, 
				POI.[Identifier] AS PointOfInterestIdentifier, POI.[Address] AS PointOfInterestAddress,
				PR.[IdPersonOfInterest] AS PersonOfInterestId, S.[Name] AS PersonOfInterestName, 
				S.[LastName] AS PersonOfInterestLastName, S.[Identifier] AS PersonOfInterestIdentifier,
				P.[Id] AS ProductId, P.[Name] AS ProductName, P.[BarCode], P.[Identifier] AS ProductIdentifier,
				PC.Id AS ProductCategoryId, PC.Name AS ProductCategoryName

	FROM		[dbo].[ProductReport] PR
				INNER JOIN [dbo].[PersonOfInterest] S ON S.[Id]= PR.[IdPersonOfInterest]
				INNER JOIN [dbo].[PointOfInterest] POI ON POI.[Id] = PR.[IdPointOfInterest]
				INNER JOIN [dbo].[Product] P ON P.[Id] = PR.[IdProduct]
				LEFT JOIN [dbo].[ProductCategoryList] PCL ON PCL.[IdProduct] = P.[Id]
				LEFT JOIN [dbo].[ProductCategory] PC ON PCL.[IdProductCategory] = PC.[Id]

	WHERE		--CAST(PR.[ReportDateTime] AS [sys].[date]) BETWEEN CAST(@DateFrom AS [sys].[date]) AND CAST(@DateTo AS [sys].[date]) AND
				Tzdb.IsLowerOrSameSystemDate(@DateFrom, PR.[ReportDateTime]) = 1 AND Tzdb.IsGreaterOrSameSystemDate(@DateTo, PR.[ReportDateTime]) = 1 AND
				  ((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1)) AND
				  ((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(poi.[Id], @IdUser) = 1)) AND
				  ((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1)) AND
				  ((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(POI.[IdDepartment], @IdUser) = 1)) AND
				  PR.[Suggested] IS NOT NULL AND PR.[Suggested] > 0
	
	ORDER BY	PR.[ReportDateTime], PR.[Id] DESC
END
