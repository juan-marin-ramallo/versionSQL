/****** Object:  Procedure [dbo].[SaveMark]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 20/09/2012
-- Description:	SP para guardar una marca
-- =============================================
CREATE PROCEDURE [dbo].[SaveMark]
(
	 @Id [sys].[int] OUTPUT
	,@IdPersonOfInterest [sys].[int]
	,@Type [sys].[varchar](5)
	,@Date [sys].[datetime]
	,@Latitude [sys].[decimal](25, 20)
	,@Longitude [sys].[decimal](25, 20)
	,@Accuracy [sys].[decimal](8, 1)
	,@IdPointOfInterest [sys].[int] = NULL
	,@IsOnline [sys].[bit] = NULL
	,@IdMarkValidationType [sys].[smallint] = 1
	,@IsFinalMark [sys].[bit] OUTPUT
)
AS
BEGIN
	SELECT	TOP(1) @IsFinalMark = [IsFinalMark]
	FROM	[dbo].[MarkType] WITH (NOLOCK)
	WHERE	[Code] = @Type

	DECLARE @IdParentMark [sys].[int]
	DECLARE @LatLong [sys].[geography]
	DECLARE @ConfValue [sys].[varchar](250) = (SELECT [Value] FROM [dbo].[ConfigurationTranslated] WITH (NOLOCK) WHERE [Id] = 1067)
	DECLARE @RequireToBeInsideConfValue [sys].[varchar](250) = (SELECT [Value] FROM [dbo].[ConfigurationTranslated] WITH (NOLOCK) WHERE [Id] = 4077)

	IF @RequireToBeInsideConfValue = '0' OR (@IsOnline = NULL OR @IsOnline = 0) OR (@Type = 'ED' OR @Type = 'SD')
	BEGIN
		SET @LatLong = GEOGRAPHY::STPointFromText('POINT(' + CAST(@Longitude AS VARCHAR(25)) + ' ' + CAST(@Latitude AS VARCHAR(25)) + ')', 4326)			
		SET @IdPointOfInterest = (SELECT TOP 1 [Id] FROM [dbo].[GetNearPointsOfInterestWithConfRoute](@IdPersonOfInterest, @Latitude, @Longitude))
	END
	IF @Latitude = 0 OR @Longitude = 0
	BEGIN
		SET @IdPointOfInterest = NULL
	END

	IF @ConfValue = '1'
	BEGIN
		-- Inserts only if not exists same mark type
		IF NOT EXISTS (SELECT 1 FROM [dbo].[Mark] WITH (NOLOCK) WHERE [IdPersonOfInterest] = @IdPersonOfInterest  
						AND [Type] = @Type AND Tzdb.AreSameSystemDates([Date], @Date) = 1)
		BEGIN
			IF @Type <> 'E'
			BEGIN
				SET @IdParentMark = (SELECT TOP(1) [Id] FROM [dbo].[Mark] WITH (NOLOCK) 
				WHERE [IdPersonOfInterest] = @IdPersonOfInterest AND Tzdb.AreSameSystemDates([Date], @Date) = 1 AND [Type] = 'E' ORDER BY [Id] DESC)
				
				INSERT INTO [dbo].[Mark]([IdPointOfInterest],[IdPersonOfInterest], [Type], [Date], [Latitude], [Longitude], [Accuracy], [IdParent], [ReceivedDate], [LatLong], [IsOnline], [IdMarkValidationType])
				VALUES(@IdPointOfInterest, @IdPersonOfInterest, @Type, @Date, @Latitude, @Longitude, @Accuracy, @IdParentMark, GETUTCDATE(), @LatLong, (CASE WHEN @IsFinalMark = 1 THEN @IsOnline ELSE NULL END), @IdMarkValidationType)
				SELECT @Id = SCOPE_IDENTITY()
			END
			ELSE
			BEGIN
				INSERT INTO [dbo].[Mark]([IdPointOfInterest],[IdPersonOfInterest], [Type], [Date], [Latitude], [Longitude], [Accuracy], [ReceivedDate], [LatLong], [IsOnline], [IdMarkValidationType])
				VALUES (@IdPointOfInterest, @IdPersonOfInterest, @Type, @Date, @Latitude, @Longitude, @Accuracy, GETUTCDATE(), @LatLong, @IsOnline, @IdMarkValidationType)
				SELECT @Id = SCOPE_IDENTITY()
			END

			IF @Latitude = 0 OR @Longitude = 0
			BEGIN
				UPDATE	M 
				SET		M.[Latitude] = L.[Latitude],
						M.[Longitude] = L.[Longitude],
						M.[LatLong] = GEOGRAPHY::STPointFromText('POINT(' + CAST(L.[Longitude] AS VARCHAR(25)) + ' ' + CAST(L.[Latitude] AS VARCHAR(25)) + ')', 4326),
						M.[IdPointOfInterest] = (SELECT TOP 1 [Id] FROM [dbo].[GetNearPointsOfInterestWithConfRoute](@IdPersonOfInterest, L.[Latitude], L.Longitude))
				FROM	[dbo].[Mark] AS M WITH (NOLOCK)
						,[dbo].[Location] AS L WITH (NOLOCK)
				WHERE	M.[IdPersonOfInterest] = @IdPersonOfInterest
						AND M.[Latitude] = 0 AND M.[Longitude] = 0
						AND ABS(Tzdb.GetDateDiffSystemDates('dd', GETUTCDATE(), M.[Date])) <= 2
						AND L.[IdPersonOfInterest] = @IdPersonOfInterest 
						AND ABS(DATEDIFF(mi, M.[Date], L.[Date])) <= 30
						AND NOT EXISTS (SELECT	L2.[Id]
										FROM	[dbo].[Location] L2 WITH (NOLOCK)
										WHERE	L2.[IdPersonOfInterest] = @IdPersonOfInterest 
												AND ABS(DATEDIFF(ss, L2.[Date], M.[Date])) < ABS(DATEDIFF(ss, L.[Date], M.[Date])))
			END
		END
		ELSE
		BEGIN
			declare @IdAux [sys].[int] = (SELECT TOP(1) Id FROM [dbo].[Mark] WITH (NOLOCK) WHERE [IdPersonOfInterest] = @IdPersonOfInterest  
						AND [Type] = @Type AND Tzdb.AreSameSystemDates([Date], @Date) = 1)

			UPDATE	[dbo].[Mark]
			SET		[Date] = @Date
			WHERE	[Id] = @IdAux
		END
	END
	ELSE
	BEGIN

		IF NOT EXISTS (SELECT 1 FROM [dbo].[Mark] WITH (NOLOCK) WHERE [IdPersonOfInterest] = @IdPersonOfInterest  
					AND [Type] = @Type AND [Date] = @Date)
		BEGIN
			IF @Type <> 'E'
			BEGIN
				--Tengo que ir a buscar la ultima entrada que haya para esta persona (que puede ser de cualquier dia)
				SET @IdParentMark = (SELECT TOP(1) [Id] FROM [dbo].[Mark] WITH (NOLOCK) 
				WHERE [IdPersonOfInterest] = @IdPersonOfInterest AND [Type] = 'E' ORDER BY [Id] DESC)
				
				INSERT INTO [dbo].[Mark]([IdPointOfInterest],[IdPersonOfInterest], [Type], [Date], [Latitude], [Longitude], [Accuracy], [IdParent], [ReceivedDate], [LatLong], [IsOnline], [IdMarkValidationType])
				VALUES(@IdPointOfInterest, @IdPersonOfInterest, @Type, @Date, @Latitude, @Longitude, @Accuracy, @IdParentMark, GETUTCDATE(), @LatLong, (CASE WHEN @IsFinalMark = 1 THEN @IsOnline ELSE NULL END), @IdMarkValidationType)
				SELECT @Id = SCOPE_IDENTITY()
			END
			ELSE
			BEGIN
				INSERT INTO [dbo].[Mark]([IdPointOfInterest],[IdPersonOfInterest], [Type], [Date], [Latitude], [Longitude], [Accuracy], [ReceivedDate], [LatLong], [IsOnline], [IdMarkValidationType])
				VALUES (@IdPointOfInterest, @IdPersonOfInterest, @Type, @Date, @Latitude, @Longitude, @Accuracy, GETUTCDATE(), @LatLong, @IsOnline, @IdMarkValidationType)
				SELECT @Id = SCOPE_IDENTITY()
			END

			IF @Latitude = 0 OR @Longitude = 0
			BEGIN
				UPDATE	M 
				SET		M.[Latitude] = L.[Latitude],
						M.[Longitude] = L.[Longitude],
						M.[LatLong] = GEOGRAPHY::STPointFromText('POINT(' + CAST(L.[Longitude] AS VARCHAR(25)) + ' ' + CAST(L.[Latitude] AS VARCHAR(25)) + ')', 4326),
						M.[IdPointOfInterest] = (SELECT TOP 1 [Id] FROM [dbo].[GetNearPointsOfInterestWithConfRoute](@IdPersonOfInterest, L.[Latitude], L.Longitude))
				FROM	[dbo].[Mark] AS M WITH (NOLOCK)
						,[dbo].[Location] AS L WITH (NOLOCK)
				WHERE	M.[IdPersonOfInterest] = @IdPersonOfInterest
						AND M.[Latitude] = 0 AND M.[Longitude] = 0
						AND ABS(Tzdb.GetDateDiffSystemDates('dd', GETUTCDATE(), M.[Date])) <= 2
						AND L.[IdPersonOfInterest] = @IdPersonOfInterest 
						AND ABS(DATEDIFF(mi, M.[Date], L.[Date])) <= 30
						AND NOT EXISTS (SELECT	L2.[Id]
										FROM	[dbo].[Location] L2 WITH (NOLOCK)
										WHERE	L2.[IdPersonOfInterest] = @IdPersonOfInterest 
												AND ABS(DATEDIFF(ss, L2.[Date], M.[Date])) < ABS(DATEDIFF(ss, L.[Date], M.[Date])))
			END
		END
		--ELSE
		--BEGIN
		--	--declare @IdAux [sys].[int] = (SELECT TOP(1) Id FROM [dbo].[Mark] WITH (NOLOCK) WHERE [IdPersonOfInterest] = @IdPersonOfInterest  
		--	--			AND [Type] = @Type AND CAST([Date] AS [sys].[date]) = CAST(@Date AS [sys].[date]))

		--	--UPDATE	[dbo].[Mark]
		--	--SET		[Date] = @Date
		--	--WHERE	[Id] = @IdAux
		--END

	END
END
