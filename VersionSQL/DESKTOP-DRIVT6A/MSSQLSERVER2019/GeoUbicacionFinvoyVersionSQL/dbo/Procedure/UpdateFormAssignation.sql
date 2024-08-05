/****** Object:  Procedure [dbo].[UpdateFormAssignation]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Diego Cáceres
-- Create date: 15/10/2014
-- Description:	SP para modificar la asignación de un formulario
-- =============================================
CREATE PROCEDURE [dbo].[UpdateFormAssignation]
	 
	 @Id [sys].[int]
	,@IdPointsOfInterest [sys].[varchar](MAX) = NULL
	,@IdPersonsOfInterest [sys].[varchar](MAX) = NULL
	,@StartDate [sys].DATETIME = NULL
	,@EndDate [sys].DATETIME = NULL
	,@IdFormCategory [sys].[INT] = NULL
    ,@IdFormType [sys].[INT] = NULL
	,@AllPointOfInterest [sys].bit = NULL
	,@AllPersonOfInterest [sys].bit = NULL
	,@OutsidePointOfInterest [sys].bit = NULL
	,@OneTimeAnswer [sys].bit = NULL
	,@Description [sys].[varchar](1000) = NULL
	,@Name [sys].[varchar](100) = NULL
	,@IsWeighted [sys].[bit] = 0
	,@AllowWebComplete [sys].[bit] = 0
    ,@CompleteMultipleTimes [sys].[bit] = 0
	,@IdCompany [sys].[int] = NULL
	,@ResultCode [sys].[int] OUTPUT
AS
BEGIN
	DECLARE @Now [sys].[datetime]
	SET @Now = GETUTCDATE()

	SET @ResultCode = 0

	DECLARE @IdAux  AS INT
	BEGIN TRANSACTION;
    SAVE TRANSACTION UpdateFormCompleted;
	BEGIN TRY

		UPDATE [dbo].[Form]
		SET [StartDate] = @StartDate, [Name] = @Name, [EndDate] =  CASE WHEN YEAR(@EndDate)>=9999 THEN tzdb.FromUtc('9999-12-31 23:59:59.997') ELSE tzdb.FromUtc(@EndDate) END, [IdFormCategory] = @IdFormCategory,
			[IdFormType] = @IdFormType, [AllPointOfInterest] = @AllPointOfInterest, [AllPersonOfInterest] = @AllPersonOfInterest, 
			[NonPointOfInterest] = @OutsidePointOfInterest, [Description] = @Description, 
			[OneTimeAnswer] = @OneTimeAnswer, [IsWeighted] = @IsWeighted, [AllowWebComplete] = @AllowWebComplete,
			[CompleteMultipleTimes] = @CompleteMultipleTimes, [IdCompany] = @IdCompany, [EditedDate] = GETUTCDATE()
		WHERE [Id] = @Id

		--UPDATE [dbo].[AssignedForm] 
		--SET [Deleted] = 1, [DeletedDate] = @Now
		--WHERE [IdForm] = @Id AND [Deleted] = 0

		DELETE FROM 
		[dbo].[AssignedForm] 
		WHERE [IdForm] = @Id AND [Deleted] = 0

		IF @AllPointOfInterest = 0
		BEGIN
			INSERT INTO [dbo].[AssignedForm]([IdForm], [IdPointOfInterest], [IdPersonOfInterest], [Date], [Deleted])
			(	SELECT @Id AS IdForm, POI.[Id] AS [IdPointOfInterest], P.[Id] AS [IdPersonOfInterest], @Now AS [Date], 0 AS [Deleted]
				FROM	dbo.PersonOfInterest P WITH(NOLOCK),
						-- Me fijo contra los Ids de Puntos agregando el NULL
						(SELECT POIAux.[Id] FROM dbo.PointOfInterest POIAux WITH(NOLOCK) WHERE POIAux.Deleted = 0 UNION (SELECT NULL as [Id])) POI 
				WHERE	P.Deleted = 0 
						AND (@AllPersonOfInterest = 1 OR @IdPersonsOfInterest IS NULL OR dbo.CheckValueInList(P.[Id], @IdPersonsOfInterest) = 1)
						-- No viene lista ni esta en todos los POI, entonces no esta asignado a punto
						AND (((@AllPointOfInterest IS NULL OR @AllPointOfInterest = 0) AND @IdPointsOfInterest IS NULL AND POI.[Id] IS NULL)
						-- O El POI no es null y viene datos en almenos Todos o Lista de pois
							OR (POI.[Id] IS NOT NULL 
								AND (@AllPointOfInterest = 1 OR @IdPointsOfInterest IS NOT NULL) 
								AND (@IdPointsOfInterest IS NULL OR dbo.CheckValueInList(POI.[Id], @IdPointsOfInterest) = 1)
								)
							))
		END
		ELSE
		BEGIN
			INSERT INTO [dbo].[AssignedForm]([IdForm], [IdPointOfInterest], [IdPersonOfInterest], [Date], [Deleted])
			SELECT  @Id AS IdForm, NULL, P.[Id] AS [IdPersonOfInterest] , @Now AS [Date], 0 AS [Deleted]
			FROM	dbo.PersonOfInterest P WITH (NOLOCK)
			WHERE   (@IdPersonsOfInterest IS NULL OR dbo.CheckValueInList(P.[Id], @IdPersonsOfInterest) = 1) AND p.[Deleted] = 0
		END

		SET @ResultCode = 0

	END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
        BEGIN
			SET @ResultCode = 1
            ROLLBACK TRANSACTION UpdateFormCompleted; -- rollback to UpdateFormCompleted
        END
    END CATCH
    COMMIT TRANSACTION
END
