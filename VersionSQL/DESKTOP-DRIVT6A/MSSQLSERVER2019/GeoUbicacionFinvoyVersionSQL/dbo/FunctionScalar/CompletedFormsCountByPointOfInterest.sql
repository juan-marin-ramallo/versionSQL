/****** Object:  ScalarFunction [dbo].[CompletedFormsCountByPointOfInterest]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Diego Cáceres
-- Create date: 14/10/2014
-- Description:	Función para calcular la cantidad de formularios completados de un punto de interes
-- =============================================
CREATE FUNCTION [dbo].[CompletedFormsCountByPointOfInterest]
(
	 @IdForm [sys].[int]
	,@IdPointOfInterest [sys].[int]
	,@DateFrom [sys].[datetime] = NULL
	,@DateTo [sys].[datetime] = NULL
	,@StockersIds [sys].[varchar](MAX) = NULL
	,@IdUser [sys].[INT] = NULL
)
RETURNS [sys].[int]
AS
BEGIN
	DECLARE @Result [sys].[int]
	SET @Result = 0

	IF @IdForm IS NOT NULL AND @IdPointOfInterest IS NOT NULL
	BEGIN
   SET @Result = ISNULL((SELECT COUNT (1)
				FROM (SELECT	COUNT(1) AS C
					FROM	[dbo].[CompletedForm] CF  with(nolock)
					LEFT JOIN [dbo].[PersonOfInterest] S with(nolock) ON S.[Id] = CF.[IdPersonOfInterest]												
					WHERE	CF.[IdForm] = @IdForm AND CF.[IdPointOfInterest] = @IdPointOfInterest
						AND (@DateFrom IS NULL AND @DateTo IS NULL 
							OR (CF.[Date] BETWEEN @DateFrom AND @DateTo))
						AND ((@StockersIds IS NULL) OR (dbo.[CheckValueInList](CF.[IdPersonOfInterest], @StockersIds) = 1)) AND
						((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1)) AND
						((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1))
						GROUP BY CF.[Date]) AS T), 0)
	END

	RETURN @Result
END
