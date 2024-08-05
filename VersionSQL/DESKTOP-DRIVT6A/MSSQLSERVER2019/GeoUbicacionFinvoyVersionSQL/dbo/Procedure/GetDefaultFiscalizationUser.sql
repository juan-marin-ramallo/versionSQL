/****** Object:  Procedure [dbo].[GetDefaultFiscalizationUser]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 18/08/2023
-- Description:	SP para obtener el usuario
--				fiscalizador genérico
-- =============================================
CREATE PROCEDURE [dbo].[GetDefaultFiscalizationUser]
AS
BEGIN
	SELECT	[Id], [Name]
	FROM	[dbo].[FiscalizationUser] WITH (NOLOCK)
    WHERE   [Id] = 1
END
