/****** Object:  Procedure [dbo].[GetTopProductReports]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetTopProductReports](    
	@IdProduct [sys].[int]
	, @IdPointOfInterest [sys].[int]
)
AS 
BEGIN
	--DECLARE @CheckCount [sys].[int] = (SELECT CONVERT([int], [Value]) FROM [Configuration] WHERE Id = 21)

    SET NOCOUNT ON;
    
	SELECT TOP		10 pr.Id, IdProduct,pr.IdPersonOfInterest,IdPointOfInterest, ReportDateTime, p.Name ProductName,
					poi.Name poiName, poi.Identifier, pei.Name as PeoiName, pei.LastName as PeoiLastName
    
	FROM			dbo.ProductReportDynamic pr
					INNER JOIN dbo.Product p ON p.[Id] = pr.[IdProduct] 
					INNER JOIN dbo.PointOfInterest poi ON poi.[Id] = pr.[IdPointOfInterest]
					INNER JOIN dbo.PersonOfInterest pei ON pei.[Id] = pr.[IdPersonOfInterest]
    
	WHERE			pr.[IdProduct] = @IdProduct AND pr.[IdPointOfInterest] = @IdPointOfInterest
					AND pr.[Deleted] = 0 AND poi.[Deleted] = 0 AND pei.[Deleted] = 0  AND p.[Deleted] = 0
	
	ORDER BY		ReportDateTime DESC
END
