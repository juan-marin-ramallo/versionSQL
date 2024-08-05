/****** Object:  ScalarFunction [dbo].[CompletedFormsCountByPersonOfInterest]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[CompletedFormsCountByPersonOfInterest]
(
	 @IdForm [sys].[int]
	,@IdPersonOfInterest [sys].[int]
	,@DateFrom [sys].[datetime] = NULL
	,@DateTo [sys].[datetime] = NULL
	,@PointOfInterestIds [sys].[varchar](MAX) = NULL
	,@IdUser [sys].[INT] = NULL
)
RETURNS [sys].[int]
AS
BEGIN
	DECLARE @Result [sys].[int]
	SET @Result = 0

	IF @IdForm IS NOT NULL AND @IdPersonOfInterest IS NOT NULL
	BEGIN
   SET @Result = ISNULL((SELECT COUNT (1)
				FROM (SELECT	COUNT(1) AS C
					FROM	[dbo].[CompletedForm] CF with(nolock)
					LEFT JOIN [dbo].[PersonOfInterest] S with(nolock) ON S.[Id] = CF.[IdPersonOfInterest]												
					WHERE	CF.[IdForm] = @IdForm AND CF.[IdPersonOfInterest] = @IdPersonOfInterest
						AND (@DateFrom IS NULL AND @DateTo IS NULL 
							OR (CF.[Date] BETWEEN @DateFrom AND @DateTo))
						AND ((@PointOfInterestIds IS NULL) OR (dbo.[CheckValueInList](CF.[IdPointOfInterest], @PointOfInterestIds) = 1)) AND
						((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1)) AND
						((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1))
						GROUP BY CF.[Date]) AS T), 0)
	END

	RETURN @Result
END
