/****** Object:  Procedure [dbo].[SyncSubcategories]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 20/04/2015
-- Description:	SP para sincronizar los Productos
-- =============================================
CREATE PROCEDURE [dbo].[SyncSubcategories]
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
			,PR.[CategoryId] = PP.[Id]
			,PR.[Deleted] = 0
	FROM	[dbo].[Subcategory] PR
			INNER JOIN @Data as P ON PR.[SapId] = P.[Id]
			LEFT OUTER JOIN [dbo].[Category] PP ON PP.[SapId] = P.[GroupId]
	WHERE	P.[GroupId] IS NULL OR PP.[Id] IS NOT NULL
			
	-- Delete faltantes
	UPDATE	PR
	SET		PR.[Deleted] = 1
	FROM	[dbo].[Subcategory] PR
			LEFT OUTER JOIN @Data as P ON PR.[SapId] = P.[Id]
	WHERE	P.[Id] IS NULL

	-- Insert nuevos 
	INSERT [dbo].[Subcategory] ([SapId], [Name], [Society], [CategoryId], [Deleted])
	SELECT  P.[Id],
			P.[Name],
			P.[Society],
			PP.[Id],
			0
	FROM    @Data P
			LEFT OUTER JOIN [dbo].[Subcategory] PR ON PR.[SapId] = P.[Id]
			LEFT OUTER JOIN [dbo].[Category] PP ON PP.[SapId] = P.[GroupId]
	WHERE   PR.[Id] IS NULL
			AND	(P.[GroupId] IS NULL OR PP.[Id] IS NOT NULL)

	-- Obtengo los que no tiene referencia
	SELECT P.[Id], P.[Name], P.[Society], P.[GroupId]
    FROM	@Data P
			LEFT OUTER JOIN [dbo].[Category] PP ON PP.[SapId] = P.[GroupId]
    WHERE   P.[GroupId] IS NOT NULL AND PP.[Id] IS NULL

END
