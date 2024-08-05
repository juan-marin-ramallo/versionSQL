/****** Object:  Procedure [dbo].[GetRouteGroup]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Gastón Legnani
-- Create date: 24/08/2015
-- Description:	SP para actualizar una ruta agrupada
-- =============================================
CREATE PROCEDURE [dbo].[GetRouteGroup]
(
	 @IdRouteGroup [sys].[int] = NULL
)
AS
BEGIN

	--******************************************

	SELECT	RG.[Id], RG.[Name], RG.[IdPersonOfInterest], RG.[StartDate], RG.[EndDate],
			P.[Name] as PersonOfInterestName, P.[LastName] as PersonOfInterestLastName
	
	FROM	[dbo].[RouteGroup] RG
	INNER JOIN [dbo].[PersonOfInterest] P ON P.[Id] = RG.[IdPersonOfInterest]
	
	WHERE	RG.[Id] = @IdRouteGroup	
END
