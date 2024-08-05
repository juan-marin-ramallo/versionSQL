/****** Object:  Procedure [dbo].[GetNonStockChartData]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Gaston Legnani
-- Create date: 20/10/2015
-- Description:	SP para obtener la información para la gráfica de Faltantes por día
-- =============================================
CREATE PROCEDURE [dbo].[GetNonStockChartData]

	 @DateFrom [sys].[datetime] = NULL
	,@DateTo [sys].[datetime] = NULL
	,@IdPersonsOfInterest [sys].[varchar](max) = null
	,@IdUser [sys].[INT] = NULL
AS
BEGIN

	SELECT	Tzdb.ToUtc(CAST(Tzdb.FromUtc(PP.[Date]) AS [sys].[date])) AS ProductReportDate, 
			Count(1) AS NonStockQuantity
	
	FROM	[dbo].[ProductMissingReport] PR
			INNER JOIN [dbo].[ProductMissingPointOfInterest] PP ON PP.[Id] = PR.[IdMissingProductPoi]
			INNER JOIN [dbo].[Product] PROD WITH(NOLOCK) ON PROD.[Id] = PR.[IdProduct]
			INNER JOIN [dbo].[PersonOfInterest] S ON S.[Id] = PP.[IdPersonOfInterest]
			INNER JOIN [dbo].[PointOfInterest] P ON P.[Id] = PP.[IdPointOfInterest]
	
	WHERE	--(CAST(Tzdb.FromUtc(PP.[Date]) AS [sys].[date]) BETWEEN CAST(Tzdb.FromUtc(@DateFrom) AS [sys].[date]) AND CAST(Tzdb.FromUtc(@DateTo) AS [sys].[date])) AND
			(PP.[Date] BETWEEN @DateFrom AND @DateTo) AND
			((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1)) AND
			((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1)) AND
			((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1)) AND
			((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1))			
			AND (@IdPersonsOfInterest IS NULL OR dbo.CheckValueInList(S.[Id], @IdPersonsOfInterest) > 0)
			AND ((@IdUser IS NULL) OR (dbo.CheckUserInProductCompanies(PROD.[IdProductBrand], @IdUser) = 1)) 
			--AND S.Deleted = 0 AND P.Deleted = 0
	
	GROUP BY	Tzdb.ToUtc(CAST(Tzdb.FromUtc(PP.[Date]) AS [sys].[date]))
	ORDER BY	Tzdb.ToUtc(CAST(Tzdb.FromUtc(PP.[Date]) AS [sys].[date]))

END
