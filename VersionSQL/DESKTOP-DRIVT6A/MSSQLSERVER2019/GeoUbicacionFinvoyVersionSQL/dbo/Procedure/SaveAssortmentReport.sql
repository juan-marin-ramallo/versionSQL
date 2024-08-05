/****** Object:  Procedure [dbo].[SaveAssortmentReport]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[SaveAssortmentReport]
	@Id [sys].[int] OUT,
	@IdPersonOfInterest [sys].[int],
	@IdPointOfInterest [sys].[int],
	@Date [sys].[datetime],
	@CompliantProductIds [dbo].[IdTableType] READONLY
AS
BEGIN
	DECLARE @Now [sys].[datetime]
	SET @Now = GETUTCDATE()

	CREATE TABLE #PointProducts
	(
		[IdPointOfInterest] [sys].[int],
		[IdProduct] [sys].[int],
		[TheoricalStock] [sys].[int],
		[TheoricalPrice] [sys].[decimal](18, 2),
		[IdProductReportAttribute] [sys].[int],
		[ProductReportAttributeValue] [sys].[varchar](MAX),
		[IdPersonOfInterestPermission] [sys].[int],
		[IdProductReportSection] [sys].[int]
	)

	DECLARE @PointOfInterestIds [dbo].[IdTableType]
	
	INSERT INTO @PointOfInterestIds
	SELECT	@IdPointOfInterest;

	INSERT INTO #PointProducts
	EXEC [dbo].[GetPointsOfInterestProducts] @PointOfInterestIds

	CREATE TABLE #NonCompliantPointProducts
	(
		 [Id] [sys].[int]
	)

	IF EXISTS (SELECT TOP(1) 1 FROM #PointProducts WHERE [IdPersonOfInterestPermission] IN (0, 33))
	BEGIN
		INSERT INTO #NonCompliantPointProducts
		SELECT		PP.[IdProduct]
		FROM		#PointProducts PP
					LEFT OUTER JOIN @CompliantProductIds CPI ON CPI.[Id] = PP.[IdProduct]
		WHERE		CPI.[Id] IS NULL
					AND (PP.[IdPersonOfInterestPermission] IN (0, 33))
		GROUP BY	PP.[IdProduct]
	END
	ELSE
	BEGIN
		INSERT INTO #NonCompliantPointProducts
		SELECT		P.[Id]
		FROM		[dbo].[Product] P
					LEFT OUTER JOIN @CompliantProductIds CPI ON CPI.[Id] = P.[Id]
		WHERE		CPI.[Id] IS NULL
					AND P.[Deleted] = 0
	END

	DROP TABLE #PointProducts


	IF EXISTS (SELECT TOP(1) 1 FROM [dbo].[AssortmentReport] WITH (NOLOCK) WHERE [IdPointOfInterest] = @IdPointOfInterest AND
				[IdPersonOfInterest] = @IdPersonOfInterest AND Tzdb.AreSameSystemDates([Date], @Date) = 1 AND
				[Deleted] = 0)
	BEGIN
		SET NOCOUNT ON;

		UPDATE	[dbo].[AssortmentReport] 
		SET		[Deleted] = 1
		WHERE	[IdPointOfInterest] = @IdPointOfInterest AND
				[IdPersonOfInterest] = @IdPersonOfInterest AND Tzdb.AreSameSystemDates([Date], @Date) = 1	AND
				[Deleted] = 0
	END

	DECLARE @CompliancePercentage [sys].[decimal](5, 2)
	DECLARE @NonCompliancePercentage [sys].[decimal](5, 2)

	SET @CompliancePercentage = (SELECT COUNT(1) FROM @CompliantProductIds) * 100.0 / ((SELECT COUNT(1) FROM @CompliantProductIds) + ISNULL((SELECT COUNT(1) FROM #NonCompliantPointProducts), 0))
	SET @NonCompliancePercentage = 100.0 - @CompliancePercentage

	INSERT INTO	[dbo].[AssortmentReport] ([IdPersonOfInterest], [IdPointOfInterest], [Date], 
				[ReceivedDate], [CompliancePercentage], [NonCompliancePercentage], [Deleted])
	VALUES		(@IdPersonOfInterest, @IdPointOfInterest, @Date,
				@Now, @CompliancePercentage, @NonCompliancePercentage, 0)
		
	SET	@Id = SCOPE_IDENTITY()

	INSERT INTO [dbo].[AssortmentReportProduct]([IdAssortmentReport], [IdProduct], [Complies])
	(
		SELECT	@Id, [Id], 1
		FROM	@CompliantProductIds
	
		UNION

		SELECT	@Id, [Id], 0
		FROM	#NonCompliantPointProducts
	)

	DROP TABLE #NonCompliantPointProducts

	EXEC [dbo].[SavePointsOfInterestActivity]
				@IdPersonOfInterest = @IdPersonOfInterest
			,@IdPointOfInterest = @IdPointOfInterest
			,@DateIn = @Date
			,@AutomaticValue = 13
END
