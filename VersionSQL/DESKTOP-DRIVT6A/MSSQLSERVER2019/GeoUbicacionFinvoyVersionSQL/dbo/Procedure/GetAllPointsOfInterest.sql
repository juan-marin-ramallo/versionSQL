/****** Object:  Procedure [dbo].[GetAllPointsOfInterest]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 14/08/2015
-- Description:	SP para obtener todos los puntos de interés eliminados o no
-- =============================================
CREATE PROCEDURE [dbo].[GetAllPointsOfInterest]
(
	 @IdPointsOfInterest [sys].[varchar](max) = NULL
	,@IdUser [sys].[int] = NULL
)
AS
BEGIN
	SELECT		P.[Id], P.[Name], P.[Address], P.[Identifier], P.[Latitude], P.[Longitude], P.[Radius], 
				P.[MinElapsedTimeForVisit], P.[IdDepartment], P.[Deleted],
				GF.Id AS GrandFatherId, GF.Name AS GrandFatherName, GF.SapId AS GrandFatherSapId,
				F.Id AS FatherId, F.Name AS FatherName, F.SapId AS FatherSapId,
				SN.Id AS SonId, SN.Name AS SonName, SN.SapId AS SonSapId
	FROM		[dbo].[PointOfInterest] P WITH (NOLOCK)
				LEFT OUTER JOIN [dbo].[PointOfInterestZone] PZ WITH (NOLOCK) ON PZ.[IdPointOfInterest] = P.[Id]
				LEFT OUTER JOIN dbo.POIHierarchyLevel1 GF WITH (NOLOCK) ON GF.Id = P.GrandfatherId
				LEFT OUTER JOIN dbo.POIHierarchyLevel2 F WITH (NOLOCK) ON F.Id = P.FatherId
				LEFT OUTER JOIN dbo.Son SN ON SN.Id = P.SonId
	WHERE		((@IdPointsOfInterest IS NULL) OR (dbo.CheckValueInList(P.[Id], @IdPointsOfInterest) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckZoneInUserZones(PZ.[IdZone], @IdUser) = 1))
	GROUP BY	P.[Id], P.[Name], P.[Address], P.[Identifier], P.[Latitude], P.[Longitude], P.[Radius], P.[MinElapsedTimeForVisit], P.[IdDepartment], P.[Deleted],
				GF.Id, GF.Name, GF.SapId, F.Id, F.Name, F.SapId,  SN.Id, SN.Name, SN.SapId
END
