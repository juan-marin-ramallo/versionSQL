/****** Object:  Procedure [dbo].[GetPersonsOfInterestForFiscalization]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 28/08/2023
-- Description:	SP para obtener las personas de
--              interés disponibles para uso en
--              fiscalización
-- =============================================
CREATE PROCEDURE [dbo].[GetPersonsOfInterestForFiscalization]
(
	@IdPersonOfInterest [sys].[int] = NULL
)
AS
BEGIN
	SELECT		S.[Id], S.[Name], S.[LastName], S.[Identifier]
    FROM		[dbo].[AvailablePersonOfInterest] S WITH (NOLOCK)
    WHERE       @IdPersonOfInterest IS NULL OR S.[Id] = @IdPersonOfInterest
    ORDER BY    S.[Name], S.[LastName]
END
