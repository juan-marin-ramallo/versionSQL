/****** Object:  Procedure [dbo].[GetPointsOfInterest]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 01/10/2012
-- Description:	SP para obtener los puntos de interés
-- =============================================
CREATE PROCEDURE [dbo].[GetPointsOfInterest]
(
	 @IdPointsOfInterest [sys].[varchar](max) = NULL
	,@GrandFathersId varchar(max) = NULL
	,@FathersId varchar(max) = NULL
	,@IdUser [sys].[int] = NULL
)
AS
BEGIN
	SELECT		P.[Id], P.[Name], P.[Address], P.[Identifier], P.[Latitude], P.[Longitude], 
				P.[Radius], P.[MinElapsedTimeForVisit], P.[NFCTagId],
				P.[IdDepartment], D.[Name] AS DepartmentName,
				PZ.IdZone, P.[ContactName], P.[ContactPhoneNumber],
				P.[GrandfatherId] AS HierarchyLevel1Id, P.[FatherId] AS HierarchyLevel2Id, P.[Emails]
						
	FROM		[dbo].[PointOfInterest] P WITH(NOLOCK)
				LEFT OUTER JOIN dbo.PointOfInterestZone PZ WITH(NOLOCK) ON PZ.IdPointOfInterest = P.Id
				LEFT OUTER JOIN dbo.Department D WITH(NOLOCK) ON D.Id = P.IdDepartment

	WHERE		P.[Deleted] = 0 AND
				((@IdPointsOfInterest IS NULL) OR (dbo.CheckValueInList(P.[Id], @IdPointsOfInterest) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1))
	
	GROUP BY	P.[Id], P.[Name], P.[Address], P.[Identifier], P.[Latitude], P.[Longitude], P.[Radius], P.[MinElapsedTimeForVisit], 
				P.[IdDepartment], D.[Name], P.[NFCTagId],
				PZ.IdZone, P.[ContactName], P.[ContactPhoneNumber],
				P.[GrandfatherId], P.[FatherId], P.[Emails]
END
