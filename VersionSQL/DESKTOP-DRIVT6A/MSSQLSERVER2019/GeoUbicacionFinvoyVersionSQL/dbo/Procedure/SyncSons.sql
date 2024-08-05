﻿/****** Object:  Procedure [dbo].[SyncSons]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 20/04/2015
-- Description:	SP para sincronizar los Productos
-- =============================================
CREATE PROCEDURE [dbo].[SyncSons]
(
	 @Data [AgrupationTableType] READONLY
)
AS
BEGIN
	-- Update ingresados
	UPDATE	PR
	SET		PR.[SapId] = P.[Id]
			,PR.[Name] = P.[Name]
			,PR.[Society] = P.[Society]
			,PR.[FatherId] = PP.[Id]
			,PR.[Deleted] = 0
	FROM	[dbo].[Son] PR
			INNER JOIN @Data as P ON PR.[SapId] = P.[Id]
			LEFT OUTER JOIN [dbo].[POIHierarchyLevel2] PP ON PP.[SapId] = P.[GroupId]
	WHERE	P.[GroupId] IS NULL OR PP.[Id] IS NOT NULL
			
	-- Delete faltantes
	UPDATE	PR
	SET		PR.[Deleted] = 1
	FROM	[dbo].[Son] PR
			LEFT OUTER JOIN @Data as P ON PR.[SapId] = P.[Id]
	WHERE	P.[Id] IS NULL

	-- Insert nuevos 
	INSERT [dbo].[Son] ([SapId], [Name], [Society], [FatherId], [Deleted])
	SELECT  P.[Id],
			P.[Name],
			P.[Society],
			PP.[Id],
			0
	FROM    @Data P
			LEFT OUTER JOIN [dbo].[Son] PR ON PR.[SapId] = P.[Id]
			LEFT OUTER JOIN [dbo].[POIHierarchyLevel2] PP ON PP.[SapId] = P.[GroupId]
	WHERE   PR.[Id] IS NULL
			AND	(P.[GroupId] IS NULL OR PP.[Id] IS NOT NULL)

	-- Obtengo los que no tiene referencia
	SELECT P.[Id], P.[Name], P.[Society], P.[GroupId]
    FROM	@Data P
			LEFT OUTER JOIN [dbo].[POIHierarchyLevel2] PP ON PP.[SapId] = P.[GroupId]
    WHERE   P.[GroupId] IS NOT NULL AND PP.[Id] IS NULL

END
