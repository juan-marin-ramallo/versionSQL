/****** Object:  Procedure [dbo].[GetPointsOfInterestForFilter]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetPointsOfInterestForFilter]
	 @IdPointsOfInterest varchar(MAX) = NULL
	,@IdUser int = NULL
AS
BEGIN

	SELECT		DISTINCT P.[Id], P.[Name], P.[Identifier]

	FROM		[dbo].[PointOfInterest] P WITH (NOLOCK)
				LEFT OUTER JOIN [dbo].[PointOfInterestZone] PZ WITH (NOLOCK) ON PZ.[IdPointOfInterest] = P.[Id]
	
	WHERE		((@IdPointsOfInterest IS NULL) OR (dbo.CheckValueInList(P.[Id], @IdPointsOfInterest) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckZoneInUserZones(PZ.[IdZone], @IdUser) = 1))

END
