/****** Object:  Procedure [dbo].[GetMobileFileLogsForDownload]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 02/12/2020
-- Description:	SP para obtener los archivos de log recibidos desde la app dado sus ids
-- =============================================
CREATE PROCEDURE [dbo].[GetMobileFileLogsForDownload]
	 @Ids IdTableType READONLY
AS
BEGIN
	SELECT		MFL.[Id], MFL.[Name]
	FROM		[dbo].[MobileFileLog] MFL WITH (NOLOCK)
				INNER JOIN @Ids I ON I.[Id] = MFL.[Id]
END
