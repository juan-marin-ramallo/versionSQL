/****** Object:  Procedure [dbo].[IsPointNotVisited]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Diego Caceres
-- Create date: 16/08/2016
-- Description:	SP para saber si un punto fue marcado como no visitado por una persona de interes
-- =============================================
CREATE PROCEDURE [dbo].[IsPointNotVisited]
(
	 @IsNotVisitedResult[sys].[bit] OUTPUT
	,@Date [sys].DATETIME
	,@IdPointOfInterest [sys].[INT]
    ,@IdPersonOfInterest [sys].[INT]    
)
AS
BEGIN

	DECLARE @RouteDetailNotVisitedId [sys].[INT]
	
	SET @RouteDetailNotVisitedId = (
					SELECT RD.[Id]
					FROM [dbo].[RouteDetail] RD WITH (NOLOCK)
						INNER JOIN [dbo].[RoutePointOfInterest] RP WITH (NOLOCK) ON RP.[Id] = RD.[IdRoutePointOfInterest] 
						INNER JOIN [dbo].[RouteGroup] RG WITH (NOLOCK) ON RG.[Id] = RP.[IdRouteGroup]
					WHERE RG.[IdPersonOfInterest] = @IdPersonOfInterest AND RP.[IdPointOfInterest] = @IdPointOfInterest
						AND RD.[NoVisited] = 1 AND Tzdb.AreSameSystemDates(RD.[RouteDate], @Date) = 1)

	IF @RouteDetailNotVisitedId IS NULL
	BEGIN
		SET @IsNotVisitedResult = 0
	END
	ELSE
	BEGIN
		SET @IsNotVisitedResult = 1
	END
        	
END
