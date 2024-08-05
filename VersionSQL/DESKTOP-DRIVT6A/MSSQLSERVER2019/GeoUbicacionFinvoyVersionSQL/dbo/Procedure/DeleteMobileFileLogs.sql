/****** Object:  Procedure [dbo].[DeleteMobileFileLogs]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 02/12/2020
-- Description:	SP para eliminar archivos de log de la app
-- =============================================
CREATE PROCEDURE [dbo].[DeleteMobileFileLogs]
(
	@Ids [dbo].IdTableType READONLY
)
AS
BEGIN
	DELETE	MFL
	OUTPUT	DELETED.[Id], DELETED.[Name]
	FROM	[dbo].[MobileFileLog] MFL
			INNER JOIN @Ids I ON I.[Id] = MFL.[Id]
END
