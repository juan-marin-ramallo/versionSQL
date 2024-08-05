/****** Object:  Procedure [dbo].[GetEventTypes]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 11/05/2013
-- Description:	SP para obtener los tipos de eventos
-- =============================================
CREATE PROCEDURE [dbo].[GetEventTypes]
AS
BEGIN
	SELECT	[Code], [Description]
	FROM	[dbo].[EventTypeTranslated] WITH (NOLOCK)
	WHERE [Code] <> 'INE'
END
