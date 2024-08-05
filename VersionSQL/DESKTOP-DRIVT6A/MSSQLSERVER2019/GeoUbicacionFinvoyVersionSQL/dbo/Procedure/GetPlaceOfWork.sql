/****** Object:  Procedure [dbo].[GetPlaceOfWork]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 25/08/2023 (Independence day!)
-- Description:	SP para obtener los datos de
--              un empleador dado su id
-- =============================================
CREATE PROCEDURE [dbo].[GetPlaceOfWork]
    @Id [sys].[int]
AS
BEGIN
    SELECT  [Id], [Name], [BusinessName], [Identifier]
    FROM    [dbo].[PlaceOfWork] WITH (NOLOCK)
	WHERE	[Id] = @Id;
END
