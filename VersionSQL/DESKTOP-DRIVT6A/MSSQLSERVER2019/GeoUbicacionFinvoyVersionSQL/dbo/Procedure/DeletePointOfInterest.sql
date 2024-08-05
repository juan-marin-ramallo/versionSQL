/****** Object:  Procedure [dbo].[DeletePointOfInterest]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 25/09/2012
-- Description:	SP para eliminar un punto de interés
-- =============================================
CREATE PROCEDURE [dbo].[DeletePointOfInterest]
(
	 @Id [sys].[int]
)
AS
BEGIN
	DECLARE @Now [sys].[datetime]
    SET @Now = GETUTCDATE()

	UPDATE	[dbo].[PointOfInterest]
	SET		[Deleted] = 1, [Pending] = 0, [EditedDate] = @Now
	WHERE	Id = @Id

	--Cuando se borra el punto tengo que eliminar las rutas para ese punt de ahora en mas.
	Update	[dbo].[RoutePointOfInterest]
	SET [Deleted] = 1, [EditedDate] = @Now
	WHERE	[IdPointOfInterest] = @Id

	--Elimino todas las rutas que haya en RouteDetail posteriores a la fecha actual inclusive
	DELETE 
	FROM	dbo.[RouteDetail]
	WHERE	Tzdb.IsGreaterOrSameSystemDate([RouteDate], @Now) = 1 AND
			[IdRoutePointOfInterest] IN (SELECT [Id] 
										FROM [dbo].[RoutePointOfInterest]
										WHERE	[IdPointOfInterest] = @Id)

END
