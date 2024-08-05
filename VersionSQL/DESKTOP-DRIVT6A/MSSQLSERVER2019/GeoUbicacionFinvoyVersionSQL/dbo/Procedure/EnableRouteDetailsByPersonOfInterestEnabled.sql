/****** Object:  Procedure [dbo].[EnableRouteDetailsByPersonOfInterestEnabled]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author: Jesús Portillo
-- Create date: 13/04/2020
-- Description:	SP para habilitar detalle de rutas para una persona de interés activada
-- =============================================
CREATE PROCEDURE [dbo].[EnableRouteDetailsByPersonOfInterestEnabled]
(
	 @IdPersonOfInterest [sys].[int]
  ,@FromDate [sys].[datetime]
)
AS
BEGIN

  UPDATE  RD
  SET     RD.[Disabled] = 0,
          RD.[DisabledType] = NULL
  FROM    [dbo].[RouteDetail] RD
          INNER JOIN [dbo].[RoutePointOfInterest] RPOI ON RPOI.[Id] = RD.[IdRoutePointOfInterest]
          INNER JOIN [dbo].[RouteGroup] RG ON RG.[Id] = RPOI.[IdRouteGroup]
  WHERE   RD.[Disabled] = 1 AND RD.[DisabledType] = 2 -- Person of Interest disabled
          AND RG.[IdPersonOfInterest] = @IdPersonOfInterest
          AND RD.[RouteDate] >= @FromDate

END
