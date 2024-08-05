/****** Object:  Procedure [dbo].[DisableRouteDetailsByPersonOfInterestDisabled]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author: Jesús Portillo
-- Create date: 13/04/2020
-- Description:	SP para deshabilitar detalle de rutas para una persona de interés desactivada
-- =============================================
CREATE PROCEDURE [dbo].[DisableRouteDetailsByPersonOfInterestDisabled]
(
	 @IdPersonOfInterest [sys].[int]
  ,@FromDate [sys].[datetime]
)
AS
BEGIN

  UPDATE  RD
  SET     RD.[Disabled] = 1,
          RD.[DisabledType] = 2 -- Person of Interest disabled
  FROM    [dbo].[RouteDetail] RD
          INNER JOIN [dbo].[RoutePointOfInterest] RPOI ON RPOI.[Id] = RD.[IdRoutePointOfInterest]
          INNER JOIN [dbo].[RouteGroup] RG ON RG.[Id] = RPOI.[IdRouteGroup]
  WHERE   RD.[Disabled] = 0
          AND RG.[IdPersonOfInterest] = @IdPersonOfInterest
          AND RD.[RouteDate] >= @FromDate
    
END
