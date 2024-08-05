/****** Object:  Procedure [dbo].[GetPendingPointsOfInterest]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 05/07/2018
-- Description:	SP para obtener los puntos de interés pendientes de confirmaciOn
-- =============================================
CREATE PROCEDURE [dbo].[GetPendingPointsOfInterest]
(
	 @IdPointsOfInterest [sys].[varchar](max) = NULL
	,@IdUser [sys].[int] = NULL
)
AS
BEGIN
	SELECT		P.[Id], P.[Name], P.[Address], P.[Identifier], P.[Latitude], P.[Longitude], 
				P.[Radius], P.[MinElapsedTimeForVisit], P.[NFCTagId],
				P.[IdDepartment], D.[Name] AS DepartmentName, PZ.IdZone, P.[ContactName], P.[ContactPhoneNumber],
				P.[GrandfatherId] AS HierarchyLevel1Id, P.[FatherId] AS HierarchyLevel2Id, P.[Image] AS PointOfInterestImage,
				P.[ImageUrl], P.[Emails],P.[IdPersonOfInterest],PE.[Identifier] as PersonOfInterestIdentifier ,PE.[Name] as NamePersonInterest,PE.[LastName] as LastNamePersonInterest
						
	FROM		[dbo].[PointOfInterest] P
				LEFT OUTER JOIN dbo.PointOfInterestZone PZ ON PZ.IdPointOfInterest = P.Id
				LEFT OUTER JOIN dbo.Department D ON D.Id = P.IdDepartment
				LEFT OUTER JOIN dbo.PersonOfInterest PE on PE.id = P.IdPersonOfInterest

	WHERE		P.[Deleted] = 1 AND P.[Pending] = 1 AND
				((@IdPointsOfInterest IS NULL) OR (dbo.CheckValueInList(P.[Id], @IdPointsOfInterest) = 1))
	
	GROUP BY	P.[Id], P.[Name], P.[Address], P.[Identifier], P.[Latitude], P.[Longitude], P.[Radius], 
				P.[MinElapsedTimeForVisit], P.[IdDepartment], D.[Name], P.[NFCTagId],PZ.IdZone, P.[ContactName], 
				P.[ContactPhoneNumber], P.[GrandfatherId], P.[FatherId], P.[Image], P.[ImageUrl], P.[Emails],
				P.[IdPersonOfInterest],PE.[Name],PE.[LastName],PE.[Identifier]
END
