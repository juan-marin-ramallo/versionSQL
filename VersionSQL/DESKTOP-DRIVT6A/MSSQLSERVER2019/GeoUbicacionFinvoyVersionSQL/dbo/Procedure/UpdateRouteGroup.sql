/****** Object:  Procedure [dbo].[UpdateRouteGroup]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Gastón Legnani
-- Create date: 24/08/2015
-- Description:	SP para actualizar una ruta agrupada
-- =============================================
CREATE PROCEDURE [dbo].[UpdateRouteGroup]
(
	 @IdRouteGroup [sys].[int] = NULL
	,@EndDate [sys].DATETIME = NULL
	,@RouteName [sys].VARCHAR(50) = NULL
)
AS
BEGIN
	
	DECLARE @ActualEndDate [sys].[datetime] = (SELECT [EndDate] FROM [dbo].[RouteGroup] WITH (NOLOCK) WHERE [Id] = @IdRouteGroup)

	UPDATE	[dbo].[RouteGroup]	
	SET		[Name] = @RouteName, [EndDate] = @EndDate, [EditedDate] = GETUTCDATE()	
	WHERE	[Id] = @IdRouteGroup	

	--Actualizar visitas
	IF @ActualEndDate > @EndDate --Si nueva fecha de fin es menor a la que estaba elimino lo que hay despues
	BEGIN
		DELETE FROM [dbo].[RouteDetail]
		WHERE		[RouteDate] > @EndDate AND [IdRoutePointOfInterest] 
					IN (SELECT [Id] FROM [dbo].[RoutePointOfInterest] WITH (NOLOCK) WHERE [IdRouteGroup] = @IdRouteGroup)
	END

END
