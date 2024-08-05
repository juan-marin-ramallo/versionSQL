/****** Object:  Procedure [dbo].[GetPlacesOfWork]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 25/08/2023 (Independence day!)
-- Description:	SP para obtener los datos de
--              los empleadores disponibles para
--              personas subcontratadas
-- =============================================
CREATE PROCEDURE [dbo].[GetPlacesOfWork]
AS
BEGIN
    SELECT  [Id], [Name], [BusinessName], [Identifier]
    FROM    [dbo].[PlaceOfWork] WITH (NOLOCK)
	WHERE	[Deleted] = 0;
END
