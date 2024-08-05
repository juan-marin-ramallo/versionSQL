/****** Object:  Procedure [dbo].[GetLastReportedShortageProducts]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetLastReportedShortageProducts] 
	@PointOfInterestId [sys].[INT]
    ,@ShortageType [sys].[INT]
	,@PersonOfInterestId [sys].[INT] = NULL
AS
BEGIN
	DECLARE @IdShortagePermission [sys].[int] = 15
	
	IF EXISTS (SELECT 1 FROM [dbo].[ProductPointOfInterest] PP WITH (NOLOCK)
							INNER JOIN [dbo].[Product] P WITH (NOLOCK) ON P.[Id] = PP.[IdProduct]
							WHERE PP.[IdPointOfInterest] = @PointOfInterestId AND P.[Deleted] = 0)
	BEGIN

		--Primero miro si reporto SI o NO
		DECLARE @LastMissingConfirmation [sys].[bit]
		SET @LastMissingConfirmation = (SELECT TOP 1 [MissingConfirmation]
							FROM	[dbo].[ProductMissingPointOfInterest]
							WHERE	[IdPointOfInterest] = @PointOfInterestId AND [IdProductMissingType] = @ShortageType 
									AND (@PersonOfInterestId IS NULL OR [IdPersonOfInterest] = @PersonOfInterestId)
							ORDER BY	[Date] DESC)
		
		IF @LastMissingConfirmation = 1
		BEGIN
			SELECT	P.[Id], P.[Name], P.[BarCode], P.[Identifier], PMPI.[Date] as LastReportedDate,
					PMPI.[MissingConfirmation]

			FROM	[dbo].[ProductMissingPointOfInterest] PMPI
					LEFT JOIN [dbo].[ProductMissingReport] PMR ON PMPI.[Id] = PMR.[IdMissingProductPoi]
					LEFT JOIN [dbo].[Product] P ON PMR.[IdProduct] = P.[Id] AND P.[Deleted] = 0 
					LEFT JOIN [dbo].[ProductPointOfInterest] PPOI ON PPOI.[IdPointOfInterest] = PMPI.[IdPointOfInterest]	
															-- AND (PPOI.[IdProduct] = P.[Id]) -- movido al where para distinguir si estan todos asignados		
					LEFT JOIN dbo.[Catalog] C ON PPOI.IdCatalog = C.Id AND C.Deleted = 0
					LEFT JOIN dbo.CatalogPersonOfInterestPermission CPP ON C.Id = CPP.IdCatalog AND CPP.IdPersonOfInterestPermission = @IdShortagePermission						
					LEFT JOIN [dbo].[CatalogProduct] CPPOI ON CPP.IdCatalog = CPPOI.IdCatalog AND CPPOI.IdProduct = P.Id

			WHERE	PMPI.[IdPointOfInterest] = @PointOfInterestId AND (PPOI.[IdProduct] = P.[Id] OR CPPOI.IdProduct IS NOT NULL OR PPOI.[IdPointOfInterest] IS NULL OR CPP.Id IS NULL)
					AND PMPI.[IdProductMissingType] = @ShortageType 
					AND (@PersonOfInterestId IS NULL OR PMPI.[IdPersonOfInterest] = @PersonOfInterestId)
					AND PMPI.[Id] = (SELECT TOP 1 [Id]
								FROM	[dbo].[ProductMissingPointOfInterest]
								WHERE	[IdPointOfInterest] = @PointOfInterestId AND [IdProductMissingType] = @ShortageType 
										AND (@PersonOfInterestId IS NULL OR [IdPersonOfInterest] = @PersonOfInterestId)
								ORDER BY	[Date] DESC)

			GROUP BY P.[Id], P.[Name], P.[BarCode], P.[Identifier], PMPI.[Date],
					PMPI.[MissingConfirmation]
		END
		ELSE
		BEGIN

			SELECT	NULL AS [Id], NULL AS [Name], NULL AS [BarCode], NULL AS [Identifier], PMPI.[Date] as LastReportedDate, PMPI.[MissingConfirmation]

			FROM	[dbo].[ProductMissingPointOfInterest] PMPI
					LEFT JOIN [dbo].[ProductMissingReport] PMR ON PMPI.[Id] = PMR.[IdMissingProductPoi]

			WHERE	PMPI.[IdPointOfInterest] = @PointOfInterestId
					AND PMPI.[IdProductMissingType] = @ShortageType 
					AND PMPI.[Id] = (SELECT TOP 1 [Id]
								FROM	[dbo].[ProductMissingPointOfInterest]
								WHERE	[IdPointOfInterest] = @PointOfInterestId AND [IdProductMissingType] = @ShortageType 
										AND (@PersonOfInterestId IS NULL OR [IdPersonOfInterest] = @PersonOfInterestId)
								ORDER BY	[Date] DESC)

			GROUP BY PMPI.[Date],
					PMPI.[MissingConfirmation]

		END
	END
	ELSE
	BEGIN

		SELECT	P.[Id], P.[Name], P.[BarCode], P.[Identifier], PMPI.[Date] as LastReportedDate,
				PMPI.[MissingConfirmation]

		FROM	[dbo].[ProductMissingPointOfInterest] PMPI
				LEFT JOIN [dbo].[ProductMissingReport] PMR ON PMPI.[Id] = PMR.[IdMissingProductPoi]			
				LEFT JOIN [dbo].[Product] P ON PMR.[IdProduct] = P.[Id] AND P.[Deleted] = 0 
				
		WHERE	PMPI.[IdPointOfInterest] = @PointOfInterestId 
				AND PMPI.[IdProductMissingType] = @ShortageType 
				AND PMPI.[Id] = (SELECT TOP 1 [Id]
							FROM	[dbo].[ProductMissingPointOfInterest]
							WHERE	[IdPointOfInterest] = @PointOfInterestId AND [IdProductMissingType] = @ShortageType 
									AND (@PersonOfInterestId IS NULL OR [IdPersonOfInterest] = @PersonOfInterestId)
							ORDER BY	[Date] DESC)

		GROUP BY P.[Id], P.[Name], P.[BarCode], P.[Identifier], PMPI.[Date],
				PMPI.[MissingConfirmation]

	END

END
