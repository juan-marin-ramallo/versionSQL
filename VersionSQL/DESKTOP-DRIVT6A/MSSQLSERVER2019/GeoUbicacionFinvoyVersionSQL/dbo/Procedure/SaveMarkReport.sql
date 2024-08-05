/****** Object:  Procedure [dbo].[SaveMarkReport]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SaveMarkReport]
(
	 @EntryDate [sys].[datetime]
	,@ExitDate [sys].[datetime] = NULL
	,@RestStartDate [sys].[datetime] = NULL
	,@RestEndDate [sys].[datetime] = NULL
	,@IdPersonOfInterest [sys].[int] 
	,@IdUser [sys].[INT] 
	,@Comment [sys].[VARCHAR](1024)
	,@Id [sys].[INT] OUTPUT
	,@IdExit [sys].[INT] OUTPUT
)
AS
BEGIN
	DECLARE @Now [sys].[datetime]
	SET @Now = GETUTCDATE()
	SET @IdExit = 0

	DECLARE @IdEntryDate [sys].[int]
	DECLARE @IdExityDate [sys].[int]
	
	DECLARE @LatLong [sys].[geography]
	DECLARE @IdPointOfInterest [sys].[int] = NULL
	SET @LatLong = GEOGRAPHY::STPointFromText('POINT(' + CAST(0 AS VARCHAR(25)) + ' ' + CAST(0 AS VARCHAR(25)) + ')', 4326)
		
	-- Me parece que no hace nada esto porque va siempre contra 0, 0
	IF EXISTS (SELECT 1 
		FROM [dbo].[PointOfInterest] POIIn WITH (NOLOCK) 
		WHERE POIIn.[LatLong].STDistance(@LatLong) <= POIIn.[Radius] AND POIIn.[Deleted] = 0)
	BEGIN
		SET @IdPointOfInterest = (SELECT TOP 1 [Id]	
		FROM [dbo].[PointOfInterest] POIIn WITH (NOLOCK) 
		WHERE POIIn.[LatLong].STDistance(@LatLong) <= POIIn.[Radius] AND POIIn.[Deleted] = 0)
	END

	INSERT INTO [dbo].[Mark]([IdPointOfInterest],[IdPersonOfInterest], [Type], [Date], [Latitude], [Longitude], [Accuracy], [ReceivedDate], [LatLong], [Edited])
	VALUES (@IdPointOfInterest, @IdPersonOfInterest, 'E', @EntryDate, 0, 0, 10, @Now, @LatLong, 1)

	SET @IdEntryDate = SCOPE_IDENTITY()

	--SI HAY SALIDA LA AGREGO
	IF @ExitDate IS NOT NULL
	BEGIN		
		INSERT INTO [dbo].[Mark]([IdPointOfInterest],[IdPersonOfInterest], [Type], [Date], [Latitude], [Longitude], [Accuracy], [IdParent], [ReceivedDate], [LatLong], [Edited])
		VALUES(@IdPointOfInterest, @IdPersonOfInterest, 'S', @ExitDate, 0, 0, 10, @IdEntryDate, @Now, @LatLong, 1)
		SET @IdExityDate = SCOPE_IDENTITY()
		SET @IdExit = @IdExityDate
	END

	--SI HAY Descanso AGREGO
	IF @RestStartDate IS NOT NULL
	BEGIN		
		INSERT INTO [dbo].[Mark]([IdPointOfInterest],[IdPersonOfInterest], [Type], [Date], [Latitude], [Longitude], [Accuracy], [IdParent], [ReceivedDate], [LatLong], [Edited])
		VALUES(@IdPointOfInterest, @IdPersonOfInterest, 'ED', @RestStartDate, 0, 0, 10, @IdEntryDate, @Now, @LatLong, 1)

	END

	--SI HAY Descanso AGREGO
	IF @RestEndDate IS NOT NULL
	BEGIN		
		INSERT INTO [dbo].[Mark]([IdPointOfInterest],[IdPersonOfInterest], [Type], [Date], [Latitude], [Longitude], [Accuracy], [IdParent], [ReceivedDate], [LatLong], [Edited])
		VALUES(@IdPointOfInterest, @IdPersonOfInterest, 'SD', @RestEndDate, 0, 0, 10, @IdEntryDate, @Now, @LatLong, 1)
		
	END


	INSERT INTO [dbo].[MarkLog]
           ([IdUser],[Date],[Comment],[IdEntry],[EntryDateOld],[EntryDate],[IdExit],[ExitDateOld],[ExitDate])
    VALUES (@IdUser, GETUTCDATE(), @Comment, @IdEntryDate, NULL, @EntryDate, @IdExityDate, NULL, @ExitDate)

	SET @Id = @IdEntryDate
	
END
