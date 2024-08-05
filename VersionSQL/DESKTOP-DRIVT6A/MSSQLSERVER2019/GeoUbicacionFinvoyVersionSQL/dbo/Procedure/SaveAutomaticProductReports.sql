/****** Object:  Procedure [dbo].[SaveAutomaticProductReports]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SaveAutomaticProductReports] @ProductIdsToIgnore [sys].[varchar](MAX)
, @IdPersonOfInterest [sys].[int]
, @IdPointOfInterest [sys].[int]
, @ReportDateTime [sys].[datetime]
, @Email [sys].[varchar](50) = NULL
, @LastValues [sys].[bit] = 0
AS
BEGIN

  DECLARE @SavedProductReportIds TABLE (
    Id INT
  )

  CREATE TABLE #SkuPointOfInterestProduct (
    [IdProduct] INT NOT NULL,
    [IdPointOfInterest] INT NOT NULL,
    [TheoricalStock] INT,
    [TheoricalPrice] DECIMAL(18, 2)
  )

  INSERT INTO #SkuPointOfInterestProduct ([IdProduct], [IdPointOfInterest], [TheoricalStock], [TheoricalPrice])
  (SELECT  PPOI.[IdProduct], PPOI.[IdPointOfInterest], PPOI.[TheoricalStock], PPOI.[TheoricalPrice]
  FROM    [dbo].[ProductPointOfInterest] PPOI WITH (NOLOCK)
          INNER JOIN [dbo].[Catalog] C WITH (NOLOCK) ON C.[Id] = PPOI.[IdCatalog]
          INNER JOIN [dbo].[CatalogPersonOfInterestPermission] CPOIP WITH (NOLOCK) ON CPOIP.[IdCatalog] = C.[Id] AND CPOIP.[IdPersonOfInterestPermission] = 23
  WHERE   PPOI.[IdPointOfInterest] = @IdPointOfInterest
          AND C.[Deleted] = 0
  
  UNION

  SELECT  PPOI.[IdProduct], PPOI.[IdPointOfInterest], PPOI.[TheoricalStock], PPOI.[TheoricalPrice]
  FROM    [dbo].[ProductPointOfInterest] PPOI WITH (NOLOCK)
          INNER JOIN [dbo].[Catalog] C WITH (NOLOCK) ON C.[Id] = PPOI.[IdCatalog]
  WHERE   PPOI.[IdPointOfInterest] = @IdPointOfInterest
          AND C.[Deleted] = 0
          AND NOT EXISTS (SELECT 1 FROM [dbo].[CatalogPersonOfInterestPermission] CPOIP WITH (NOLOCK) WHERE CPOIP.[IdCatalog] = C.[Id])

  UNION
  
  SELECT  PPOI.[IdProduct], PPOI.[IdPointOfInterest], PPOI.[TheoricalStock], PPOI.[TheoricalPrice]
  FROM    [dbo].[ProductPointOfInterest] PPOI WITH (NOLOCK)
  WHERE   PPOI.[IdPointOfInterest] = @IdPointOfInterest
          AND PPOI.[IdCatalog] IS NULL)

  IF @LastValues = 1
  BEGIN
    IF EXISTS (SELECT 1 FROM #SkuPointOfInterestProduct)
    BEGIN

      INSERT INTO [dbo].[ProductReportDynamic] ([IdProduct], [IdPersonOfInterest], [IdPointOfInterest],
      [Deleted], [ReportDateTime], [ReportReceivedDate], [TheoricalStock], [TheoricalPrice], [Email])
      OUTPUT INSERTED.ID INTO @SavedProductReportIds
        SELECT
          PR.[Id]
         ,@IdPersonOfInterest
         ,@IdPointOfInterest
         ,0
         ,@ReportDateTime
         ,GETUTCDATE()
         ,P.[TheoricalStock]
         ,P.[TheoricalPrice]
         ,@Email
        FROM #SkuPointOfInterestProduct P WITH (NOLOCK)
        JOIN dbo.Product PR WITH (NOLOCK)
          ON PR.[Id] = P.[IdProduct]
        WHERE PR.[Deleted] = 0
        AND P.[IdPointOfInterest] = @IdPointOfInterest
        AND ((@ProductIdsToIgnore IS NULL)
        OR (dbo.[CheckValueInList](PR.[Id], @ProductIdsToIgnore) = 0))
        AND NOT EXISTS (SELECT
            1
          FROM [dbo].[ProductReportDynamic] WITH (NOLOCK)
          WHERE [IdProduct] = PR.[Id]
          AND [IdPointOfInterest] = @IdPointOfInterest
          AND [ReportDateTime] = @ReportDateTime)
        -- Solo si existen valores previos reportados para ese producto y punto,
        -- como para luego porder copiar los valores del último reporte.
        AND EXISTS (SELECT
            1
          FROM dbo.[ProductReportDynamic] P2 WITH (NOLOCK)
          JOIN dbo.[ProductReportAttributeValue] PAV2 WITH (NOLOCK)
            ON PAV2.[IdProductReport] = P2.[Id]
          JOIN dbo.[ProductReportAttribute] PA2 WITH (NOLOCK)
            ON PA2.[Id] = PAV2.[IdProductReportAttribute]
          WHERE P2.[IdPointOfInterest] = @IdPointOfInterest
          AND P2.[IdProduct] = PR.[Id]
          AND PA2.[Deleted] = 0
          AND PA2.[FullDeleted] = 0)
        GROUP BY PR.[Id]
                ,P.[TheoricalStock]
                ,P.[TheoricalPrice]
    END
    ELSE
    BEGIN

      INSERT INTO [dbo].[ProductReportDynamic] ([IdProduct], [IdPersonOfInterest], [IdPointOfInterest],
      [Deleted], [ReportDateTime], [ReportReceivedDate], [TheoricalStock], [TheoricalPrice], [Email])
      OUTPUT INSERTED.ID INTO @SavedProductReportIds
        SELECT
          PR.[Id]
         ,@IdPersonOfInterest
         ,@IdPointOfInterest
         ,0
         ,@ReportDateTime
         ,GETUTCDATE()
         ,NULL
         ,NULL
         ,@Email
        FROM dbo.Product PR WITH (NOLOCK)
        WHERE PR.[Deleted] = 0
        AND ((@ProductIdsToIgnore IS NULL)
        OR (dbo.[CheckValueInList](PR.[Id], @ProductIdsToIgnore) = 0))
        AND NOT EXISTS (SELECT
            1
          FROM [dbo].[ProductReportDynamic] WITH (NOLOCK)
          WHERE [IdProduct] = PR.[Id]
          AND [IdPointOfInterest] = @IdPointOfInterest
          AND [ReportDateTime] = @ReportDateTime)
        -- Solo si existen valores previos reportados para ese producto y punto,
        -- como para luego porder copiar los valores del último reporte.
        AND EXISTS (SELECT
            1
          FROM [ProductReportDynamic] P2 WITH (NOLOCK)
          JOIN [ProductReportAttributeValue] PAV2 WITH (NOLOCK)
            ON PAV2.[IdProductReport] = P2.[Id]
          JOIN [ProductReportAttribute] PA2 WITH (NOLOCK)
            ON PA2.[Id] = PAV2.[IdProductReportAttribute]
          WHERE P2.[IdPointOfInterest] = @IdPointOfInterest
          AND P2.[IdProduct] = PR.[Id]
          AND PA2.[Deleted] = 0
          AND PA2.[FullDeleted] = 0)
    END
  END
  ELSE
  BEGIN

    --NO IMPORTA SI HUBO REPORTES ANTES
    IF EXISTS (SELECT 1 FROM #SkuPointOfInterestProduct)
    BEGIN

      INSERT INTO [dbo].[ProductReportDynamic] ([IdProduct], [IdPersonOfInterest], [IdPointOfInterest],
      [Deleted], [ReportDateTime], [ReportReceivedDate], [TheoricalStock], [TheoricalPrice], [Email])
      OUTPUT INSERTED.ID INTO @SavedProductReportIds
        SELECT
          PR.[Id]
         ,@IdPersonOfInterest
         ,@IdPointOfInterest
         ,0
         ,@ReportDateTime
         ,GETUTCDATE()
         ,P.[TheoricalStock]
         ,P.[TheoricalPrice]
         ,@Email
        FROM #SkuPointOfInterestProduct P WITH (NOLOCK)
        JOIN dbo.Product PR WITH (NOLOCK)
          ON PR.[Id] = P.[IdProduct]
        WHERE PR.[Deleted] = 0
        AND P.[IdPointOfInterest] = @IdPointOfInterest
        AND ((@ProductIdsToIgnore IS NULL)
        OR (dbo.[CheckValueInList](PR.[Id], @ProductIdsToIgnore) = 0))
        AND NOT EXISTS (SELECT
            1
          FROM [dbo].[ProductReportDynamic] WITH (NOLOCK)
          WHERE [IdProduct] = PR.[Id]
          AND [IdPointOfInterest] = @IdPointOfInterest
          AND [ReportDateTime] = @ReportDateTime)
        GROUP BY PR.[Id]
                ,P.[TheoricalStock]
                ,P.[TheoricalPrice]

    END
    ELSE
    BEGIN

      INSERT INTO [dbo].[ProductReportDynamic] ([IdProduct], [IdPersonOfInterest], [IdPointOfInterest],
      [Deleted], [ReportDateTime], [ReportReceivedDate], [TheoricalStock], [TheoricalPrice], [Email])
      OUTPUT INSERTED.ID INTO @SavedProductReportIds
        SELECT
          PR.[Id]
         ,@IdPersonOfInterest
         ,@IdPointOfInterest
         ,0
         ,@ReportDateTime
         ,GETUTCDATE()
         ,NULL
         ,NULL
         ,@Email
        FROM dbo.Product PR WITH (NOLOCK)
        WHERE PR.[Deleted] = 0
        AND ((@ProductIdsToIgnore IS NULL)
        OR (dbo.[CheckValueInList](PR.[Id], @ProductIdsToIgnore) = 0))
        AND NOT EXISTS (SELECT
            1
          FROM [dbo].[ProductReportDynamic] WITH (NOLOCK)
          WHERE [IdProduct] = PR.[Id]
          AND [IdPointOfInterest] = @IdPointOfInterest
          AND [ReportDateTime] = @ReportDateTime)
    END

  END

  DROP TABLE #SkuPointOfInterestProduct

  EXEC [dbo].[SaveOrUpdateProductPointOInterestChangeLog] @IdPointOfInterest = @IdPointOfInterest

  SELECT
    [Id]
  FROM @SavedProductReportIds

END
