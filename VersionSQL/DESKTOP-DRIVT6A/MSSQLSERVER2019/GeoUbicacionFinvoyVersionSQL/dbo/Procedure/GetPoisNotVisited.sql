/****** Object:  Procedure [dbo].[GetPoisNotVisited]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Diego Caceres
-- Create date: 16/08/2016
-- Description:	SP para saber si un punto fue marcado como no visitado por una persona de interes
-- =============================================
CREATE PROCEDURE [dbo].[GetPoisNotVisited]
(
	@Dates DatelistTableType READONLY
    ,@IdPersonOfInterest [sys].[INT]    
)
AS
BEGIN

	SELECT	RP.[IdPointOfInterest], RD.[RouteDate] AS DateNotVisited
	FROM	dbo.[RouteDetail] RD WITH (NOLOCK)
			INNER JOIN dbo.[RoutePointOfInterest] RP WITH (NOLOCK) ON RP.[Id] = RD.[IdRoutePointOfInterest]
			INNER JOIN dbo.[RouteGroup] RG WITH (NOLOCK) ON RG.[Id] = RP.[IdRouteGroup], 
			@Dates dates
	WHERE	RG.[IdPersonOfInterest] = @IdPersonOfInterest 
			AND RD.[NoVisited] = 1 AND Tzdb.AreSameSystemDates(RD.[RouteDate], dates.[Date]) = 1
        	
END
