/****** Object:  Procedure [dbo].[GetVisitActivitiesDetails]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 15/03/2018
-- Description:	SP para obtener detalle de la visita realizada
-- =============================================
CREATE PROCEDURE [dbo].[GetVisitActivitiesDetails]
(
	 @IdVisit [sys].[int],
	 @ReportType [sys].[int],
	 @Tasks [sys].[bit] OUT,
	 @Stock [sys].[bit] OUT,
	 @Assets [sys].[bit] OUT,
	 @Observations [sys].[bit] OUT,
	 @Documents [sys].[bit] OUT,
	 @Refund [sys].[bit] OUT,
	 @Shortage [sys].[bit] OUT,
	 @PhotoComparative [sys].[bit] OUT,
	 @DateIn [sys].[datetime] OUT,
	 @DateOut [sys].[datetime] OUT
)
AS

BEGIN

	DECLARE @DateFrom [sys].[datetime]
	DECLARE @DateTo [sys].[datetime]
	DECLARE	@IdPersonOfInterest [sys].[int]
	DECLARE	@IdPointOfInterest [sys].[int]

	IF @ReportType = 1
	BEGIN
		--Visita automática
		SELECT	@DateFrom = [LocationInDate], @DateTo = [LocationOutDate], @IdPersonOfInterest = [IdPersonOfInterest],
				@IdPointOfInterest = [IdPointOfInterest]
		FROM	[dbo].[PointOfInterestVisited]
		WHERE	[Id] = @IdVisit
	END
	ELSE IF @ReportType = 2
	BEGIN
		--Visita MANUAL
		SELECT	@DateFrom = [CheckInDate], @DateTo = [CheckOutDate], @IdPersonOfInterest = [IdPersonOfInterest],
				@IdPointOfInterest = [IdPointOfInterest]
		FROM	[dbo].[PointOfInterestManualVisited]
		WHERE	[Id] = @IdVisit
	END
	ELSE IF @ReportType = 3
	BEGIN
		--Visita NFC
		SELECT	@DateFrom = [CheckInDate], @DateTo = [CheckOutDate], @IdPersonOfInterest = [IdPersonOfInterest],
				@IdPointOfInterest = [IdPointOfInterest]
		FROM	[dbo].[PointOfInterestMark]
		WHERE	[Id] = @IdVisit
	END

	SET @DateIn = @DateFrom
	SET @DateOut = @DateTo

	-- Tareas
	IF EXISTS (SELECT 1
				FROM [dbo].[CompletedForm]
				WHERE [StartDate] >= @DateFrom AND [StartDate] <= @DateTo AND
					 [IdPersonOfInterest] = @IdPersonOfInterest AND [IdPointOfInterest] = @IdPointOfInterest)
	BEGIN
		SET @Tasks = 1
	END
	ELSE
	BEGIN
		SET @Tasks = 0
	END

	-- STOCK
	IF EXISTS (SELECT 1
				FROM [dbo].[ProductReportDynamic]
				WHERE [ReportDateTime] >= @DateFrom AND [ReportDateTime] <= @DateTo AND
					 [IdPersonOfInterest] = @IdPersonOfInterest AND [IdPointOfInterest] = @IdPointOfInterest)
	BEGIN
		SET @Stock = 1
	END
	ELSE
	BEGIN
		SET @Stock = 0
	END

	-- asset
	IF EXISTS (SELECT 1
				FROM [dbo].[AssetReport]
				WHERE [Date] >= @DateFrom AND [Date] <= @DateTo AND
					 [IdPersonOfInterest] = @IdPersonOfInterest AND [IdPointOfInterest] = @IdPointOfInterest)
	BEGIN
		SET @Assets = 1
	END
	ELSE
	BEGIN
		SET @Assets = 0
	END

	-- Observaciones
	IF EXISTS (SELECT 1
				FROM [dbo].[Incident]
				WHERE [CreatedDate] >= @DateFrom AND [CreatedDate] <= @DateTo AND
					 [IdPersonOfInterest] = @IdPersonOfInterest AND [IdPointOfInterest] = @IdPointOfInterest)
	BEGIN
		SET @Observations = 1
	END
	ELSE
	BEGIN
		SET @Observations = 0
	END

	-- Documentos
	IF EXISTS (SELECT 1
				FROM [dbo].[DocumentReport]
				WHERE [Date] >= @DateFrom AND [Date] <= @DateTo AND
					 [IdPersonOfInterest] = @IdPersonOfInterest AND [IdPointOfInterest] = @IdPointOfInterest)
	BEGIN
		SET @Documents = 1
	END
	ELSE
	BEGIN
		SET @Documents = 0
	END

	-- Devoluciones
	IF EXISTS (SELECT 1
				FROM [dbo].[ProductRefund]
				WHERE [Date] >= @DateFrom AND [Date] <= @DateTo AND
					 [IdPersonOfInterest] = @IdPersonOfInterest AND [IdPointOfInterest] = @IdPointOfInterest)
	BEGIN
		SET @Refund = 1
	END
	ELSE
	BEGIN
		SET @Refund = 0
	END

	-- Faltantes
	IF EXISTS (SELECT 1
				FROM [dbo].[ProductMissingPointOfInterest]
				WHERE [Date] >= @DateFrom AND [Date] <= @DateTo AND
					 [IdPersonOfInterest] = @IdPersonOfInterest AND [IdPointOfInterest] = @IdPointOfInterest)
	BEGIN
		SET @Shortage = 1
	END
	ELSE
	BEGIN
		SET @Shortage = 0
	END

	-- Foto antes y después
	IF EXISTS (SELECT 1
				FROM [dbo].[PhotoReport]
				WHERE [ReportDate] >= @DateFrom AND [ReportDate] <= @DateTo AND
					 [IdPersonOfInterest] = @IdPersonOfInterest AND [IdPointOfInterest] = @IdPointOfInterest)
	BEGIN
		SET @PhotoComparative = 1
	END
	ELSE
	BEGIN
		SET @PhotoComparative = 0
	END

END
