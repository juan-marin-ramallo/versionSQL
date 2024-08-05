/****** Object:  Procedure [dbo].[DeletePersonOfInterest]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 25/09/2012
-- Description:	SP para eliminar un repositor
-- =============================================
CREATE PROCEDURE [dbo].[DeletePersonOfInterest]
(
	 @Id [sys].[int]
)
AS
BEGIN
	UPDATE	[dbo].[PersonOfInterest]
	SET		[Deleted] = 1
	WHERE	Id = @Id

	DELETE FROM PersonOfInterestZone
	WHERE IdPersonOfInterest = @Id And IdZone NOT IN (SELECT Id from [Zone] WHERE ApplyToAllPersonOfInterest = 1)

	--Elimino las rutas que tiene asignada la persona desde la fecha en adelante
	UPDATE [dbo].[RouteGroup]
	SET [Deleted] = 1, [EditedDate] = GETUTCDATE()
	WHERE [IdPersonOfInterest] = @Id AND EndDate > GETUTCDATE()

	--Elimino todas las rutas que haya en RouteDetail y RoutePointOfInterest posteriores a la fecha actual.
	UPDATE	dbo.[RoutePointOfInterest]
	SET		[Deleted] = 1, [EditedDate] = GETUTCDATE()
	WHERE	[IdRouteGroup] IN (SELECT [Id] FROM [dbo].[RouteGroup] WHERE [IdPersonOfInterest] = @Id AND [EndDate] > GETUTCDATE()) 

	DELETE FROM [dbo].[RouteDetail]
	WHERE [RouteDate] > GETUTCDATE() AND [IdRoutePointOfInterest] IN
	(SELECT [Id] FROM [dbo].[RoutePointOfInterest] WHERE 
	[IdRouteGroup] IN (SELECT [Id] FROM [dbo].[RouteGroup] WHERE [IdPersonOfInterest] = @Id AND [EndDate] > GETUTCDATE())) 

END
