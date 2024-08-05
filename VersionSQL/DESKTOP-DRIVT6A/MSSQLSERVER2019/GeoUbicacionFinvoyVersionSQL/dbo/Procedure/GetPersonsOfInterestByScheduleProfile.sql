/****** Object:  Procedure [dbo].[GetPersonsOfInterestByScheduleProfile]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 27/10/2018
-- Description:	SP para obtener las personas de interes de un cronograma de actividades
-- =============================================
CREATE PROCEDURE [dbo].[GetPersonsOfInterestByScheduleProfile]
	
	 @IdSchedule [sys].[INT]
	,@PersonOfInterestIds [sys].[varchar](MAX) = NULL
	,@ProfileIds [sys].[varchar](MAX) = NULL
    ,@IdUser [sys].[INT] = NULL
AS
BEGIN

	DECLARE @AllPersonOfInterest [sys].[bit] = (SELECT [AllPersonOfInterest] FROM [dbo].[ScheduleProfile] WITH (NOLOCK) WHERE [Id] = @IdSchedule)

	IF @AllPersonOfInterest = 0
	BEGIN
		SELECT		P.[Id] AS PersonOfInterestId, P.[Name] AS PersonOfInterestName, 
					P.[LastName] AS PersonOfInterestLastName, P.[Identifier] AS PersonOfInterestIdentifier
		FROM		[dbo].[ScheduleProfileAssignation] SP WITH (NOLOCK)
					INNER JOIN [dbo].[PersonOfInterest] P WITH (NOLOCK) ON P.[Id] = SP.[IdPersonOfInterest]
		WHERE		SP.[IdScheduleProfile] = @IdSchedule AND P.Deleted = 0 AND 
					((@PersonOfInterestIds IS NULL) OR (dbo.[CheckValueInList](SP.[IdPersonOfInterest], @PersonOfInterestIds) = 1)) AND
					((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1)) AND
					((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(P.[Id], @IdUser) = 1))
		GROUP BY	P.[Id], P.[Name],P.[LastName] , P.[Identifier]
		
		UNION

		SELECT		P.[Id] AS PersonOfInterestId, P.[Name] AS PersonOfInterestName, 
					P.[LastName] AS PersonOfInterestLastName, P.[Identifier] AS PersonOfInterestIdentifier
		FROM		[dbo].[ScheduleProfileGeneralAssignation] SP WITH (NOLOCK)
					INNER JOIN [dbo].[PersonOfInterest] P WITH (NOLOCK) ON P.[Type] = SP.[IdPersonOfInterestType]
		WHERE		SP.[IdScheduleProfile] = @IdSchedule AND P.Deleted = 0 AND 
					((@ProfileIds IS NULL) OR (dbo.[CheckCharValueInList](SP.[IdPersonOfInterestType], @ProfileIds) = 1)) AND
					((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1)) AND
					((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(P.[Id], @IdUser) = 1))

		ORDER BY 	P.[Id]

	END
	ELSE
	BEGIN
		SELECT		P.[Id] AS PersonOfInterestId, P.[Name] AS PersonOfInterestName, 
					P.[LastName] AS PersonOfInterestLastName, P.[Identifier] AS PersonOfInterestIdentifier
		FROM		[dbo].[PersonOfInterest] P WITH (NOLOCK)
		WHERE		P.[Deleted] = 0 AND 
					((@PersonOfInterestIds IS NULL) OR (dbo.[CheckValueInList](P.[Id], @PersonOfInterestIds) = 1)) AND
					((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1)) AND
					((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(P.[Id], @IdUser) = 1))
		GROUP BY	P.[Id], P.[Name],P.[LastName] , P.[Identifier]
		ORDER BY 	P.[Id]
	END
END
