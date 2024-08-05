/****** Object:  Procedure [dbo].[UpdateAlternativeRoute]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 20/03/2018
-- Description:	SP para actualizar una ruta ALTERNATIVA desde el celular
-- =============================================
CREATE PROCEDURE [dbo].[UpdateAlternativeRoute]
(
	 @IdPersonOfInterest [sys].[INT]
	,@IdRoute [sys].[int]
	,@Date [sys].[datetime]
	,@FromHour [sys].[TIME](7) = null
	,@ToHour [sys].[TIME](7) = null
    ,@Comment [sys].[VARCHAR](230) = NULL
	,@Title [sys].[VARCHAR](250) = NULL
)
AS
BEGIN
	DECLARE @CurrentDate [sys].[DATETIME] = GETUTCDATE()
	DECLARE @IdRoutePointOfInterest [sys].[INT] = null
	DECLARE @IdRouteGroup [sys].[INT] = NULL
    
	SELECT @IdRouteGroup = rg.Id, @IdRoutePointOfInterest = rp.Id
	FROM [dbo].[RouteGroup] rg
		INNER JOIN [dbo].[RoutePointOfInterest] rp ON rg.id = rp.IdRouteGroup
		INNER JOIN [dbo].[RouteDetail] rd ON rp.Id = rd.IdRoutePointOfInterest
	WHERE rd.Id = @IdRoute AND rp.AlternativeRoute = 1 AND rp.[WebAssignment] = 0 AND rg.IdPersonOfInterest = @IdPersonOfInterest
	
	IF @IdRouteGroup IS NOT NULL AND @IdRoutePointOfInterest IS NOT NULL
	BEGIN
			UPDATE [dbo].[RouteDetail] 
			SET RouteDate = @Date,
				FromHour = @FromHour,
				ToHour = @ToHour,
				Title = @Title
			WHERE Id = @IdRoute
		
			UPDATE [dbo].[RoutePointOfInterest] 
			SET EditedDate = @CurrentDate,
				Comment = @Comment
			WHERE Id = @IdRoutePointOfInterest

			IF (SELECT COUNT(1) FROM [dbo].[RoutePointOfInterest] WHERE IdRouteGroup = @IdRouteGroup) > 1
			BEGIN
				UPDATE [dbo].[RouteGroup]
				SET EditedDate = @CurrentDate,
					[StartDate] = @CurrentDate,
					[EndDate] = @CurrentDate
  				WHERE Id = @IdRouteGroup 
			END
			ELSE
			BEGIN
				UPDATE [dbo].[RouteGroup] 
				SET EditedDate = @CurrentDate
				WHERE Id = @IdRouteGroup
			END
	END		
END
