/****** Object:  Procedure [dbo].[GetBIStockReport]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetBIStockReport]
	@LastReportedDate datetime
AS
BEGIN
	
	SELECT	CONCAT( '"', REPLACE(PROD.[Name], '"', '""'),'"') AS ProductName, 
		CONCAT( '"', P.[Identifier], '-', P.[Name],'"') AS PointOfInterestFullName,
		CONCAT( '"', S.[Name], ' ', S.[LastName],'"') AS PersonOfInterestFullName,
		CASE WHEN PR.[Stock] IS NOT NULL THEN  CONCAT('"', PR.[Stock] , '"') ELSE 'NULL' END AS ReportStock,
		ISNULL(CONVERT(VARCHAR,FORMAT(CAST(Tzdb.FromUtc(PR.[ReportDateTime]) AS [sys].[date]),'yyyy-MM-dd'),21), 'NULL')  AS ReportDate,
		ISNULL(CONVERT(VARCHAR,FORMAT(CAST(Tzdb.FromUtc(PR.[ExpirationDate]) AS [sys].[date]),'yyyy-MM-dd'),21), 'NULL')  AS ReportExpirationDate,
		CASE WHEN PR.[Price] IS NOT NULL THEN  CONCAT('"', PR.[Price] , '"') ELSE 'NULL' END AS ReportPrice,
		CASE WHEN PR.[Suggested] IS NOT NULL THEN  CONCAT('"', PR.[Suggested] , '"') ELSE 'NULL' END AS ReportSuggested,
		CASE WHEN PR.[ShortStock] = 1 THEN  CONCAT('"', 1 , '"') ELSE  CONCAT('"', 0 , '"')  END AS ReportShortStock,
		CONCAT( '"', P.[Latitude], ', ', P.[Longitude], '"') AS PointOfInterestCoordinate

	FROM [dbo].[ProductReport] PR WITH (NOLOCK)
		INNER JOIN [dbo].[PointOfInterest] P WITH (NOLOCK) ON PR.[IdPointOfInterest]= P.[Id]
		INNER JOIN [dbo].[PersonOfInterest] S WITH (NOLOCK) ON PR.[IdPersonOfInterest] = S.[Id]
		INNER JOIN [dbo].[Product] PROD WITH (NOLOCK) ON PR.[IdProduct] = PROD.[Id]
		--LEFT JOIN [dbo].[ProductCategory] PC ON PROD.[IdProductCategory] = PC.[Id]
		LEFT JOIN [dbo].[ProductPointOfInterest] PP WITH (NOLOCK) ON PROD.[Id] = PP.[IdProduct] AND P.[Id] = PP.[IdPointOfInterest]

	WHERE PR.ReportReceivedDate > @LastReportedDate

	ORDER BY PR.[ReportDateTime] DESC

END
