/****** Object:  Procedure [dbo].[IsFormCompleted]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[IsFormCompleted]
	@IdForm int,
	@IdUser int = NULL
	,@DateFrom [sys].[datetime]
	,@DateTo [sys].[datetime]
AS
BEGIN

	DECLARE @TotalAssignedPoints int

	DECLARE @AssignedToAllPoints bit = (SELECT AllPointOfInterest FROM Form  WITH (NOLOCK) WHERE Id = @IdForm)
	IF (@AssignedToAllPoints = 1) BEGIN
		SET @TotalAssignedPoints = (SELECT COUNT(1) 
									FROM PointOfInterest WITH (NOLOCK)
									WHERE Deleted = 0
									  AND ((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones([Id], @IdUser) = 1))
									  AND ((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments([IdDepartment], @IdUser) = 1)))
	END	ELSE BEGIN
		SET @TotalAssignedPoints = (SELECT COUNT(DISTINCT(A.[IdPointOfInterest])) 
									FROM AssignedForm A WITH (NOLOCK)
									JOIN PointOfInterest P WITH (NOLOCK) ON P.[Id] = A.[IdPersonOfInterest]
									WHERE A.IdForm = @IdForm
									  AND A.[Deleted] = 0
									  AND P.[Deleted] = 0
									  AND ((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1))
									  AND ((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1))
									GROUP BY A.[IdForm])
	END 

	DECLARE @IsFormCompleted [sys].[int] = 0

	SELECT	@IsFormCompleted = (CASE WHEN COUNT(1) < @TotalAssignedPoints THEN 0 ELSE 1 END)
		
	FROM	[dbo].[CompletedForm] C WITH (NOLOCK)
			LEFT OUTER JOIN [dbo].[PointOfInterest] P WITH (NOLOCK) ON P.[Id] = C.[IdPointOfInterest] 
					
	WHERE C.[IdForm] = @IdForm AND (C.[Date] >= @DateFrom AND C.[Date] <= @DateTo)
		AND C.[IdPointOfInterest] IS NOT NULL
		AND P.[Deleted] = 0
		AND ((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1))
		AND ((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1))
		
	GROUP BY C.[IdForm]

	SELECT @IsFormCompleted

END
