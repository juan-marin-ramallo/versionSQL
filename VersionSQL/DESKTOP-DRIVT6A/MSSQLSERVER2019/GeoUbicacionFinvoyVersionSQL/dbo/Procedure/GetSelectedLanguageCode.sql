/****** Object:  Procedure [dbo].[GetSelectedLanguageCode]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesus Portillo
-- Create date: 10/05/2019
-- Description:	SP para obtener el codigo de idioma seleccionado
-- =============================================
CREATE PROCEDURE [dbo].[GetSelectedLanguageCode]
AS
BEGIN
	SELECT	[Code]
	FROM	[dbo].[Language] WITH (NOLOCK)
	WHERE	[Selected] = 1
END
