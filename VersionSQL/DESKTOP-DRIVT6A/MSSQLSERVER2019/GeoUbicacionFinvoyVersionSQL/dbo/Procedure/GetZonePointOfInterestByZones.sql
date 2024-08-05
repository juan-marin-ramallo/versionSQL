/****** Object:  Procedure [dbo].[GetZonePointOfInterestByZones]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 03/06/2015
-- Description:	SP para obtener los puntos de interes filtrados por zonas
-- =============================================
CREATE PROCEDURE [dbo].[GetZonePointOfInterestByZones]
	
	 @IdZones [sys].[varchar](1000) = NULL
	,@IdUser [sys].[int] = NULL
AS
BEGIN

		SELECT		PZ.[IdZone], Z.[Description] AS ZoneDescription, PZ.[IdPointOfInterest], P.[Name] AS PointOfInterestName, P.[Identifier] AS PointOfInterestIdentifier
	FROM		[dbo].[PointOfInterestZone] PZ WITH (NOLOCK)
				INNER JOIN [dbo].[PointOfInterest] P WITH (NOLOCK) ON P.[Id] = PZ.[IdPointOfInterest]
				INNER JOIN [dbo].[ZoneTranslated] Z WITH (NOLOCK) ON Z.[Id] = PZ.[IdZone]
	WHERE		((@IdZones IS NULL) OR ((dbo.CheckValueInList(PZ.[IdZone], @IdZones) = 1))) AND
				(@IdUser IS NOT NULL AND dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1) AND
				((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1)) AND
				P.[Deleted] = 0
	ORDER BY	Z.[Description], P.[Name]
END
