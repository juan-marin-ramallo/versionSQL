/****** Object:  Procedure [dbo].[ProcessLocationsPointsOfInterest]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Los Sobrales
-- Create date: 26/11/2013
-- Description:	SP para procesar las marcas de entrada y salida a un punto de interés
-- =============================================
CREATE PROCEDURE [dbo].[ProcessLocationsPointsOfInterest]
AS
BEGIN
	DECLARE @LocationsMaxMinutesBetweenInOut [sys].[int]
	DECLARE @LocationsMaxReliableAccuracy [sys].[int]
	DECLARE @LocationsMinHoursTosuspectChangeOfDay [sys].[int]

	DECLARE @PendingLocationsRowNumber [sys].[int]
	DECLARE @PendingLocationsScrolled [sys].[bit]
	DECLARE @PendingLocationsValidNextRowsCount [sys].[smallint]
	DECLARE @PendingLocationsNextRowsCount [sys].[smallint]
	DECLARE @PendingLocationsNextRowsIndex [sys].[smallint]
	DECLARE @PendingLocationsNextNLocationId [sys].[int]
	DECLARE @PendingLocationsNextIdPersonOfInterest [sys].[int]
	DECLARE @PendingLocationsNextNDate [sys].[datetime]
	DECLARE @PendingLocationsNextNLatLong [sys].[geography]
	DECLARE @PendingLocationsNextAccuracy decimal(8,1)

	DECLARE @LocationId [sys].[int]
	DECLARE @LocationPersonOfInterestId [sys].[int]
	DECLARE @LocationDate [sys].[datetime]
	DECLARE @LocationLatLong [sys].[geography]
	DECLARE @LocationAccuracy decimal(8,1)
	DECLARE @PointOfInterestId [sys].[int]
	DECLARE @PointOfInterestLatLong [sys].[geography]
	DECLARE @PointOfInterestRadius [sys].[int]
	DECLARE @PointOfInterestMinElapsedTimeForVisit [sys].[int]
	DECLARE @LastPointOfInterestVisitedId [sys].[int]
	DECLARE @LastPointOfInterestVisitedLocationIn [sys].[int]
	DECLARE @LastPointOfInterestVisitedLocationInDate [sys].[datetime]
	DECLARE @LastPointOfInterestVisitedLocationOut [sys].[int]
	DECLARE @LastPointOfInterestVisitedLocationOutDate [sys].[datetime]
	
	DECLARE @PreviousLocationPersonOfInterestId [sys].[int]

	DECLARE @PreviousDayLastLocationId [sys].[int]
	DECLARE @LocationEnoughDataToProcess [sys].[bit]
	
	DECLARE @PendingLocationsCursor CURSOR 
	DECLARE @PointsOfInterestCursor CURSOR

	SET @PendingLocationsRowNumber = 0
	SET @PendingLocationsScrolled = 0
	SET @PendingLocationsNextRowsCount = 2
	SET @PreviousLocationPersonOfInterestId = ''

	SET @LocationsMaxMinutesBetweenInOut = (SELECT CAST([Value] AS [sys].[int]) FROM [dbo].[ConfigurationTranslated] WITH (NOLOCK) WHERE [Id] = 7)
	SET @LocationsMaxReliableAccuracy = (SELECT CAST([Value] AS [sys].[int]) FROM [dbo].[ConfigurationTranslated] WITH (NOLOCK) WHERE [Id] = 8)
	SET @LocationsMinHoursTosuspectChangeOfDay = (SELECT CAST([Value] AS [sys].[int]) FROM [dbo].[ConfigurationTranslated] WITH (NOLOCK) WHERE [Id] = 9)

	--Locations Cursor
	--Solo las locaciones no procesadas
	SET @PendingLocationsCursor = CURSOR SCROLL FOR
		SELECT	Id LocationId, IdPersonOfInterest LocationPersonOfInterestId , [Date], LatLong LocationLatLong, Accuracy
		FROM	dbo.LocationToCheckPointOfInterest
		ORDER BY LocationPersonOfInterestId, [Date]
	
	--Pido la primer locacion pendiente
	OPEN @PendingLocationsCursor
	FETCH NEXT FROM @PendingLocationsCursor
	INTO @LocationId, @LocationPersonOfInterestId, @LocationDate, @LocationLatLong, @LocationAccuracy

	--Para cada locación pendiente
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @PendingLocationsRowNumber = @PendingLocationsRowNumber + 1

		-- NEW: Si cambio el stocker, ponemos @LocationEnoughDataToProcess en true
		IF @PreviousLocationPersonOfInterestId <> @LocationPersonOfInterestId
		BEGIN 
			SET @LocationEnoughDataToProcess = 1
		END

		--Creo cursos para recorrer PointsOfInterest
		SET @PointsOfInterestCursor = CURSOR FAST_FORWARD FOR
			SELECT	Id PointOfInterestId, LatLong PointOfInterestLatLong, Radius PointOfInterestRadius, MinElapsedTimeForVisit PointOfInterestMinElapsedTimeForVisit
			FROM	dbo.PointOfInterestWithCoordinates
	
		--Pido el primer Punto de Interes
		OPEN @PointsOfInterestCursor
		FETCH NEXT FROM @PointsOfInterestCursor
		INTO @PointOfInterestId, @PointOfInterestLatLong, @PointOfInterestRadius, @PointOfInterestMinElapsedTimeForVisit
		
		--Para cada Locacion, Para cada Punto de Interes
		WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @PendingLocationsValidNextRowsCount = 0
			SET @PendingLocationsNextRowsIndex = 1

			SET @LastPointOfInterestVisitedId = NULL
			SET @LastPointOfInterestVisitedLocationIn = NULL
			SET @LastPointOfInterestVisitedLocationOut = NULL
			SET @LastPointOfInterestVisitedLocationOutDate = NULL
	
			--Obtengo los datos de la ultima vez que visite el punto de interes
			SELECT		TOP(1) @LastPointOfInterestVisitedId = PV.[Id], @LastPointOfInterestVisitedLocationIn = [IdLocationIn], @LastPointOfInterestVisitedLocationInDate = LIN.[Date], @LastPointOfInterestVisitedLocationOut = [IdLocationOut], @LastPointOfInterestVisitedLocationOutDate = LOUT.[Date]
			FROM		[dbo].[PointOfInterestVisited] PV INNER JOIN
						[dbo].[Location] L ON L.Id = PV.[IdLocationIn] LEFT OUTER JOIN
						[dbo].[Location] LOUT ON LOUT.Id = PV.[IdLocationOut]LEFT OUTER JOIN
						[dbo].[Location] LIN ON LIN.Id = PV.[IdLocationIn]
			WHERE		PV.[IdPointOfInterest] = @PointOfInterestId AND L.[IdPersonOfInterest] = @LocationPersonOfInterestId
			ORDER BY	L.[Date] DESC					
			
			-- FIRST TIME VISITING POI
			IF @LastPointOfInterestVisitedId IS NULL
			BEGIN
				-- Si estoy en el radio del POI
				IF @PointOfInterestLatLong.STDistance(@LocationLatLong) <= @PointOfInterestRadius
				BEGIN
					SET @PendingLocationsValidNextRowsCount = @PendingLocationsValidNextRowsCount + 1

					--Recorro hasta 3 locaciones
					-- NEW: en caso de no tener suficientes datos corto el loop
					WHILE @PendingLocationsNextRowsIndex <= @PendingLocationsNextRowsCount AND @LocationEnoughDataToProcess = 1
					BEGIN
					
						--Obtengo la locación siguiente
						FETCH RELATIVE 1 FROM @PendingLocationsCursor
						INTO @PendingLocationsNextNLocationId, @PendingLocationsNextIdPersonOfInterest, @PendingLocationsNextNDate, @PendingLocationsNextNLatLong, @PendingLocationsNextAccuracy

						--Si hay locacion
						IF @@FETCH_STATUS = 0
						BEGIN
							--Si la nueva locacion es de la misma persona de interes que la locacion actual
							IF @PendingLocationsNextIdPersonOfInterest = @LocationPersonOfInterestId
							BEGIN
								--Si la nueva locacion tambien esta dentro del radio
								IF @PointOfInterestLatLong.STDistance(@PendingLocationsNextNLatLong) <= @PointOfInterestRadius
								BEGIN
									SET @PendingLocationsValidNextRowsCount = @PendingLocationsValidNextRowsCount + 1
								END 
								ELSE IF @PendingLocationsNextAccuracy >= @LocationsMaxReliableAccuracy
								BEGIN
									SET @PendingLocationsValidNextRowsCount = @PendingLocationsValidNextRowsCount + 1
								END
							
								SET @PendingLocationsNextRowsIndex = @PendingLocationsNextRowsIndex + 1
							END
							--NEW: Si no hay suficientes datos, no sigo con el loop
							ELSE
							BEGIN
								SET @LocationEnoughDataToProcess = 0
							END
						END
						--Si no hay más datos, termina el while
						ELSE
						BEGIN
							SET @LocationEnoughDataToProcess = 0
						END
					END

					IF @PendingLocationsValidNextRowsCount > 1
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
				-- Si el punto esta afuera
				IF @PointOfInterestLatLong.STDistance(@LocationLatLong) > @PointOfInterestRadius
				BEGIN
					SET @PendingLocationsValidNextRowsCount = @PendingLocationsValidNextRowsCount + 1

					-- Locacion afuera, en un tiempo mayor al minimo
					IF  DATEDIFF(MINUTE, @LastPointOfInterestVisitedLocationInDate, @LocationDate) > @PointOfInterestMinElapsedTimeForVisit
					BEGIN
						WHILE @PendingLocationsNextRowsIndex <= @PendingLocationsNextRowsCount AND @LocationEnoughDataToProcess = 1
						BEGIN
							FETCH RELATIVE 1 FROM @PendingLocationsCursor
							INTO @PendingLocationsNextNLocationId, @PendingLocationsNextIdPersonOfInterest, @PendingLocationsNextNDate, @PendingLocationsNextNLatLong, @PendingLocationsNextAccuracy

							IF @@FETCH_STATUS = 0
							BEGIN
								-- Si el dato es de la misma persona
								IF @PendingLocationsNextIdPersonOfInterest = @LocationPersonOfInterestId
								BEGIN
									-- Si tambien es afuera lo cuento porque necesito 3 afuera
									IF @PointOfInterestLatLong.STDistance(@PendingLocationsNextNLatLong) > @PointOfInterestRadius
									BEGIN
										SET @PendingLocationsValidNextRowsCount = @PendingLocationsValidNextRowsCount + 1
										SET @PendingLocationsNextRowsIndex = @PendingLocationsNextRowsIndex + 1
									END
									-- Si me aparece un punto adentro, entonces no puedo considerar la salida
									ELSE
									BEGIN
										SET @PendingLocationsNextRowsIndex = @PendingLocationsNextRowsCount + 1
									END
								END
								ELSE
								BEGIN
									SET @LocationEnoughDataToProcess = 0
								END
							END
							ELSE
							BEGIN
								SET @LocationEnoughDataToProcess = 0
							END
						END

						IF @PendingLocationsValidNextRowsCount = 3
						BEGIN
							IF DATEDIFF(HOUR, @LastPointOfInterestVisitedLocationInDate, @LocationDate) > @LocationsMinHoursTosuspectChangeOfDay
							BEGIN
								SET @PreviousDayLastLocationId = (SELECT TOP(1)  LPREV.[ID]
															FROM [dbo].[Location] LPREV
															WHERE LPREV.[IdPersonOfInterest] = @LocationPersonOfInterestId AND LPREV.[Id] < @LocationId
															ORDER BY LPREV.[id] desc)

								UPDATE	[dbo].[PointOfInterestVisited]
								SET		[IdLocationOut] = @PreviousDayLastLocationId,
										[ElapsedTime] = (SELECT	DATEADD(SS, DATEDIFF(SS, LIN.[Date], LOUT.[Date]), 0)
														 FROM	[dbo].[Location] LIN, [dbo].[Location] LOUT
														 WHERE	LIN.[Id] = [IdLocationIn] AND LOUT.[Id] = @PreviousDayLastLocationId)
								WHERE	[Id] = @LastPointOfInterestVisitedId								
							END
							ELSE
							BEGIN
								UPDATE	[dbo].[PointOfInterestVisited]
								SET		[IdLocationOut] = @LocationId,
										[ElapsedTime] = (SELECT DATEADD(SS, DATEDIFF(SS, LIN.[Date], LOUT.[Date]), 0)
														 FROM	[dbo].[Location] LIN, [dbo].[Location] LOUT
														 WHERE	LIN.[Id] = [IdLocationIn] AND LOUT.[Id] = @LocationId)
								WHERE	[Id] = @LastPointOfInterestVisitedId
							END												
						END

						SET @PendingLocationsScrolled = 1
					END
					-- Locacion afuera, en un tiempo menor del minimo
					ELSE
					BEGIN
					WHILE @PendingLocationsNextRowsIndex <= @PendingLocationsNextRowsCount AND @LocationEnoughDataToProcess = 1
						BEGIN
							FETCH RELATIVE 1 FROM @PendingLocationsCursor
							INTO @PendingLocationsNextNLocationId, @PendingLocationsNextIdPersonOfInterest, @PendingLocationsNextNDate, @PendingLocationsNextNLatLong, @PendingLocationsNextAccuracy

							IF @@FETCH_STATUS = 0
							BEGIN
								IF @PendingLocationsNextIdPersonOfInterest = @LocationPersonOfInterestId
								BEGIN
									IF @PointOfInterestLatLong.STDistance(@PendingLocationsNextNLatLong) > @PointOfInterestRadius
									BEGIN
										SET @PendingLocationsValidNextRowsCount = @PendingLocationsValidNextRowsCount + 1
									END
									SET @PendingLocationsNextRowsIndex = @PendingLocationsNextRowsIndex + 1
								END
								ELSE
								BEGIN
									SET @LocationEnoughDataToProcess = 0
								END
							END
							ELSE
							BEGIN
								SET @LocationEnoughDataToProcess = 0
							END
						END

						IF @PendingLocationsValidNextRowsCount > 2
						BEGIN
							DELETE FROM [dbo].[PointOfInterestVisited]
							WHERE [Id] = @LastPointOfInterestVisitedId
						END

						SET @PendingLocationsScrolled = 1
					END
				END
			END

			-- POSSIBLE POI IN
			-- Si detecte visitas anteriores al POI
			ELSE 
			BEGIN
				-- Si la locacion esta dentro del radio
				IF @PointOfInterestLatLong.STDistance(@LocationLatLong) <= @PointOfInterestRadius
				BEGIN
					SET @PendingLocationsValidNextRowsCount = @PendingLocationsValidNextRowsCount + 1

					-- Recorro hasta 3 locaciones siguientes
					-- Y guardo cuantas más estan dentro del radio del POI
					WHILE @PendingLocationsNextRowsIndex <= @PendingLocationsNextRowsCount AND @LocationEnoughDataToProcess = 1
					BEGIN
						FETCH RELATIVE 1 FROM @PendingLocationsCursor
						INTO @PendingLocationsNextNLocationId, @PendingLocationsNextIdPersonOfInterest, @PendingLocationsNextNDate, @PendingLocationsNextNLatLong, @PendingLocationsNextAccuracy

						IF @@FETCH_STATUS = 0
						BEGIN
							IF @PendingLocationsNextIdPersonOfInterest = @LocationPersonOfInterestId
							BEGIN
								IF @PointOfInterestLatLong.STDistance(@PendingLocationsNextNLatLong) <= @PointOfInterestRadius
								BEGIN
									SET @PendingLocationsValidNextRowsCount = @PendingLocationsValidNextRowsCount + 1
								END
								ELSE IF @PendingLocationsNextAccuracy >= @LocationsMaxReliableAccuracy
								BEGIN
									SET @PendingLocationsValidNextRowsCount = @PendingLocationsValidNextRowsCount + 1
								END

								SET @PendingLocationsNextRowsIndex = @PendingLocationsNextRowsIndex + 1
							END
							ELSE
							BEGIN
								SET @LocationEnoughDataToProcess = 0
							END
						END
						ELSE
						BEGIN
							SET @LocationEnoughDataToProcess = 0
						END
					END

					IF @PendingLocationsValidNextRowsCount > 1
					BEGIN
						-- Si paso menos del tiempo aceptado entre salida y entrada, borro la salida
						IF @LastPointOfInterestVisitedLocationOutDate IS NOT NULL AND DATEDIFF(MINUTE, @LastPointOfInterestVisitedLocationOutDate, @LocationDate) <= @LocationsMaxMinutesBetweenInOut
						BEGIN
							UPDATE  [dbo].[PointOfInterestVisited]
							SET		[IdLocationOut] = NULL
									,[ElapsedTime] = NULL
							WHERE	[Id] = @LastPointOfInterestVisitedId							
						END
						-- Si no, es porque es una nueva visita y la inserto.
						ELSE
						BEGIN
							INSERT INTO [dbo].[PointOfInterestVisited]([IdLocationIn], [IdPointOfInterest])
							VALUES (@LocationId, @PointOfInterestId)
																															
						END
						-- Este punto se puede procesar
						SET @LocationEnoughDataToProcess = 1
					END

					SET @PendingLocationsScrolled = 1
				END
			END

			IF @PendingLocationsScrolled = 1
			BEGIN
				FETCH ABSOLUTE @PendingLocationsRowNumber FROM @PendingLocationsCursor
				INTO @LocationId, @LocationPersonOfInterestId, @LocationDate, @LocationLatLong, @LocationAccuracy

				SET @PendingLocationsScrolled = 0
			END
			
			FETCH NEXT FROM @PointsOfInterestCursor
			INTO @PointOfInterestId, @PointOfInterestLatLong, @PointOfInterestRadius, @PointOfInterestMinElapsedTimeForVisit
		END
		
		CLOSE @PointsOfInterestCursor
		DEALLOCATE @PointsOfInterestCursor
		
		IF @LocationEnoughDataToProcess = 1
		BEGIN
			UPDATE	[dbo].[Location]
			SET		[Processed] = 1
			WHERE	[Id] = @LocationId
		END

		SET @PreviousLocationPersonOfInterestId = @LocationPersonOfInterestId

		FETCH NEXT FROM @PendingLocationsCursor
		INTO @LocationId, @LocationPersonOfInterestId, @LocationDate, @LocationLatLong, @LocationAccuracy

	END
	
	CLOSE @PendingLocationsCursor
	DEALLOCATE @PendingLocationsCursor
END
