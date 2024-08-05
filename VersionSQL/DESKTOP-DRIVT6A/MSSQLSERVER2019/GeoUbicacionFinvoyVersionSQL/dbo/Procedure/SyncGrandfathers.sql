/****** Object:  Procedure [dbo].[SyncGrandfathers]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 20/04/2015
-- Description:	SP para sincronizar las jerarquias nivel 1
-- =============================================
CREATE PROCEDURE [dbo].[SyncGrandfathers]
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
				,PR.[Deleted] = 0
		FROM	[dbo].[POIHierarchyLevel1] PR
				INNER JOIN @Data as P ON PR.[SapId] = P.[Id]
	END	

	-- Delete faltantes
	IF @AddUpdateDelete <= @SyncType
	BEGIN
		-- Delete faltantes
		UPDATE	PR
		SET		PR.[Deleted] = 1
		FROM	[dbo].[POIHierarchyLevel1] PR
				LEFT OUTER JOIN @Data as P ON PR.[SapId] = P.[Id]
		WHERE	P.[Id] IS NULL

		
		UPDATE	POIH2
		SET		[HierarchyLevel1Id] = NULL
		FROM	[dbo].[POIHierarchyLevel2] POIH2
				INNER JOIN [dbo].[POIHierarchyLevel1] POIH1 ON POIH1.Id = POIH2.HierarchyLevel1Id
				LEFT OUTER JOIN @Data as P ON POIH1.[SapId] = P.[Id]
		WHERE	P.[Id] IS NULL

		UPDATE	POI
		SET		[GrandfatherId] = NULL
		FROM	[dbo].[PointOfInterest] POI
				INNER JOIN [dbo].[POIHierarchyLevel1] POIH1 ON POIH1.Id = POI.GrandfatherId
				LEFT OUTER JOIN @Data as P ON POIH1.[SapId] = P.[Id]
		WHERE	P.[Id] IS NULL
	
	END

	-- Si solo agrego Obtengo los repetidos antes de agregar los nuevos
	-- de lo contrario siempre van a existir	
	SELECT P.[Id],P.[Name]
	FROM	@Data P
			LEFT OUTER JOIN [dbo].[POIHierarchyLevel1] PR ON PR.[SapId] = P.[Id] AND PR.[Deleted] = 0
	WHERE   @Add = @SyncType AND PR.[Id] IS NOT NULL


	-- Insert nuevos
	IF @Add <= @SyncType
	BEGIN
		-- Insert nuevos 
		INSERT [dbo].[POIHierarchyLevel1] ([SapId], [Name], [Society], [Deleted], [CreatedDate], [IdUser])
		SELECT  P.[Id],
				P.[Name],
				P.[Society],
				0,
				GETUTCDATE(),
				1
		FROM    @Data P
				LEFT OUTER JOIN [dbo].[POIHierarchyLevel1] PR ON PR.[SapId] = P.[Id]
		WHERE   PR.[Id] IS NULL
	END
END
