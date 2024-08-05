/****** Object:  Procedure [dbo].[GetDetailedMarksReportDistance]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Diego Caceres	
-- Create date: 2014-04-24
-- Description:	Sp para calcular la distancia que recorrio un usuario entre el Login y el Logout
-- =============================================
CREATE PROCEDURE [dbo].[GetDetailedMarksReportDistance] 
	-- Add the parameters for the stored procedure here
	@IdExitMark [sys].[int]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @IdPersonOfInterest [sys].[int]
	DECLARE @TraveledDistance [sys].[decimal](8, 2)
	DECLARE @IdParent [sys].[int]
	DECLARE @StartDate [sys].[datetime]
	DECLARE @EndDate [sys].[datetime]
	
	SELECT 	@IdPersonOfInterest = [IdPersonOfInterest], @TraveledDistance = [TraveledDistance], @IdParent = [IdParent], @EndDate = [Date]
	FROM	[dbo].[Mark] WITH (NOLOCK)
	WHERE	[Id] = @IdExitMark

	IF @TraveledDistance IS NOT NULL AND @TraveledDistance > 0
	BEGIN
		SELECT @TraveledDistance
	END
	ELSE
	BEGIN
		SELECT 	@StartDate = [Date]
		FROM	[dbo].[Mark] WITH (NOLOCK)
		WHERE	[Id] = @IdParent

		SELECT ISNULL(SUM(L.[Dist]), 0)
		FROM
		(
			SELECT	ISNULL(LatLong.STDistance(LAG(LatLong) OVER (ORDER BY Date)), 0) AS Dist
			FROM	[dbo].[Location] L1 WITH (NOLOCK)
			WHERE	L1.IdPersonOfInterest = @IdPersonOfInterest AND L1.[Date] >= @StartDate AND (@EndDate IS NULL OR L1.[Date] <= @EndDate)
		) L
		WHERE L.[Dist] > 10
		--SELECT COALESCE(SUM(L.[Dist]), 0) AS Distance
		--	FROM
		--		(
		--		SELECT	ISNULL(L1.[LatLong].STDistance((SELECT [LatLong] FROM dbo.Location WITH (NOLOCK) WHERE [Id] = (SELECT MIN(L3.[Id]) FROM [dbo].[Location] L3 WITH (NOLOCK) WHERE L3.[IdPersonOfInterest] = L1.[IdPersonOfInterest] AND L3.[Id] > L1.[Id] AND L3.[Date] >= @StartDateLocal AND (@EndDateLocal IS NULL OR L3.[Date] <= @EndDateLocal)))), 0) AS Dist
		--		FROM	[dbo].[Location] L1 WITH (NOLOCK)
		--		WHERE	L1.IdPersonOfInterest = @IdPersonOfInterestLocal AND L1.[Date] >= @StartDateLocal AND (@EndDateLocal IS NULL OR L1.[Date] <= @EndDateLocal)
		--			AND L1.[Id] = (SELECT MAX(L2.[Id]) FROM [dbo].[Location] L2 WITH (NOLOCK) WHERE L2.[Date] = L1.[Date] AND L2.[IdPersonOfInterest] = L1.[IdPersonOfInterest])
		--		) L
		--WHERE L.[Dist] > 10
	END
END
