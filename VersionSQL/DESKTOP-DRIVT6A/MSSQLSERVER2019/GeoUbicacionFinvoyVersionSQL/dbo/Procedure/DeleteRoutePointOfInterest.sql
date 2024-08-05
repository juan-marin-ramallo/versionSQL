/****** Object:  Procedure [dbo].[DeleteRoutePointOfInterest]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 18/06/2015
-- Description:	SP para eliminar un punto de una ruta planificada logicamente. 
-- Borra de RouteDetail todas las visitas planificadas a partir de la fecha inclusive
-- =============================================
CREATE PROCEDURE [dbo].[DeleteRoutePointOfInterest]
	@IdRoutePointOfInterest [sys].[int]
AS
BEGIN
	DECLARE @Now [sys].[datetime]
	SET @Now = GETUTCDATE()

	Update	[dbo].[RoutePointOfInterest]
	SET [Deleted] = 1, [EditedDate] = @Now
	WHERE	[Id] = @IdRoutePointOfInterest

	--Elimino todas las rutas que haya en RouteDetail posteriores a la fecha actual inclusive
	DELETE 
	FROM	dbo.[RouteDetail]
	WHERE	[IdRoutePointOfInterest] = @IdRoutePointOfInterest 
			AND Tzdb.IsGreaterOrSameSystemDate([RouteDate], @Now) = 1

END
