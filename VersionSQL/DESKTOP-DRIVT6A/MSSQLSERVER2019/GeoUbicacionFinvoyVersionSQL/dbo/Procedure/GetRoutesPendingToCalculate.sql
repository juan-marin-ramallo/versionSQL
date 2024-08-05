/****** Object:  Procedure [dbo].[GetRoutesPendingToCalculate]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 10/11/2015
-- Description:	SP para obtener las rutas que hay que reprocesar porque terminaron los 6 meses.
-- =============================================
CREATE PROCEDURE [dbo].[GetRoutesPendingToCalculate]
(
	@Date [sys].DATETIME 
)
AS
BEGIN

	SELECT		RP.[Id], RG.[StartDate], RG.[EndDate], RP.[Comment], RP.[RecurrenceCondition], RP.[RecurrenceNumber], RP.[EditedDate],
				P.[Id] AS IdPersonOfInterest, P.[Name] AS PersonOfInterestName, P.[LastName] AS PersonOfInterestLastName,
				POI.[Id] AS IdPointOfInterest, POI.[Name] AS PointOfInterestName, 
				MAX(RD.[RouteDate]) AS LastRouteDetailDate
	
	FROM		[dbo].[RouteGroup] RG
				INNER JOIN [dbo].[RoutePointOfInterest] RP ON RP.[IdRouteGroup] = RG.[Id]
				INNER JOIN [dbo].[PersonOfInterest] P ON P.[Id] = RG.[IdPersonOfInterest]
				INNER JOIN [dbo].[PointOfInterest] POI ON  POI.[Id] = RP.[IdPointOfInterest]
				LEFT JOIN [dbo].[RouteDetail] RD ON RD.[IdRoutePointOfInterest] = RP.[Id]

	WHERE		RP.[AlternativeRoute] = 0 AND RP.[Deleted] = 0 AND P.[Deleted] = 0 AND POI.[Deleted] = 0 
				AND RD.[Disabled] = 0 AND
				(CAST(RG.[EndDate] AS [sys].[date]) > CAST(DATEADD(DAY, 14, @Date) AS [sys].[date]))  AND 
				CAST(DATEADD(DAY, 14, @Date) AS [sys].[date]) > (SELECT MAX(RD2.[RouteDate]) 
																 FROM [dbo].[RouteDetail] RD2
																 WHERE RD2.[IdRoutePointOfInterest] = RP.[Id] )
				
	GROUP BY	RP.[Id], RG.[StartDate], RG.[EndDate], RP.[Comment], RP.[RecurrenceCondition], RP.[RecurrenceNumber], RP.[EditedDate],
				P.[Id], P.[Name], P.[LastName],POI.[Id], POI.[Name]

	ORDER BY	RP.[Id]
END
