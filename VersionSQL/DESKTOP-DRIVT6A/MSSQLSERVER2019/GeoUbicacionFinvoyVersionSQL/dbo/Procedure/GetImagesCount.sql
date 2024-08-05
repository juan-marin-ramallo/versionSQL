/****** Object:  Procedure [dbo].[GetImagesCount]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		FS
-- Create date: 01/03/2021
-- Description:	SP para obtener la cantidad de imagenes que tiene una tarea o reporte personalizado
-- =============================================
CREATE PROCEDURE [dbo].[GetImagesCount]	
	 @DateFrom [sys].[datetime]
	,@DateTo [sys].[datetime]
	,@PointOfInterestIds [sys].[varchar](MAX) = NULL
	,@StockersIds [sys].[varchar](MAX) = NULL
	,@IdForm [sys].[int] = NULL
	,@IdCustomReport [sys].[int] = NULL
AS
BEGIN
	DECLARE @CRTypeTasks [sys].[int] = 1
	DECLARE @CRTypeSKU [sys].[int] = 3
	DECLARE @CRTypeAssets [sys].[int] = 9
	DECLARE @CRTypeSOS [sys].[int] = 10
	DECLARE @CRTypeOrder [sys].[int] = 11

	DECLARE @ImagesCount [sys].[int] = 0
	DECLARE @DateFromTruncated [sys].[datetime]
	DECLARE @DateToTruncated [sys].[datetime]
	DECLARE @IdFormLocal [sys].[varchar](MAX)
	DECLARE @IdCustomReportLocal [sys].[varchar](MAX)
	DECLARE @PointOfInterestIdsLocal [sys].[varchar](MAX)
	DECLARE @StockersIdsLocal [sys].[varchar](MAX)

	SET @DateFromTruncated = @DateFrom
	SET @DateToTruncated = @DateTo
	SET @IdFormLocal = @IdForm
	SET @IdCustomReportLocal = @IdCustomReport
	SET @PointOfInterestIdsLocal = @PointOfInterestIds
	SET @StockersIdsLocal = @StockersIds

	IF @IdCustomReportLocal IS NOT NULL BEGIN
		SET @IdFormLocal = (SELECT TOP 1 IdForm FROM dbo.CustomReport WHERE Id = @IdCustomReportLocal ORDER BY Id)
		
		DECLARE @TypeIds [dbo].IdTableType
		INSERT INTO @TypeIds
		SELECT IdCustomReportType AS Id FROM dbo.CustomReportCustomReportType WHERE IdCustomReport = @IdCustomReportLocal

		-- tasks
		IF EXISTS (SELECT Id FROM @TypeIds WHERE Id = @CRTypeTasks)
		BEGIN
			SET @ImagesCount = @ImagesCount + 
						(select COUNT(Q.Id) ImagesCount
						from	dbo.CustomReportForm CRF
								INNER JOIN dbo.CompletedForm CF ON CF.IdForm = CRF.IdForm
								INNER JOIN dbo.Question Q on Q.IdForm = CF.IdForm AND Q.[Type] = 'CAM'
								INNER JOIN dbo.Answer A on A.IdCompletedForm = CF.Id AND A.IdQuestion = Q.Id AND A.ImageName IS NOT NULL
						WHERE   CRF.[IdCustomReport] = @IdCustomReportLocal AND
								CF.[Date] BETWEEN @DateFromTruncated AND @DateToTruncated AND
								(@PointOfInterestIdsLocal IS NULL OR (dbo.[CheckValueInList](CF.[IdPointOfInterest], @PointOfInterestIdsLocal) = 1)) AND
								(@StockersIdsLocal IS NULL OR (dbo.[CheckValueInList](CF.[IdPersonOfInterest], @StockersIdsLocal) = 1)))
		END
		-- sku
		IF EXISTS (SELECT Id FROM @TypeIds WHERE Id = @CRTypeSKU) BEGIN
			SET @ImagesCount = @ImagesCount + 
						(select COUNT(V.Id) ImagesCount
						from	dbo.ProductReportDynamic PR  
								INNER JOIN dbo.ProductReportAttribute A on A.IdType = 1 --camara
								INNER JOIN dbo.ProductReportAttributeValue V on V.IdProductReportAttribute = A.Id AND V.IdProductReport = PR.Id AND V.ImageName IS NOT NULL
						WHERE   PR.ReportDateTime BETWEEN @DateFromTruncated AND @DateToTruncated AND
								(@PointOfInterestIdsLocal IS NULL OR (dbo.[CheckValueInList](PR.[IdPointOfInterest], @PointOfInterestIdsLocal) = 1)) AND
								(@StockersIdsLocal IS NULL OR (dbo.[CheckValueInList](PR.[IdPersonOfInterest], @StockersIdsLocal) = 1)))
		END
		-- assets
		IF EXISTS (SELECT Id FROM @TypeIds WHERE Id = @CRTypeAssets) BEGIN
			SET @ImagesCount = @ImagesCount + 
						(select COUNT(V.Id) ImagesCount
						from	dbo.AssetReportDynamic AR  
								INNER JOIN dbo.AssetReportAttribute A on A.IdType = 1 --camara
								INNER JOIN dbo.AssetReportAttributeValue V on V.IdAssetReportAttribute = A.Id AND V.IdAssetReport = AR.Id AND V.ImageName IS NOT NULL
						WHERE   AR.Date BETWEEN @DateFromTruncated AND @DateToTruncated AND
								(@PointOfInterestIdsLocal IS NULL OR (dbo.[CheckValueInList](AR.[IdPointOfInterest], @PointOfInterestIdsLocal) = 1)) AND
								(@StockersIdsLocal IS NULL OR (dbo.[CheckValueInList](AR.[IdPersonOfInterest], @StockersIdsLocal) = 1)))
		END
		-- sos
		IF EXISTS (SELECT Id FROM @TypeIds WHERE Id = @CRTypeSOS) BEGIN
			SET @ImagesCount = @ImagesCount + 
						(select COUNT(SI.Id) ImagesCount
						from	dbo.ShareOfShelfReport SOS
	                            INNER JOIN dbo.ShareOfShelfImage SI ON SI.IdShareOfShelf = SOS.Id
						WHERE   SOS.[Date] BETWEEN @DateFromTruncated AND @DateToTruncated AND
								(@PointOfInterestIdsLocal IS NULL OR (dbo.[CheckValueInList](SOS.[IdPointOfInterest], @PointOfInterestIdsLocal) = 1)) AND
								(@StockersIdsLocal IS NULL OR (dbo.[CheckValueInList](SOS.[IdPersonOfInterest], @StockersIdsLocal) = 1)))
		END
		-- order
		IF EXISTS (SELECT Id FROM @TypeIds WHERE Id = @CRTypeOrder) BEGIN
			SET @ImagesCount = @ImagesCount + 
						(select COUNT(V.Id) ImagesCount
						from	dbo.OrderReport O  
								INNER JOIN dbo.OrderReportAttribute A on A.IdType = 1 --camara
								INNER JOIN dbo.OrderReportAttributeValue V on V.IdOrderReportAttribute = A.Id AND V.IdOrderReport = O.Id AND V.ImageName IS NOT NULL
						WHERE   O.OrderDateTime BETWEEN @DateFromTruncated AND @DateToTruncated AND
								(@PointOfInterestIdsLocal IS NULL OR (dbo.[CheckValueInList](O.[IdPointOfInterest], @PointOfInterestIdsLocal) = 1)) AND
								(@StockersIdsLocal IS NULL OR (dbo.[CheckValueInList](O.[IdPersonOfInterest], @StockersIdsLocal) = 1)))
		END
	END
	-- tareas
	IF @IdFormLocal IS NOT NULL BEGIN
		SET @ImagesCount = @ImagesCount + 
							(select COUNT(Q.Id) ImagesCount
							from	dbo.CompletedForm CF  
									INNER JOIN dbo.Question Q on Q.IdForm = CF.IdForm AND Q.[Type] = 'CAM'
									INNER JOIN dbo.Answer A on A.IdCompletedForm = CF.Id AND A.IdQuestion = Q.Id AND A.ImageName IS NOT NULL
							WHERE   CF.[Date] BETWEEN @DateFromTruncated AND @DateToTruncated AND
									(@PointOfInterestIdsLocal IS NULL OR (dbo.[CheckValueInList](CF.[IdPointOfInterest], @PointOfInterestIdsLocal) = 1)) AND
									(@StockersIdsLocal IS NULL OR (dbo.[CheckValueInList](CF.[IdPersonOfInterest], @StockersIdsLocal) = 1)))
	END

	SELECT @ImagesCount AS ImagesCount
END
