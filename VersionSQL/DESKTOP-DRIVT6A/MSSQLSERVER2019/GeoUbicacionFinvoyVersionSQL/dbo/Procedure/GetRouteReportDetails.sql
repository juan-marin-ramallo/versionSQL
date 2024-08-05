/****** Object:  Procedure [dbo].[GetRouteReportDetails]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		gl
-- Create date: 25/01/2017
-- Description:	SP para obtener detalle de reporte de rutas
-- =============================================
CREATE PROCEDURE [dbo].[GetRouteReportDetails]
(
	 @RouteDate [sys].[datetime],
	 @IdPersonOfInterest [sys].[int],
	 @IdPointOfInterest [sys].[int],
	 @IncludeAutomaticVisits [sys].[bit] = 1,
	 @AutoCheck [sys].[bit] OUT,
	 @ManualCheck [sys].[bit] OUT,
	 @Tasks [sys].[bit] OUT,
	 @Stock [sys].[bit] OUT,
	 @Assets [sys].[bit] OUT,
	 @Observations [sys].[bit] OUT,
	 @NFCCheck [sys].[bit] OUT,
	 @Refund [sys].[bit] OUT,
	 @Documents [sys].[bit] OUT,
	 @Photos [sys].[bit] OUT,
	 @Shortage [sys].[bit] OUT,
	 @Order [sys].[bit] OUT,
	 @Assortment [sys].[bit] OUT
)
AS

BEGIN

	-- MARCAS AUTOMATICAS
	IF @IncludeAutomaticVisits = 1 AND EXISTS (SELECT 1
				FROM [dbo].[PointOfInterestVisited] WITH (NOLOCK)
				WHERE Tzdb.AreSameSystemDates([LocationInDate], @RouteDate) = 1 AND
					 [IdPersonOfInterest] = @IdPersonOfInterest AND 
					 [IdPointOfInterest] = @IdPointOfInterest AND
					 [dbo].IsVisitedLocationInPointHourWindow([IdPointOfInterest], [LocationInDate], [LocationOutDate]) = 1)
	BEGIN
		SET @AutoCheck = 1
	END
	ELSE
	BEGIN
		SET @AutoCheck = 0
	END

	-- MARCAS MANUALES
	IF EXISTS (SELECT 1
				FROM [dbo].[PointOfInterestManualVisited] WITH (NOLOCK)
				WHERE Tzdb.AreSameSystemDates([CheckInDate], @RouteDate) = 1 AND
					 [IdPersonOfInterest] = @IdPersonOfInterest AND [IdPointOfInterest] = @IdPointOfInterest)
	BEGIN
		SET @ManualCheck = 1
	END
	ELSE
	BEGIN
		SET @ManualCheck = 0
	END
	
	-- Tareas
	IF EXISTS (SELECT 1
				FROM [dbo].[CompletedForm] WITH (NOLOCK)
				WHERE Tzdb.AreSameSystemDates([StartDate], @RouteDate) = 1 AND
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
				FROM [dbo].[ProductReportDynamic] WITH (NOLOCK)
				WHERE Tzdb.AreSameSystemDates([ReportDateTime], @RouteDate) = 1 AND
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
				FROM [dbo].[AssetReport] WITH (NOLOCK)
				WHERE Tzdb.AreSameSystemDates([Date], @RouteDate) = 1 AND
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
				FROM [dbo].[Incident] WITH (NOLOCK)
				WHERE Tzdb.AreSameSystemDates([CreatedDate], @RouteDate) = 1 AND
					 [IdPersonOfInterest] = @IdPersonOfInterest AND [IdPointOfInterest] = @IdPointOfInterest)
	BEGIN
		SET @Observations = 1
	END
	ELSE
	BEGIN
		SET @Observations = 0
	END

	-- MARCAS NFC
	IF EXISTS (SELECT 1
				FROM [dbo].[PointOfInterestMark] WITH (NOLOCK)
				WHERE Tzdb.AreSameSystemDates([CheckInDate], @RouteDate) = 1 AND
					 [IdPersonOfInterest] = @IdPersonOfInterest AND [IdPointOfInterest] = @IdPointOfInterest)
	BEGIN
		SET @NFCCheck = 1
	END
	ELSE
	BEGIN
		SET @NFCCheck = 0
	END

	-- Devoluciones
	IF EXISTS (SELECT 1
				FROM [dbo].[ProductRefund]
				WHERE Tzdb.AreSameSystemDates([Date], @RouteDate) = 1 AND
					 [IdPersonOfInterest] = @IdPersonOfInterest AND [IdPointOfInterest] = @IdPointOfInterest)
	BEGIN
		SET @Refund = 1


	END
	ELSE
	BEGIN
		SET @Refund = 0
	END

	-- Documentos
	IF EXISTS (SELECT 1
				FROM [dbo].[DocumentReport]
				WHERE Tzdb.AreSameSystemDates([Date], @RouteDate) = 1 AND
					 [IdPersonOfInterest] = @IdPersonOfInterest AND [IdPointOfInterest] = @IdPointOfInterest)
	BEGIN
		SET @Documents = 1
	END
	ELSE
	BEGIN
		SET @Documents = 0
	END

	-- Foto antes vs despues
	IF EXISTS (SELECT 1
				FROM [dbo].[PhotoReport]
				WHERE Tzdb.AreSameSystemDates([ReportDate], @RouteDate) = 1 AND
					 [IdPersonOfInterest] = @IdPersonOfInterest AND [IdPointOfInterest] = @IdPointOfInterest)
	BEGIN
		SET @Photos = 1
	END
	ELSE
	BEGIN
		SET @Photos = 0
	END

	-- Faltantes
	IF EXISTS (SELECT 1
				FROM [dbo].[ProductMissingPointOfInterest]
				WHERE Tzdb.AreSameSystemDates([Date], @RouteDate) = 1 AND
					 [IdPersonOfInterest] = @IdPersonOfInterest AND [IdPointOfInterest] = @IdPointOfInterest)
	BEGIN
		SET @Shortage = 1
	END
	ELSE
	BEGIN
		SET @Shortage = 0
	END

	-- Pedidos
	IF EXISTS (SELECT 1
				FROM [dbo].[OrderReport]
				WHERE Tzdb.AreSameSystemDates([OrderDateTime], @RouteDate) = 1 AND
					 [IdPersonOfInterest] = @IdPersonOfInterest AND [IdPointOfInterest] = @IdPointOfInterest)
	BEGIN
		SET @Order = 1
	END
	ELSE
	BEGIN
		SET @Order = 0
	END

	-- Cumplimiento de Surtido
	IF EXISTS (SELECT 1
				FROM [dbo].[AssortmentReport]
				WHERE Tzdb.AreSameSystemDates([Date], @RouteDate) = 1 AND
					 [IdPersonOfInterest] = @IdPersonOfInterest AND [IdPointOfInterest] = @IdPointOfInterest)
	BEGIN
		SET @Assortment = 1
	END
	ELSE
	BEGIN
		SET @Assortment = 0
	END
	

END
