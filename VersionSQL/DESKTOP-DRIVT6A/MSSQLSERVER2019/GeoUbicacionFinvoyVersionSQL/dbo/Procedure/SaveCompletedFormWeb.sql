/****** Object:  Procedure [dbo].[SaveCompletedFormWeb]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Diego Cáceres
-- Create date: 06/10/2014
-- Description:	SP para guardar una formulario completo desde la web
-- =============================================
CREATE PROCEDURE  [dbo].[SaveCompletedFormWeb]
	@Id [sys].[int] OUTPUT,
	@IdForm [sys].[int],
	@IdPointOfInterest [sys].[int] = NULL,
	@IdPersonOfInterest [sys].[int],
	@ReceivedDate [sys].[datetime],
	@CreatedDate [sys].[datetime],
	@CompletedDate [sys].[datetime],
	@Result [sys].[int] OUTPUT

AS
BEGIN

	--Verifico que el formulario si es de "Unica vez" ya no esté completado 
	SET @Result = 0
	IF EXISTS (SELECT 1 
				FROM [dbo].[CompletedForm] CF WITH (NOLOCK)
				INNER JOIN [dbo].[Form] F WITH (NOLOCK) ON F.[Id] = CF.[IdForm]
				WHERE CF.[IdForm] = @IdForm AND F.[OneTimeAnswer] = 1 AND CF.[IdPointOfInterest] = @IdPointOfInterest)
	BEGIN	
		SET @Result = 6	
	END  
	ELSE
	BEGIN		
		IF NOT EXISTS (SELECT 1 FROM [dbo].[CompletedForm] WITH (NOLOCK) WHERE [IdForm] = @IdForm 
						AND (([IdPointOfInterest] IS NULL AND @IdPointOfInterest IS NULL) OR ([IdPointOfInterest] = @IdPointOfInterest))
						AND [IdPersonOfInterest] = @IdPersonOfInterest
						AND [StartDate] = @CreatedDate)
		BEGIN

			INSERT INTO [dbo].[CompletedForm]([IdForm], [IdPointOfInterest], [Latitude], 
						[Longitude], [LatLong], [IdPersonOfInterest], [Date], [ReceivedDate], [StartDate], 
						[InitLatitude], [InitLongitude], [CompletedFromWeb])
			VALUES		(@IdForm, @IdPointOfInterest, NULL, NULL, NULL, @IdPersonOfInterest, 
						@CompletedDate, @ReceivedDate, @CreatedDate, NULL, NULL, 1)
	
			SELECT @Id = SCOPE_IDENTITY()

			IF @IdPointOfInterest IS NOT NULL
			BEGIN
				EXEC [dbo].[SavePointsOfInterestActivity]
						@IdPersonOfInterest = @IdPersonOfInterest
						,@IdPointOfInterest = @IdPointOfInterest
						,@DateIn = @CompletedDate
						,@AutomaticValue = 3
			END

		END
		ELSE
		BEGIN
			SET @Result = 300 --YA EXISTE EL FORM, SE ESTA GUARDANDO REPETIDO Y NO LO QUIERO DUPLICAR
		END
	END
END
