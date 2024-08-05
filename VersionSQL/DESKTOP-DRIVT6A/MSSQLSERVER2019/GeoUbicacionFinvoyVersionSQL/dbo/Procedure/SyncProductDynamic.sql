/****** Object:  Procedure [dbo].[SyncProductDynamic]    Committed by VersionSQL https://www.versionsql.com ******/

-- ============================================
-- Author:		JUAN MARIN
-- Create date: 11/10/2023
-- Description:	SP para sincronizar las Dinamicas
-- ==============================================
CREATE PROCEDURE [dbo].[SyncProductDynamic]
(
	 @SyncType [int]
	,@Data [ProductDynamicTableType] READONLY
	,@LoggedUserId [INT]
)
AS
BEGIN
	SET ANSI_WARNINGS  OFF;	
	DECLARE @Add [int] = 0
	DECLARE @AddUpdate [int] = 1
	DECLARE @AddUpdateDelete [int] = 2

	CREATE TABLE #ProductDynamic 
	(
		[ProductId] [int] NULL,
		[ProductBarCode] [varchar](100) NULL,
		[PointOfInterestId] [int]  NULL,
		[PointOfInterestIdentifier] [varchar](50) NULL,
		[Dynamic] [varchar](100) NULL,
		[Action] [char](1) NULL,
		[SectionOrForm] [varchar](100) NULL,
		[ProductReportSectionId] [int] NULL,
		[Section] [varchar](100) NULL,
		[FormId] [int] NULL,
		[Form] [varchar](100) NULL
	)

	INSERT INTO #ProductDynamic
	SELECT	P.Id AS [ProductId], D.ProductBarCode, POI.Id  AS [PointInterestId], D.PointOfInterestIdentifier, D.[Dynamic], 
			D.[Action], D.[SectionOrForm], 
			IIF(D.[Action] = 'S', PRS.[Id] , NULL ) AS [ProductReportSectionId], IIF(D.[Action] = 'S', D.[SectionOrForm] , NULL ) AS [Section],
			IIF(D.[Action] = 'F', F.[Id] , NULL ) AS [FormId], IIF(D.[Action] = 'F', D.[SectionOrForm] , NULL ) AS [Form]
	FROM	@Data D
	LEFT JOIN [dbo].[Product]				P	WITH (NOLOCK) ON P.[BarCode] = D.[ProductBarCode] AND P.[Deleted] = 0
	LEFT JOIN [dbo].[PointOfInterest]		POI WITH (NOLOCK) ON POI.[Identifier] = D.[PointOfInterestIdentifier] AND POI.[Deleted] = 0
	LEFT JOIN [dbo].[ProductReportSection]	PRS WITH (NOLOCK) ON PRS.[Name] = D.[SectionOrForm] AND D.[Action] = 'S' AND PRS.[Deleted] = 0 AND PRS.IdUser = @LoggedUserId
	LEFT JOIN [dbo].[Form]					F	WITH (NOLOCK) ON F.[Name] = D.[SectionOrForm] AND D.[Action] = 'F' AND F.[Deleted] = 0 AND F.IdUser = @LoggedUserId


	-- Update ingresados
	IF @AddUpdate <= @SyncType
	BEGIN
		UPDATE	PD
		SET		PD.[Dynamic] = D.[Dynamic],
				PD.[IdProductReportSection] = D.[ProductReportSectionId],
				PD.[IdForm] = D.[FormId]
		FROM	[dbo].[ProductDynamic] PD
		INNER JOIN
				#ProductDynamic D ON D.[ProductId] = PD.[IdProduct] AND D.[PointOfInterestId] = PD.[IdPointOfInterest] AND PD.Deleted = 0
	END

	-- Delete faltantes
	IF @AddUpdateDelete <= @SyncType
	BEGIN
		UPDATE	PD
		SET		PD.[Deleted] = 1
		FROM	[dbo].[ProductDynamic] PD
		LEFT JOIN
				#ProductDynamic D ON D.[ProductId] = PD.[IdProduct] AND D.[PointOfInterestId] = PD.[IdPointOfInterest] AND PD.Deleted = 0
		WHERE	D.ProductId IS NULL AND D.PointOfInterestId IS NULL

	END

	-- Si solo agrego, Obtengo los repetidos antes de agregar los nuevos 
	-- de lo contrario siempre van a existir
	-- Esto para mandar a [SynchronizationLogError]
	SELECT  D.[ProductBarCode], D.[PointOfInterestIdentifier], D.[Dynamic], D.[Action], D.[SectionOrForm]
	FROM	[dbo].[ProductDynamic] PD
	INNER JOIN
			#ProductDynamic D ON D.[ProductId] = PD.[IdProduct] AND D.[PointOfInterestId] = PD.[IdPointOfInterest] AND PD.Deleted = 0
	WHERE	@Add = @SyncType

	-- Insert nuevos
	IF @Add <= @SyncType
	BEGIN	
		INSERT INTO [dbo].[ProductDynamic]([Dynamic],[IdProduct], [IdPointOfInterest], [IdProductReportSection], [IdForm], [Deleted])
		SELECT  D.[Dynamic], D.[ProductId], D.[PointOfInterestId], D.[ProductReportSectionId], D.[FormId], 0
		FROM    #ProductDynamic D
				LEFT JOIN [dbo].[ProductDynamic] PD ON D.[ProductId] = PD.[IdProduct] AND D.[PointOfInterestId] = PD.[IdPointOfInterest] AND PD.Deleted = 0
		WHERE	PD.IdProduct IS NULL AND PD.IdPointOfInterest IS NULL AND (D.[ProductReportSectionId] IS NOT NULL OR D.[FormId] IS NOT NULL)
	END
		
	-- obtener los registros mal referenciados para mandar a [SynchronizationLogError]
	SELECT	D.[ProductBarCode], D.[PointOfInterestIdentifier], D.[Dynamic], D.[Action], D.[SectionOrForm]
	FROM	#ProductDynamic D
	WHERE   D.ProductId IS NULL OR D.PointOfInterestId IS NULL OR (D.[ProductReportSectionId] IS NULL AND D.[FormId] IS NULL)
	   	
	SET ANSI_WARNINGS  ON;
END
