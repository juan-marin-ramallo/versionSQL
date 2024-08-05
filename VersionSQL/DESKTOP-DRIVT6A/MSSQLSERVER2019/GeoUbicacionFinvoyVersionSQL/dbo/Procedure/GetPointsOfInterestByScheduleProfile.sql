/****** Object:  Procedure [dbo].[GetPointsOfInterestByScheduleProfile]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 27/10/2018
-- Description:	SP para obtener los puntos de interes de un cronograma de actividades
-- =============================================
CREATE PROCEDURE [dbo].[GetPointsOfInterestByScheduleProfile]
	
	 @IdSchedule [sys].[INT]
	,@PointOfInterestIds [sys].[varchar](MAX) = NULL
    ,@IdUser [sys].[INT] = NULL
AS
BEGIN

	DECLARE @AllPointOfInterest [sys].[bit] = (SELECT [AllPointOfInterest] FROM [dbo].[ScheduleProfile] WITH (NOLOCK) WHERE [Id] = @IdSchedule)

	IF @AllPointOfInterest = 0
	BEGIN
		SELECT		P.[Id] AS PointOfInterestId, P.[Name] AS PointOfInterestName, 
					P.[Identifier] AS PointOfInterestIdentifier
		FROM		[dbo].[ScheduleProfileAssignation] SP WITH (NOLOCK)
					INNER JOIN [dbo].[PointOfInterest] P WITH (NOLOCK) ON P.[Id] = SP.[IdPointOfInterest]
		WHERE		SP.[IdScheduleProfile] = @IdSchedule AND P.Deleted = 0 AND 
					((@PointOfInterestIds IS NULL) OR (dbo.[CheckValueInList](SP.[IdPointOfInterest], @PointOfInterestIds) = 1)) AND
					((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1)) AND
					((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1))
		GROUP BY	P.[Id], P.[Name], P.[Identifier]
		ORDER BY 	P.[Id]
	END
	ELSE
	BEGIN
		SELECT		P.[Id] AS PointOfInterestId, P.[Name] AS PointOfInterestName, 
					P.[Identifier] AS PointOfInterestIdentifier
		FROM		[dbo].[PointOfInterest] P WITH (NOLOCK)
		WHERE		P.Deleted = 0 AND 
					((@PointOfInterestIds IS NULL) OR (dbo.[CheckValueInList](P.[Id], @PointOfInterestIds) = 1)) AND
					((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1)) AND
					((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1))
		GROUP BY	P.[Id], P.[Name], P.[Identifier]
		ORDER BY 	P.[Id]
	END
END
