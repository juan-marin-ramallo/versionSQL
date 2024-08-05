/****** Object:  Procedure [dbo].[GetTopRankingControlStock]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 20/10/2015
-- Description:	SP para obtener el ranking por cantidad de controles de stock por persona
-- =============================================
CREATE PROCEDURE [dbo].[GetTopRankingControlStock]
(
	 @DateFrom [sys].[datetime]
	,@DateTo [sys].[DATETIME]
	,@IdPersonsOfInterest [sys].[varchar](max) = null
    ,@IdUser [sys].[INT] = NULL
)
AS
BEGIN
	SELECT TOP 10 S.[Id] AS PersonOfInterestId, S.[Name] AS PersonOfInterestName, S.[LastName] AS PersonOfInterestLastName, 
	COUNT(1) AS ControlStockQuantity, COUNT(DISTINCT(PR.IdProduct)) AS ProductsQuantity
	FROM [dbo].[ProductReportDynamic] PR WITH (NOLOCK)
	INNER JOIN [dbo].[Product] PROD WITH (NOLOCK) ON PROD.[Id] = PR.[IdProduct]
	INNER JOIN [dbo].[PersonOfInterest] S WITH (NOLOCK) ON S.[Id] = PR.[IdPersonOfInterest]
	INNER JOIN [dbo].[PointOfInterest] P WITH (NOLOCK) ON P.[Id] = PR.[IdPointOfInterest]
	WHERE --(CAST(Tzdb.FromUtc(PR.[ReportDateTime]) AS [sys].[date]) BETWEEN CAST(Tzdb.FromUtc(@DateFrom) AS [sys].[date]) AND CAST(Tzdb.FromUtc(@DateTo) AS [sys].[date])) AND
			(PR.[ReportDateTime] BETWEEN @DateFrom AND @DateTo) AND
			((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1)) AND
			((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1)) AND
			((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1)) AND
			((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1)) AND	
			((@IdUser IS NULL) OR (dbo.CheckUserInProductCompanies(PROD.[IdProductBrand], @IdUser) = 1)) 
			AND (@IdPersonsOfInterest IS NULL OR dbo.CheckValueInList(S.[Id], @IdPersonsOfInterest) > 0)
			--AND S.Deleted = 0 AND P.[Deleted] = 0
	GROUP BY S.[Id], S.[Name], S.[LastName]
	ORDER BY ControlStockQuantity desc
END
