/****** Object:  Procedure [dbo].[GetAssignedPointsOfInterestByAgreement]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 29/07/2016
-- Description:	SP para obtener los puntos de interes de un contrato o acuerdo dado
-- =============================================
create PROCEDURE [dbo].[GetAssignedPointsOfInterestByAgreement]
	
	 @IdAgreement [sys].[INT]
	,@PointOfInterestIds [sys].VARCHAR(MAX) = NULL
    ,@IdUser [sys].[INT] = NULL
AS
BEGIN

	SELECT		AP.[Id], AP.[Date], P.[Id] AS PointOfInterestId, P.[Name] AS PointOfInterestName,
				P.[Identifier] AS PointOfInterestIdentifier, A.[Name] AS AgreementName

	FROM		[dbo].[AgreementPointOfInterest] AP
				INNER JOIN [dbo].[PointOfInterest] P ON P.[Id] = AP.[IdPointOfInterest]
				INNER JOIN [dbo].[Agreement] A ON A.[Id] = AP.[IdAgreement]
	
	WHERE		AP.[IdAgreement] = @IdAgreement AND P.Deleted = 0 AND 
				((@PointOfInterestIds IS NULL) OR (dbo.[CheckValueInList](P.[Id], @PointOfInterestIds) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1)) AND
                ((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1))
	
	GROUP BY	AP.[Id], AP.[Date], P.[Id], P.[Name], P.[Identifier], A.[Name]
	ORDER BY 	P.[Id]
END
