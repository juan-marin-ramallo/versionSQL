/****** Object:  Procedure [dbo].[DeleteRouteGroup]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 18/06/2015
-- Description:	SP para eliminar un grupo de rutas logicamente. 
-- Borra de RouteDetail todas las visitas planificadas a partir de la fecha inclusive
-- =============================================
CREATE PROCEDURE [dbo].[DeleteRouteGroup]
	@IdRouteGroup [sys].[int]
AS
BEGIN
	BEGIN TRANSACTION;
    SAVE TRANSACTION DeleteRouteCompleted;
	BEGIN TRY

	DECLARE @Now [sys].[datetime]
	SET @Now = GETUTCDATE()

	UPDATE	[dbo].[RouteGroup]
	SET		[Deleted] = 1, [EditedDate] = @Now
	WHERE	[Id] = @IdRouteGroup

	UPDATE	[dbo].[RoutePointOfInterest]
	SET		[Deleted] = 1, [EditedDate] = @Now
	WHERE	[IdRouteGroup] = @IdRouteGroup

	--Elimino todas las rutas que haya en RouteDetail posteriores a la fecha actual inclusive
	DELETE 
	FROM	dbo.[RouteDetail]
	WHERE	Tzdb.IsGreaterOrSameSystemDate([RouteDate], @Now) = 1 AND
			[IdRoutePointOfInterest] IN (SELECT [Id] FROM [dbo].[RoutePointOfInterest]
											WHERE [IdRouteGroup] = @IdRouteGroup)
	
	END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION DeleteRouteCompleted; -- rollback to DeleteRouteCompleted
        END
    END CATCH
    COMMIT TRANSACTION 
END
