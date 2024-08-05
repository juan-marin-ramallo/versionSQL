/****** Object:  Procedure [dbo].[GetAssignedPointsOfInterestByPromotion]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 25/07/2016
-- Description:	SP para obtener los puntos de interes de una promoción dada
-- =============================================
CREATE PROCEDURE [dbo].[GetAssignedPointsOfInterestByPromotion]
	
	 @IdPromotion [sys].[INT]
	,@PointOfInterestIds [sys].VARCHAR(MAX) = NULL
    ,@IdUser [sys].[INT] = NULL
AS
BEGIN

	SELECT		PP.[Id], PP.[Date], P.[Id] AS PointOfInterestId, P.[Name] AS PointOfInterestName,
				P.[Identifier] AS PointOfInterestIdentifier, PRO.[Name] AS PromotionName

	FROM		[dbo].[PromotionPointOfInterest] PP
				INNER JOIN [dbo].[PointOfInterest] P ON P.[Id] = PP.[IdPointOfInterest]
				INNER JOIN [dbo].[Promotion] PRO ON PRO.[Id] = PP.[IdPromotion]
	
	WHERE		PP.[IdPromotion] = @IdPromotion AND P.Deleted = 0 AND 
				((@PointOfInterestIds IS NULL) OR (dbo.[CheckValueInList](P.[Id], @PointOfInterestIds) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1)) AND
                ((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1))
	
	GROUP BY	PP.[Id], PP.[Date], P.[Id], P.[Name], P.[Identifier], PRO.[Name]
	ORDER BY 	P.[Id]
END
