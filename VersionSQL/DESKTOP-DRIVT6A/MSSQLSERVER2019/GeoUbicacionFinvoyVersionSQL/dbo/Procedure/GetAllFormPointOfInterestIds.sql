/****** Object:  Procedure [dbo].[GetAllFormPointOfInterestIds]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetAllFormPointOfInterestIds]
	 @IdForm int
	,@IdPersonOfInterest int = NULL
	,@IdUser int = NULL
AS
BEGIN
	
	DECLARE @AllPointOfInterest [sys].[bit] = (SELECT [AllPointOfInterest] FROM [dbo].[Form] WHERE [Id] = @IdForm)

	IF @AllPointOfInterest = 0
	BEGIN
		SELECT		DISTINCT P.[Id]
		FROM		[dbo].[AssignedForm] AF WITH (NOLOCK)
					INNER JOIN [dbo].[PointOfInterest] P WITH (NOLOCK) ON P.[Id] = AF.[IdPointOfInterest]
		WHERE		AF.[IdForm] = @IdForm AND AF.[Deleted] = 0 AND P.[Deleted] = 0 AND 
					((@IdPersonOfInterest IS NULL OR AF.[IdPersonOfInterest] = @IdPersonOfInterest)) AND
					((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1)) AND
					((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1))
	END
	ELSE
	BEGIN
		SELECT		DISTINCT P.[Id] AS PointOfInterestId
		FROM		[dbo].[PointOfInterest] P WITH (NOLOCK)
		WHERE		P.[Deleted] = 0 AND 
					((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1)) AND
					((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1))
	END
END
