/****** Object:  Procedure [dbo].[GetShareOfShelfIRReportForViewer]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================  
-- Author:  Jesús Portillo
-- Create date: 26/05/2022  
-- Description: SP para obtener el reporte de
--				Share of shelf con información
--				para ver imagen de stitching
-- =============================================  
CREATE PROCEDURE [dbo].[GetShareOfShelfIRReportForViewer]  
(  
	@Id [sys].[int]
)
AS
BEGIN
	IF EXISTS (SELECT TOP(1) 1 FROM [dbo].[ShareOfShelfReport] WITH (NOLOCK) WHERE [Id] = @Id AND [IsManual] = 0)
	BEGIN
		SELECT	SOS.[Id], SOS.[Date], SOS.[GrandTotal], SOS.[IsValid], SOS.[DiscardReason], SOS.[ValidationImage],
				SOS.[IdPointOfInterest], POI.[Name] AS PointOfInterestName, POI.[Identifier] AS PointOfInterestIdentifier
		FROM	[dbo].[ShareOfShelfReport] SOS WITH (NOLOCK)
				INNER JOIN [dbo].[PointOfInterest] POI WITH (NOLOCK) ON POI.[Id] = SOS.[IdPointOfInterest]
		WHERE	SOS.[Id] = @Id

		SELECT		SOSI.[Id], SOSI.[IdProductBrand], PB.[Name] AS ProductBrandName,
					PB.[IdCompany], C.[Name] AS CompanyName, C.[IsMain] AS CompanyIsMain, SOSI.[Total],
					SOSIC.[Id] AS IdItemCoordinates, SOSIC.[X0], SOSIC.[Y0], SOSIC.[X1], SOSIC.[Y1]
		FROM		[dbo].[ShareOfShelfItem] SOSI WITH (NOLOCK)
					INNER JOIN [dbo].[ProductBrand] PB WITH (NOLOCK) ON PB.[Id] = SOSI.[IdProductBrand]
					INNER JOIN [dbo].[Company] C WITH (NOLOCK) ON C.[Id] = PB.[IdCompany]
					INNER JOIN [dbo].[ShareOfShelfItemCoordinates] SOSIC WITH (NOLOCK) ON SOSIC.[IdShareOfShelfItem] = SOSI.[Id]
		WHERE		SOSI.[IdShareOfShelf] = @Id
		ORDER BY	C.[IsMain] DESC, C.[Name], PB.[Name]

		SELECT	SOSES.[Id], SOSES.[X0], SOSES.[Y0], SOSES.[X1], SOSES.[Y1]
		FROM	[dbo].[ShareOfShelfEmptySpace] SOSES WITH (NOLOCK)
		WHERE	SOSES.[IdShareOfShelf] = @Id
	END
END
