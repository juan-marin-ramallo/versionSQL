/****** Object:  Procedure [dbo].[GetZonePersonOfInterestByZones]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 17/07/2015
-- Description:	SP para obtener las personas de interes filtradas por zonas
-- =============================================
CREATE PROCEDURE [dbo].[GetZonePersonOfInterestByZones]
	
	 @IdZones [sys].[varchar](max) = NULL
	,@IdUser [sys].[int] = NULL
	,@IncludeDeleted [sys].[BIT] = NULL 
AS
BEGIN

	SELECT		PZ.[IdZone] AS IdZone, Z.[Description] AS ZoneDescription, P.[Id] AS IdPersonOfInterest, 
				P.[Name] AS PersonOfInterestName,P.[LastName] AS PersonOfInterestLastName, 
				P.[IdDepartment] AS PersonOfInterestDepartment, P.[Type] AS PersonOfInterestType, P.[Identifier] AS PersonOfInterestIdentifier
	FROM		[dbo].[PersonOfInterestZone] PZ WITH (NOLOCK)
				INNER JOIN [dbo].[PersonOfInterest] P WITH (NOLOCK) ON P.[Id] = PZ.[IdPersonOfInterest]
				LEFT JOIN [dbo].[ZoneTranslated] Z WITH (NOLOCK) ON Z.[Id] = PZ.[IdZone]
	WHERE		((@IdZones IS NULL) OR ((dbo.CheckValueInList(PZ.[IdZone], @IdZones) = 1))) AND
				(@IdUser IS NOT NULL AND dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1) AND
				((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(P.[Id], @IdUser) = 1)) AND
				(@IncludeDeleted = 1 OR P.[Deleted] = 0)
	ORDER BY	Z.[Description], P.[Name]
END
