/****** Object:  Procedure [dbo].[ProcessLocationsPointsOfInterestOld]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 11/10/2012
-- Description:	SP para procesar las marcas de entrada y salida a un punto de interés
-- =============================================
CREATE PROCEDURE [dbo].[ProcessLocationsPointsOfInterestOld]
AS
BEGIN
	DECLARE @LocationsMaxMinutesBetweenInOut [sys].[int]

	DECLARE @PendingLocationsRowNumber [sys].[int]
	DECLARE @PendingLocationsScrolled [sys].[bit]
	DECLARE @PendingLocationsValidNextRowsCount [sys].[smallint]
	DECLARE @PendingLocationsNextRowsCount [sys].[smallint]
	DECLARE @PendingLocationsNextRowsIndex [sys].[smallint]
	DECLARE @PendingLocationsNextNLocationId [sys].[int]
	DECLARE @PendingLocationsNextNIdPersonOfInterest [sys].[int]
	DECLARE @PendingLocationsNextNDate [sys].[datetime]
	DECLARE @PendingLocationsNextNLatLong [sys].[geography]

	DECLARE @LocationId [sys].[int]
	DECLARE @LocationIdPersonOfInterest [sys].[int]
	DECLARE @LocationDate [sys].[datetime]
	DECLARE @LocationLatLong [sys].[geography]
	DECLARE @PointOfInterestId [sys].[int]
	DECLARE @PointOfInterestLatLong [sys].[geography]
	DECLARE @PointOfInterestRadius [sys].[int]
	DECLARE @LastPointOfInterestVisitedId [sys].[int]
	DECLARE @LastPointOfInterestVisitedLocationIn [sys].[int]
	DECLARE @LastPointOfInterestVisitedLocationOut [sys].[int]
	DECLARE @LastPointOfInterestVisitedLocationOutDate [sys].[datetime]
	
	DECLARE @PendingLocationsCursor CURSOR 
	DECLARE @PointsOfInterestCursor CURSOR

	SET @PendingLocationsRowNumber = 0
	SET @PendingLocationsScrolled = 0
	SET @PendingLocationsNextRowsCount = 3

	SET @LocationsMaxMinutesBetweenInOut = (SELECT CAST([Value] AS [sys].[int]) FROM [dbo].[ConfigurationTranslated] WITH (NOLOCK) WHERE [Id] = 7)
	
	SET @PendingLocationsCursor = CURSOR SCROLL FOR
		SELECT	Id LocationId, IdPersonOfInterest, [Date], LatLong LocationLatLong
		FROM	dbo.LocationToCheckPointOfInterest
		ORDER BY IdPersonOfInterest, [Date]
	
	OPEN @PendingLocationsCursor
	FETCH NEXT FROM @PendingLocationsCursor
	INTO @LocationId, @LocationIdPersonOfInterest, @LocationDate, @LocationLatLong
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @PendingLocationsRowNumber = @PendingLocationsRowNumber + 1

		SET @PointsOfInterestCursor = CURSOR FAST_FORWARD FOR
			SELECT	Id PointOfInterestId, LatLong PointOfInterestLatLong, Radius PointOfInterestRadius
			FROM	dbo.PointOfInterestWithCoordinates
	
		OPEN @PointsOfInterestCursor
		FETCH NEXT FROM @PointsOfInterestCursor
		INTO @PointOfInterestId, @PointOfInterestLatLong, @PointOfInterestRadius
		
		WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @PendingLocationsValidNextRowsCount = 0
			SET @PendingLocationsNextRowsIndex = 1

			SET @LastPointOfInterestVisitedId = NULL
			SET @LastPointOfInterestVisitedLocationIn = NULL
			SET @LastPointOfInterestVisitedLocationOut = NULL
			SET @LastPointOfInterestVisitedLocationOutDate = NULL
	
			SELECT		TOP(1) @LastPointOfInterestVisitedId = PV.[Id], @LastPointOfInterestVisitedLocationIn = [IdLocationIn], @LastPointOfInterestVisitedLocationOut = [IdLocationOut], @LastPointOfInterestVisitedLocationOutDate = LOUT.[Date]
			FROM		[dbo].[PointOfInterestVisited] PV INNER JOIN
						[dbo].[Location] L ON L.Id = PV.[IdLocationIn] LEFT OUTER JOIN
						[dbo].[Location] LOUT ON LOUT.Id = PV.[IdLocationOut]
			WHERE		PV.[IdPointOfInterest] = @PointOfInterestId AND L.[IdPersonOfInterest] = @LocationIdPersonOfInterest
			ORDER BY	L.[Date] DESC
			
			-- FIRST TIME VISITING POI
			IF @LastPointOfInterestVisitedId IS NULL
			BEGIN
				IF @PointOfInterestLatLong.STDistance(@LocationLatLong) <= @PointOfInterestRadius
				BEGIN
					WHILE @PendingLocationsNextRowsIndex <= @PendingLocationsNextRowsCount
					BEGIN
						FETCH RELATIVE 1 FROM @PendingLocationsCursor
						INTO @PendingLocationsNextNLocationId, @PendingLocationsNextNIdPersonOfInterest, @PendingLocationsNextNDate, @PendingLocationsNextNLatLong

						IF @@FETCH_STATUS = 0
						BEGIN
							IF @PendingLocationsNextNIdPersonOfInterest = @LocationIdPersonOfInterest
							BEGIN
								IF @PointOfInterestLatLong.STDistance(@PendingLocationsNextNLatLong) <= @PointOfInterestRadius
								BEGIN
									SET @PendingLocationsValidNextRowsCount = @PendingLocationsValidNextRowsCount + 1
								END
							
								SET @PendingLocationsNextRowsIndex = @PendingLocationsNextRowsIndex + 1
							END
							ELSE
							BEGIN
								SET @PendingLocationsNextRowsIndex = @PendingLocationsNextRowsCount + 1
							END
						END
						ELSE
						BEGIN
							SET @PendingLocationsNextRowsIndex = @PendingLocationsNextRowsCount + 1
						END
					END

					IF @PendingLocationsValidNextRowsCount > 0
					BEGIN
						INSERT INTO [dbo].[PointOfInterestVisited]([IdLocationIn], [IdPointOfInterest])
						VALUES (@LocationId, @PointOfInterestId)
					END

					SET @PendingLocationsScrolled = 1
				END
			END
			-- POSSIBLE POI OUT
			ELSE IF @LastPointOfInterestVisitedLocationIn IS NOT NULL AND @LastPointOfInterestVisitedLocationOut IS NULL
			BEGIN
				IF @PointOfInterestLatLong.STDistance(@LocationLatLong) > @PointOfInterestRadius
				BEGIN
					WHILE @PendingLocationsNextRowsIndex <= @PendingLocationsNextRowsCount
					BEGIN
						FETCH RELATIVE 1 FROM @PendingLocationsCursor
						INTO @PendingLocationsNextNLocationId, @PendingLocationsNextNIdPersonOfInterest, @PendingLocationsNextNDate, @PendingLocationsNextNLatLong

						IF @@FETCH_STATUS = 0
						BEGIN
							IF @PendingLocationsNextNIdPersonOfInterest = @LocationIdPersonOfInterest
							BEGIN
								IF @PointOfInterestLatLong.STDistance(@PendingLocationsNextNLatLong) > @PointOfInterestRadius
								BEGIN
									SET @PendingLocationsValidNextRowsCount = @PendingLocationsValidNextRowsCount + 1
								END
							
								SET @PendingLocationsNextRowsIndex = @PendingLocationsNextRowsIndex + 1
							END
							ELSE
							BEGIN
								SET @PendingLocationsNextRowsIndex = @PendingLocationsNextRowsCount + 1
							END
						END
						ELSE
						BEGIN
							SET @PendingLocationsNextRowsIndex = @PendingLocationsNextRowsCount + 1
						END
					END

					IF @PendingLocationsValidNextRowsCount = 3
					BEGIN
						UPDATE	[dbo].[PointOfInterestVisited]
						SET		[IdLocationOut] = @LocationId,
								[ElapsedTime] = (SELECT	DATEADD(SS, DATEDIFF(SS, LIN.[Date], LOUT.[Date]), 0)
												 FROM	[dbo].[Location] LIN, [dbo].[Location] LOUT
												 WHERE	LIN.[Id] = [IdLocationIn] AND LOUT.[Id] = @LocationId)
						WHERE	[Id] = @LastPointOfInterestVisitedId
					END

					SET @PendingLocationsScrolled = 1
				END
			END
			ELSE IF @LastPointOfInterestVisitedLocationIn IS NULL AND @LastPointOfInterestVisitedLocationOut IS NOT NULL
			BEGIN
				IF @PointOfInterestLatLong.STDistance(@LocationLatLong) <= @PointOfInterestRadius
				BEGIN
					WHILE @PendingLocationsNextRowsIndex <= @PendingLocationsNextRowsCount
					BEGIN
						FETCH RELATIVE 1 FROM @PendingLocationsCursor
						INTO @PendingLocationsNextNLocationId, @PendingLocationsNextNIdPersonOfInterest, @PendingLocationsNextNDate, @PendingLocationsNextNLatLong
						
						IF @@FETCH_STATUS = 0
						BEGIN
							IF @PendingLocationsNextNIdPersonOfInterest = @LocationIdPersonOfInterest
							BEGIN
								IF @PointOfInterestLatLong.STDistance(@PendingLocationsNextNLatLong) <= @PointOfInterestRadius
								BEGIN
									SET @PendingLocationsValidNextRowsCount = @PendingLocationsValidNextRowsCount + 1
								END
								
								SET @PendingLocationsNextRowsIndex = @PendingLocationsNextRowsIndex + 1
							END
							ELSE
							BEGIN
								SET @PendingLocationsNextRowsIndex = @PendingLocationsNextRowsCount + 1
							END
						END
						ELSE
						BEGIN
							SET @PendingLocationsNextRowsIndex = @PendingLocationsNextRowsCount + 1
						END
					END

					IF @PendingLocationsValidNextRowsCount = 3
					BEGIN
						UPDATE	[dbo].[PointOfInterestVisited]
						SET		[IdLocationIn] = @LocationId,
								[ElapsedTime] = (SELECT	DATEADD(SS, DATEDIFF(SS, LIN.[Date], LOUT.[Date]), 0)
												 FROM	[dbo].[Location] LIN, [dbo].[Location] LOUT
												 WHERE	LIN.[Id] = @LocationId AND LOUT.[Id] = [IdLocationOut])
						WHERE	[Id] = @LastPointOfInterestVisitedId
					END

					SET @PendingLocationsScrolled = 1
				END
			END
			-- POSSIBLE POI IN
			ELSE
			BEGIN
				IF @PointOfInterestLatLong.STDistance(@LocationLatLong) <= @PointOfInterestRadius
				BEGIN
					WHILE @PendingLocationsNextRowsIndex <= @PendingLocationsNextRowsCount
					BEGIN
						FETCH RELATIVE 1 FROM @PendingLocationsCursor
						INTO @PendingLocationsNextNLocationId, @PendingLocationsNextNIdPersonOfInterest, @PendingLocationsNextNDate, @PendingLocationsNextNLatLong

						IF @@FETCH_STATUS = 0
						BEGIN
							IF @PendingLocationsNextNIdPersonOfInterest = @LocationIdPersonOfInterest
							BEGIN
								IF @PointOfInterestLatLong.STDistance(@PendingLocationsNextNLatLong) <= @PointOfInterestRadius
								BEGIN
									SET @PendingLocationsValidNextRowsCount = @PendingLocationsValidNextRowsCount + 1
								END

								SET @PendingLocationsNextRowsIndex = @PendingLocationsNextRowsIndex + 1
							END
							ELSE
							BEGIN
								SET @PendingLocationsNextRowsIndex = @PendingLocationsNextRowsCount + 1
							END
						END
						ELSE
						BEGIN
							SET @PendingLocationsNextRowsIndex = @PendingLocationsNextRowsCount + 1
						END
					END

					IF @PendingLocationsValidNextRowsCount > 0
					BEGIN
						IF @LastPointOfInterestVisitedLocationOutDate IS NOT NULL AND DATEDIFF(MINUTE, @LastPointOfInterestVisitedLocationOutDate, @LocationDate) <= @LocationsMaxMinutesBetweenInOut
						BEGIN
							UPDATE  [dbo].[PointOfInterestVisited]
							SET		[IdLocationOut] = NULL
							WHERE	[Id] = @LastPointOfInterestVisitedId
						END
						ELSE
						BEGIN
							INSERT INTO [dbo].[PointOfInterestVisited]([IdLocationIn], [IdPointOfInterest])
							VALUES (@LocationId, @PointOfInterestId)
						END
					END

					SET @PendingLocationsScrolled = 1
				END
			END

			IF @PendingLocationsScrolled = 1
			BEGIN
				FETCH ABSOLUTE @PendingLocationsRowNumber FROM @PendingLocationsCursor
				INTO @LocationId, @LocationIdPersonOfInterest, @LocationDate, @LocationLatLong

				SET @PendingLocationsScrolled = 0
			END
			
			FETCH NEXT FROM @PointsOfInterestCursor
			INTO @PointOfInterestId, @PointOfInterestLatLong, @PointOfInterestRadius
		END
		
		CLOSE @PointsOfInterestCursor
		DEALLOCATE @PointsOfInterestCursor
		
		UPDATE	[dbo].[Location]
		SET		[Processed] = 1
		WHERE	[Id] = @LocationId

		FETCH NEXT FROM @PendingLocationsCursor
		INTO @LocationId, @LocationIdPersonOfInterest, @LocationDate, @LocationLatLong
	END
	
	CLOSE @PendingLocationsCursor
	DEALLOCATE @PendingLocationsCursor
END
