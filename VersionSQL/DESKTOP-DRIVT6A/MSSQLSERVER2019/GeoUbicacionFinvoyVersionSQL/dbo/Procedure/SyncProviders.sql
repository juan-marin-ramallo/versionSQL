/****** Object:  Procedure [dbo].[SyncProviders]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 20/04/2015
-- Description:	SP para sincronizar los Productos
-- =============================================
CREATE PROCEDURE [dbo].[SyncProviders]
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
			,PR.[Deleted] = 0
	FROM	[dbo].[Provider] PR
			INNER JOIN @Data as P ON PR.[SapId] = P.[Id]
			
	-- Delete faltantes
	UPDATE	PR
	SET		PR.[Deleted] = 1
	FROM	[dbo].[Provider] PR
			LEFT OUTER JOIN @Data as P ON PR.[SapId] = P.[Id]
	WHERE	P.[Id] IS NULL

	-- Insert nuevos 
	INSERT [dbo].[Provider] ([SapId], [Name], [Society], [Deleted])
	SELECT  P.[Id],
			P.[Name],
			P.[Society],
			0
	FROM    @Data P
			LEFT OUTER JOIN [dbo].[Provider] PR ON PR.[SapId] = P.[Id]
	WHERE   PR.[Id] IS NULL

END
