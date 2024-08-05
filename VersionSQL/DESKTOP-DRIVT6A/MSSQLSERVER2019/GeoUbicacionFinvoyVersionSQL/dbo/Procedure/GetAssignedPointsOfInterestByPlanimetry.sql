/****** Object:  Procedure [dbo].[GetAssignedPointsOfInterestByPlanimetry]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 09/08/2016
-- Description:	SP para obtener los puntos de interes de una planimetria
-- =============================================
CREATE PROCEDURE [dbo].[GetAssignedPointsOfInterestByPlanimetry]
	
	 @IdPlanimetry [sys].[INT]
	,@PointOfInterestIds [sys].VARCHAR(MAX) = NULL
    ,@IdUser [sys].[INT] = NULL
AS
BEGIN

	SELECT		PP.[Id], PP.[Date], POI.[Id] AS PointOfInterestId, POI.[Name] AS PointOfInterestName,
				POI.[Identifier] AS PointOfInterestIdentifier, P.[Name] AS PlanimetryName

	FROM		[dbo].[PlanimetryPointOfInterest] PP
				INNER JOIN [dbo].[PointOfInterest] POI ON POI.[Id] = PP.[IdPointOfInterest]
				INNER JOIN [dbo].[Planimetry] P ON P.[Id] = PP.[IdPlanimetry]
	
	WHERE		PP.[IdPlanimetry] = @IdPlanimetry AND POI.[Deleted] = 0 AND 
				((@PointOfInterestIds IS NULL) OR (dbo.[CheckValueInList](POI.[Id], @PointOfInterestIds) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(POI.[Id], @IdUser) = 1)) AND
                ((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(POI.[IdDepartment], @IdUser) = 1))
	
	GROUP BY	PP.[Id], PP.[Date], POI.[Id], POI.[Name], POI.[Identifier], P.[Name]
	ORDER BY 	POI.[Id]
END
