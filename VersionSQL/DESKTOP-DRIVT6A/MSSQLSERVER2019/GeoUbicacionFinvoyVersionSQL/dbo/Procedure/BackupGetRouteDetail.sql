/****** Object:  Procedure [dbo].[BackupGetRouteDetail]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[BackupGetRouteDetail]
(
  @LimitDate [sys].[DATETIME]
)
AS
BEGIN
  SELECT a.[Id],a.[RouteDate],a.[IdRoutePointOfInterest],a.[Disabled],a.[DisabledType],a.[NoVisited],a.[IdRouteNoVisitOption],a.[DateNoVisited],a.[NoVisitedApprovedState],a.[IdUserNoVisitedApproved],a.[NoVisitedApprovedComment],a.[NoVisitedApprovedDate],a.[FromHour],a.[ToHour],a.[Title],a.[WebNoVisitComment],a.[IdUserWebNoVisitComment],a.[WebNoVisitCommentDate],a.[TheoricalMinutes]
  FROM [dbo].RouteDetail a WITH(NOLOCK)
  WHERE a.[RouteDate] < @LimitDate
  GROUP BY a.[Id],a.[RouteDate],a.[IdRoutePointOfInterest],a.[Disabled],a.[DisabledType],a.[NoVisited],a.[IdRouteNoVisitOption],a.[DateNoVisited],a.[NoVisitedApprovedState],a.[IdUserNoVisitedApproved],a.[NoVisitedApprovedComment],a.[NoVisitedApprovedDate],a.[FromHour],a.[ToHour],a.[Title],a.[WebNoVisitComment],a.[IdUserWebNoVisitComment],a.[WebNoVisitCommentDate],a.[TheoricalMinutes]
  ORDER BY a.[Id] ASC
END
