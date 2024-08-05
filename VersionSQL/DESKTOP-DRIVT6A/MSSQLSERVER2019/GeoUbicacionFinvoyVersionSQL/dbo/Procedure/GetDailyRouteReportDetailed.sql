/****** Object:  Procedure [dbo].[GetDailyRouteReportDetailed]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 30/01/2018
-- Description:	Sp que obtiene resumen de ruta y formularios dada una ruta y un día
-- =============================================
CREATE PROCEDURE [dbo].[GetDailyRouteReportDetailed]
(
	 @Route [sys].[VARCHAR](50)
	,@Date [sys].[datetime]
)
AS
BEGIN
	SELECT r.[Route], r.[Date]
		, r.PersonOfInterestName
		, r.PointOfInterestIdentifier, r.PointOfInterestName
		, r.Planned
		, r.Visited
		, r.VisitTime
		, r.NoVisitMessage
		, r.FormsCount, r.CompletedFormsCount
	FROM [dbo].[GetDailyRouteReportDetailedFiltered](@Route, @Date) AS r
END
