/****** Object:  Procedure [dbo].[SyncFathers]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 20/04/2015
-- Description:	SP para sincronizar lAS JERARQUIAS DE NIVEL 2
-- =============================================
CREATE PROCEDURE [dbo].[SyncFathers]
(
	@SyncType [INT]
	,@Data [AgrupationTableType] READONLY
)
AS
BEGIN
	DECLARE @Add [int] = 0
	DECLARE @AddUpdate [int] = 1
	DECLARE @AddUpdateDelete [int] = 2

	-- Update ingresados
	IF @AddUpdate <= @SyncType
		BEGIN
		-- Update ingresados
		UPDATE	PR
		SET		PR.[SapId] = P.[Id]
				,PR.[Name] = P.[Name]
				,PR.[Society] = P.[Society]
				,PR.[HierarchyLevel1Id] = PP.[Id]
				,PR.[Deleted] = 0
		FROM	[dbo].[POIHierarchyLevel2] PR
				INNER JOIN @Data as P ON PR.[SapId] = P.[Id]
				LEFT OUTER JOIN [dbo].[POIHierarchyLevel1] PP ON PP.[SapId] = P.[GroupId]
		WHERE	P.[GroupId] IS NULL OR PP.[Id] IS NOT NULL
	END		

	-- Delete faltantes
	IF @AddUpdateDelete <= @SyncType
	BEGIN
		-- Delete faltantes
		UPDATE	PR
		SET		PR.[Deleted] = 1
		FROM	[dbo].[POIHierarchyLevel2] PR
				LEFT OUTER JOIN @Data as P ON PR.[SapId] = P.[Id]
		WHERE	P.[Id] IS NULL
		
		UPDATE	POI
		SET		[FatherId] = NULL
		FROM	[dbo].[PointOfInterest] POI
				INNER JOIN [dbo].[POIHierarchyLevel2] POIH2 ON POIH2.Id = POI.FatherId
				LEFT OUTER JOIN @Data as P ON POIH2.[SapId] = P.[Id]
		WHERE	P.[Id] IS NULL
	END

	-- Obtengo los que no tiene referencia
	-- Si solo agrego Obtengo los repetidos antes de agregar los nuevos
	-- de lo contrario siempre van a existir	
	SELECT	P.[Id], P.[Name],
			IIF(P.[GroupId] IS NOT NULL AND (H1.[Id] IS NULL OR H1.[Deleted] = 1), 1, 0)
	FROM	@Data P
			LEFT OUTER JOIN [dbo].[POIHierarchyLevel2] PR ON PR.[SapId] = P.[Id] AND PR.[Deleted] = 0
			LEFT OUTER JOIN [dbo].[POIHierarchyLevel1] H1 WITH (NOLOCK) ON H1.[SapId] = P.[GroupId] AND H1.[Deleted] = 0
	WHERE	(@Add = @SyncType AND PR.[Id] IS NOT NULL)
			OR (P.[GroupId] IS NOT NULL AND (H1.[Id] IS NULL OR H1.[Deleted] = 1))


	-- Insert nuevos
	IF @Add <= @SyncType
	BEGIN
		-- Insert nuevos 
		INSERT [dbo].[POIHierarchyLevel2] ([SapId], [Name], [Society], [HierarchyLevel1Id], [Deleted], [CreatedDate], [IdUser])
		SELECT  P.[Id],
				P.[Name],
				P.[Society],
				PP.[Id],
				0,
				GETUTCDATE(),
				1
		FROM    @Data P
				LEFT OUTER JOIN [dbo].[POIHierarchyLevel2] PR ON PR.[SapId] = P.[Id]
				LEFT OUTER JOIN [dbo].[POIHierarchyLevel1] PP ON PP.[SapId] = P.[GroupId]
		WHERE   PR.[Id] IS NULL
				AND (P.[GroupId] IS NULL OR PP.[Id] IS NOT NULL)
	END
	

END
