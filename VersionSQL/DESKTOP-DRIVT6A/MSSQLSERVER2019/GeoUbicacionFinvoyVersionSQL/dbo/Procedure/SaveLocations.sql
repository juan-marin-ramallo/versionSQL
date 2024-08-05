/****** Object:  Procedure [dbo].[SaveLocations]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 17/05/2016
-- Description:	SP para guardar un set de ubicaciones
-- =============================================
CREATE PROCEDURE [dbo].[SaveLocations]
(
	@Locations LocationTableType READONLY
)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @InsertedLocations TABLE
	(
		 [Id] [sys].[int]
		,[Date] [sys].[datetime]
	)
    
	INSERT INTO [dbo].[Location] ([IdPersonOfInterest], [ReceivedDate], [Date], [Latitude], [Longitude], [Accuracy], [Processed], [LatLong], [BatteryLevel])
	OUTPUT	inserted.[Id], inserted.[Date] INTO @InsertedLocations
	SELECT	[IdPersonOfInterest], GETUTCDATE(), [Date], [Latitude], [Longitude], [Accuracy], 0, [LatLong], [BatteryLevel]
	FROM	@Locations
	
	MERGE [dbo].[CurrentLocation] CL
	USING (
			SELECT		TOP(1) L.[IdPersonOfInterest], L.[Date], L.[Latitude], L.[Longitude], L.[Accuracy], L.[BatteryLevel], L.[LatLong], IL.[Id] AS IdLocation
			FROM		@Locations L
						INNER JOIN @InsertedLocations IL ON IL.[Date] = L.[Date]
			ORDER BY	L.[Date] DESC
	) L
	ON (CL.[IdPersonOfInterest] = L.[IdPersonOfInterest])
	WHEN NOT MATCHED BY TARGET THEN
		INSERT ([IdPersonOfInterest], [IdLocation], [Date], [Latitude], [Longitude], [Accuracy], [LatLong], [BatteryLevel])
		VALUES (L.[IdPersonOfInterest], L.[IdLocation], L.[Date], L.[Latitude], L.[Longitude], L.[Accuracy], L.[LatLong], L.[BatteryLevel])
	WHEN MATCHED AND L.[Date] >= CL.[Date] THEN
		UPDATE
		SET CL.[IdLocation] = L.[IdLocation],
			CL.[Date] = L.[Date],
			CL.[Latitude] = L.[Latitude],
			CL.[Longitude] = L.[Longitude],
			CL.[Accuracy] = L.[Accuracy],
			CL.[LatLong] = L.[LatLong],
			CL.[BatteryLevel] = L.[BatteryLevel];

	SET NOCOUNT OFF;
END
