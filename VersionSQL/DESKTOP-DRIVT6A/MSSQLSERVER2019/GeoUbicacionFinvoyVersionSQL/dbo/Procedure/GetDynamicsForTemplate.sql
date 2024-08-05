/****** Object:  Procedure [dbo].[GetDynamicsForTemplate]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================================================
-- Author:		Juan Marin
-- Create date: 02/11/2023
-- Description:	SP para obtener la informacion de las dinamicas para el template con las referencias pivoteadas
-- =============================================================================
CREATE PROCEDURE [dbo].[GetDynamicsForTemplate] 
AS
BEGIN
	DECLARE @References NVARCHAR(MAX) --Obtengo todas las referencias de dinamicas concatenadas para posteriormente pivotear con los valores
	SELECT @References = STUFF((
			SELECT DISTINCT ',[' + [Name] + ']' FROM dbo.DynamicReference FOR XML PATH('')
			),1,1,'')	

	DECLARE @SqlStatement NVARCHAR(MAX)
	SET @SqlStatement = N'
		SELECT  DRV.[IdDynamicProductPointOfInterest], DR.[Name], DRV.[Value] 
		INTO	#DynamicReferencesSource --- temporary table
		FROM	dbo.DynamicReferenceValue DRV
		INNER JOIN
				dbo.DynamicReference DR ON DR.Id = DRV.IdDynamicReference AND DR.Deleted = 0
		WHERE	DRV.Deleted = 0

		SELECT	* 
		INTO	#DynamicReferencesPivot ---temporary table
		FROM	#DynamicReferencesSource t 
		PIVOT(
			MAX([Value])
			FOR [Name] IN ('+@References+')
		) AS pivot_table
		
		SELECT	DPPOI.[Id] AS DynamicProductPointOfInterestId,
			D.[Id] AS DynamicId, D.[Name] AS [Dynamic], D.[StartDate] AS [StartDate], D.[EndDate] AS [EndDate],
			P.[Id] AS ProductId, P.[Name] AS ProductName, P.[Identifier] AS ProductIdentifier, P.[BarCode] AS ProductBarCode, 
			POI.[Id] AS PointOfInterestId, POI.[Name] AS PointOfInterestName, POI.[Identifier] AS PointOfInterestIdentifier, POI.[Address] AS PointOfInterestAddress,
			FP.[Id] AS FormPlusId, F.[Id] AS FormId, F.[Name] AS FormName, F.[Description] AS FormDescription, F.[StartDate] AS FormStartDate, F.[EndDate] AS FormEndDate,
			DRP.*
		FROM [dbo].[Dynamic] D WITH (NOLOCK)
		INNER JOIN [dbo].[DynamicProductPointOfInterest] DPPOI WITH (NOLOCK) ON DPPOI.[IdDynamic] = D.[Id]
		INNER JOIN [dbo].[Product] P WITH (NOLOCK) ON P.[Id] = DPPOI.[IdProduct] AND P.[Deleted] = 0
		INNER JOIN [dbo].[PointOfInterest] POI WITH (NOLOCK) ON POI.[Id] = DPPOI.[IdPointOfInterest] AND POI.[Deleted] = 0
		INNER JOIN [dbo].[FormPlus] FP WITH (NOLOCK) ON FP.[Id] = D.[IdFormPlus] AND FP.[Deleted] = 0
		INNER JOIN [dbo].[Form] F WITH (NOLOCK) ON F.[Id] = FP.[IdForm] AND F.[Deleted] = 0
		LEFT JOIN #DynamicReferencesPivot DRP ON DRP.IdDynamicProductPointOfInterest = DPPOI.Id
		WHERE D.[Disabled] = 0 AND D.[Deleted] = 0
		ORDER BY D.[Name], P.[BarCode], POI.[Identifier]

		DROP TABLE IF EXISTS #DynamicReferencesSource
		DROP TABLE IF EXISTS #DynamicReferencesPivot
  ';
 
  EXEC(@SqlStatement)
 
END
