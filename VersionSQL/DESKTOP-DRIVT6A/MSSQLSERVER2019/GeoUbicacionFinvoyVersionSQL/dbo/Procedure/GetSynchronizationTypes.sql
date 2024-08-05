/****** Object:  Procedure [dbo].[GetSynchronizationTypes]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Gaston L.
-- Create date: 27/07/2016
-- Description:	SP para obtener el archivo asociado a una promoción comercial
-- =============================================
CREATE PROCEDURE [dbo].[GetSynchronizationTypes]
AS
BEGIN
	SELECT	[Code], [Text]
	FROM	dbo.[SynchronizationTypeTranslated] WITH (NOLOCK)
	ORDER BY [Code] ASC
END
