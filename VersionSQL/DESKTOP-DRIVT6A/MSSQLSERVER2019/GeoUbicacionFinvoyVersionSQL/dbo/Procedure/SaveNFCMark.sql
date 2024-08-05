/****** Object:  Procedure [dbo].[SaveNFCMark]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 24/03/2016
-- Description:	SP para obtener guardar una marca de entrada o salida a partir del tag nfc
-- =============================================
CREATE PROCEDURE [dbo].[SaveNFCMark]
	 @IdPersonOfInterest [sys].[int]
	,@IdPointOfInterest [sys].[int]
	,@Completition [sys].[bit]
	,@StartDate [sys].[datetime]
	,@EndDate [sys].[datetime] = NULL
	,@ElapsedTime [sys].[time](7) = NULL
	,@NFCTagId [sys].VARCHAR(20) = NULL
	,@Result [sys].INT OUT
AS
BEGIN
	DECLARE @Now [sys].[datetime]
	SET @Now = GETUTCDATE()

	SET @Result  = 0
	DECLARE @Id [sys].[int] = 0
	DECLARE @IdAux [sys].[int] = 0

	--Se verifica que exista un punto con ese nfc
	IF NOT EXISTS (SELECT 1 FROM dbo.PointOfInterest WITH (NOLOCK) WHERE NFCTagId = @NFCTagId AND Deleted = 0)-- and Id = @IdPointOfInterest)
	BEGIN
		SET @Result = 1
	END
	ELSE
    BEGIN 
		
		--Se verifica si existe otra marca para esa persona PARA ESE DIA
		SET @IdAux = (SELECT TOP 1 [Id] FROM [dbo].[PointOfInterestMark] WITH (NOLOCK) WHERE
							[IdPointOfInterest] = @IdPointOfInterest AND [IdPersonOfInterest] = @IdPersonOfInterest
							AND [CheckInDate] IS NOT NULL AND [CheckOutDate] IS NULL 
							AND Tzdb.AreSameSystemDates([CheckInDate], @EndDate) = 1
							ORDER BY [Id] DESC)

		IF @IdAux IS NULL
		BEGIN
			IF NOT EXISTS (SELECT 1 FROM [dbo].[PointOfInterestMark] WITH (NOLOCK) WHERE
							[IdPointOfInterest] = @IdPointOfInterest AND [IdPersonOfInterest] = @IdPersonOfInterest
							AND [CheckInDate] = @StartDate)
			BEGIN
			--Es una entrada
				INSERT INTO [dbo].[PointOfInterestMark]
						( [IdPersonOfInterest] ,
							[IdPointOfInterest] ,
							[CheckInDate] ,
							[CheckOutDate],
							[InReceivedDate],
							[OutReceivedDate],
							[ElapsedTime],
							[Edited],
							[DeletedByNotVisited],
							[Completition])
				VALUES  ( @IdPersonOfInterest , 
							@IdPointOfInterest , 
							@StartDate , 
							@EndDate,
							@Now,
							NULL,
							@ElapsedTime,
							0,
							0,
							@Completition
						)
				SET @IdAux = SCOPE_IDENTITY()

				IF @EndDate IS NOT NULL
				BEGIN

					UPDATE	[dbo].[PointOfInterestMark]
					SET		[OutReceivedDate] = @Now
					WHERE	[Id] = @IdAux

				END
			END
		END
		ELSE
		BEGIN
			UPDATE	[dbo].[PointOfInterestMark]
			SET		[CheckOutDate] = @EndDate, [ElapsedTime] = @ElapsedTime, [OutReceivedDate] = @Now,
					[Completition] = @Completition
			WHERE	[Id] = @IdAux
		END
	--END
	END
END
