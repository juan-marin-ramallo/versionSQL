/****** Object:  Procedure [dbo].[GetAssignedPointsOfInterestByForm]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Diego Cáceres
-- Create date: 14/10/2014
-- Description:	SP para obtener los puntos de interes de un formulario dado
-- =============================================
CREATE PROCEDURE [dbo].[GetAssignedPointsOfInterestByForm]
	
	 @IdForm [sys].[INT]
	,@PointOfInterestIds [sys].[varchar](MAX) = NULL
    ,@IdUser [sys].[INT] = NULL
AS
BEGIN

	DECLARE @AllPointOfInterest [sys].[bit] = (SELECT [AllPointOfInterest] FROM [dbo].[Form] WITH (NOLOCK) WHERE [Id] = @IdForm)

	IF @AllPointOfInterest = 0
	BEGIN
		SELECT		P.[Id] AS PointOfInterestId, P.[Name] AS PointOfInterestName, P.[Identifier] AS PointOfInterestIdentifier,
					[dbo].[CompletedFormsCountByPointOfInterest](AF.[IdForm], P.[Id], NULL, NULL, NULL, @IdUser) AS CompletedFormsCount
		FROM		[dbo].[AssignedForm] AF WITH (NOLOCK)
					INNER JOIN [dbo].[PointOfInterest] P WITH (NOLOCK) ON P.[Id] = AF.[IdPointOfInterest]
		WHERE		AF.[IdForm] = @IdForm AND AF.[Deleted] = 0 AND P.Deleted = 0 AND 
					((@PointOfInterestIds IS NULL) OR (dbo.[CheckValueInList](AF.[IdPointOfInterest], @PointOfInterestIds) = 1)) AND
					((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1)) AND
					((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1))
		GROUP BY	AF.[Id], AF.[Date], P.[Id], P.[Name], P.[Identifier], [dbo].[CompletedFormsCountByPointOfInterest](AF.[IdForm], P.[Id], NULL, NULL, NULL, @IdUser)
		ORDER BY 	P.[Id]
	END
	ELSE
	BEGIN
		SELECT		P.[Id] AS PointOfInterestId, P.[Name] AS PointOfInterestName, P.[Identifier] AS PointOfInterestIdentifier,
					[dbo].[CompletedFormsCountByPointOfInterest](@IdForm, P.[Id], NULL, NULL, NULL, @IdUser) AS CompletedFormsCount
		FROM		[dbo].[PointOfInterest] P WITH (NOLOCK)
		WHERE		P.Deleted = 0 AND 
					((@PointOfInterestIds IS NULL) OR (dbo.[CheckValueInList](P.[Id], @PointOfInterestIds) = 1)) AND
					((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1)) AND
					((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1))
		GROUP BY	P.[Id], P.[Name], P.[Identifier], [dbo].[CompletedFormsCountByPointOfInterest](@IdForm, P.[Id], NULL, NULL, NULL, @IdUser)
		ORDER BY 	P.[Id]
	END
END
