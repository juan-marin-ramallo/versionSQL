/****** Object:  ScalarFunction [dbo].[AssignedPointsOfInterestCountByForm]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 28/06/2016
-- Description:	Función para calcular la cantidad de puntos asignados a un formulario
-- =============================================
CREATE FUNCTION [dbo].[AssignedPointsOfInterestCountByForm]
(
	 @IdForm [sys].[int]
	,@StockersIds [sys].[varchar](MAX) = NULL
	,@PointsOfInterestIds [sys].[varchar](MAX) = NULL
	,@IdUser [sys].[INT] = NULL
)
RETURNS [sys].[int]
AS
BEGIN
	DECLARE @Result [sys].[int]
	SET @Result = 0

	DECLARE @IdFormLocal [sys].[int]
	DECLARE @StockersIdsLocal [sys].[varchar](MAX)
	DECLARE @PointsOfInterestIdsLocal [sys].[varchar](MAX)
	DECLARE @IdUserLocal [sys].[INT]

	SET @IdFormLocal = @IdForm
	SET @StockersIdsLocal = @StockersIds
	SET @PointsOfInterestIdsLocal = @PointsOfInterestIds
	SET	@IdUserLocal = @IdUser

	IF @IdFormLocal IS NOT NULL
	BEGIN
	SET @Result = ISNULL((SELECT COUNT(DISTINCT(AF.[IdPointOfInterest])) AS A
						FROM	[dbo].[AssignedForm] AF with(nolock) 
								INNER JOIN [dbo].[PersonOfInterest] S with(nolock) ON S.[Id] = AF.[IdPersonOfInterest]		
								INNER JOIN [dbo].[PointOfInterest] P with(nolock) ON P.[Id] = AF.[IdPointOfInterest]											
						WHERE	AF.[IdForm] = @IdFormLocal AND
								((@StockersIdsLocal IS NULL) OR (dbo.[CheckValueInList](AF.[IdPersonOfInterest], @StockersIdsLocal) = 1)) AND
								((@PointsOfInterestIdsLocal IS NULL) OR (dbo.[CheckValueInList](AF.[IdPointOfInterest], @PointsOfInterestIdsLocal) = 1)) AND
								((@IdUserLocal IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUserLocal) = 1)) AND
								((@IdUserLocal IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUserLocal) = 1))
						GROUP BY AF.[IdForm]), 0)

	END

	RETURN @Result
END
