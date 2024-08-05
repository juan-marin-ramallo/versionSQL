/****** Object:  Procedure [dbo].[PointOfInterestExists]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 11/11/2015
-- Description:	SP para saber si existe o no un punto de interés que no esté eliminado
-- =============================================
CREATE PROCEDURE [dbo].[PointOfInterestExists]
(
	@IdPointOfInterest [sys].[int]
)
AS
BEGIN
	SELECT P.[Id] FROM [dbo].[PointOfInterest] P WITH (NOLOCK) WHERE P.[Id] = @IdPointOfInterest AND P.[Deleted] = 0
END
