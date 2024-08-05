/****** Object:  Procedure [dbo].[DeleteAlternativeRoute]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 20/03/2018
-- Description:	SP para elminar una ruta ALTERNATIVA desde el celular
-- =============================================
CREATE PROCEDURE [dbo].[DeleteAlternativeRoute]
(
	 @IdPersonOfInterest [sys].[INT]
	,@IdRoute [sys].[int]
)
AS
BEGIN
	--DECLARE @CurrentDate [sys].[DATETIME] = GETUTCDATE()
	DECLARE @IdRoutePointOfInterest [sys].[INT] = null
	DECLARE @IdRouteGroup [sys].[INT] = NULL
    
	SELECT	@IdRouteGroup = RG.[Id], @IdRoutePointOfInterest = RP.[Id]
	FROM	[dbo].[RouteGroup] RG
			INNER JOIN [dbo].[RoutePointOfInterest] RP ON RG.[Id] = RP.[IdRouteGroup]
			INNER JOIN [dbo].[RouteDetail] RD ON RP.[Id] = RD.[IdRoutePointOfInterest]
	WHERE	RD.[Id] = @IdRoute AND RP.[AlternativeRoute] = 1 AND RP.[WebAssignment] = 0 
			AND RG.[IdPersonOfInterest] = @IdPersonOfInterest
	
	IF @IdRouteGroup IS NOT NULL AND @IdRoutePointOfInterest IS NOT NULL
	BEGIN
		UPDATE [dbo].[RouteDetail] 
		SET [Disabled] = 1,
			[DisabledType] = 1
		WHERE [Id] = @IdRoute
	END

	--IF @IdRouteGroup IS NOT NULL AND @IdRoutePointOfInterest IS NOT NULL
	--BEGIN
	--		UPDATE [dbo].[RouteDetail] 
	--		SET [Disabled] = 1
	--		WHERE Id = @IdRoute

	--		IF (SELECT COUNT(1) FROM [dbo].[RoutePointOfInterest] WHERE IdRouteGroup = @IdRouteGroup) > 1
	--		BEGIN
	--			UPDATE	[dbo].[RouteGroup]
	--			SET		[EditedDate] = @CurrentDate,
	--					[Deleted] = 1
 -- 				WHERE	[Id] = @IdRouteGroup 
		
	--			UPDATE	[dbo].[RoutePointOfInterest] 
	--			SET		[EditedDate] = @CurrentDate,
	--					[Deleted] = 1
	--			WHERE	[Id] = @IdRoutePointOfInterest
	--		END
	--		ELSE
	--		BEGIN
	--			UPDATE	[dbo].[RouteGroup] 
	--			SET		[EditedDate] = @CurrentDate
	--			WHERE	[Id] = @IdRouteGroup
		
	--			UPDATE	[dbo].[RoutePointOfInterest] 
	--			SET		[EditedDate] = @CurrentDate
	--			WHERE	[Id] = @IdRoutePointOfInterest
	--		END
	--END		
END
