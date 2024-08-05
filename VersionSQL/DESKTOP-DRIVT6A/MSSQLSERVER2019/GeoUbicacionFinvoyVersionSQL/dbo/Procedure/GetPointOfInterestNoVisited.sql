/****** Object:  Procedure [dbo].[GetPointOfInterestNoVisited]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 10/07/2015
-- Description:	SP para obtener el reporte de rutas
-- =============================================
CREATE PROCEDURE [dbo].[GetPointOfInterestNoVisited]
(
	 @Id [sys].[int] = NULL
)
AS
BEGIN

	-- Report
	SELECT	r.Id ,[RouteDate]
      ,[IdRoutePointOfInterest]
      ,[Disabled]
      ,[NoVisited]
      ,[IdRouteNoVisitOption]
      ,[DateNoVisited]
      ,rnvo.[Description] as NoVisitOptionText,
	  p.Id as PointOfInterestId, p.Name as PointOfInterestName, p.Identifier as PointOfInterestIdentifier,
	  s.Id as PersonOfInterestId, s.Name as PersonOfInterestName, s.LastName as PersonOfInterestLastName
	FROM [dbo].[RouteDetail] r
		inner join [dbo].RoutePointOfInterest rp on r.[IdRoutePointOfInterest] = rp.Id
		inner join [dbo].PointOfInterest p on rp.IdPointOfInterest = p.Id
		INNER JOIN dbo.[RouteGroup] RG ON RG.[Id] = RP.[IdRouteGroup]
		LEFT OUTER JOIN [dbo].[PersonOfInterest] S ON S.[Id] = RG.[IdPersonOfInterest]
		inner join [dbo].[RouteNoVisitOption] rnvo on r.IdRouteNoVisitOption = rnvo.Id
	WHERE r.Id = @Id
    
END
