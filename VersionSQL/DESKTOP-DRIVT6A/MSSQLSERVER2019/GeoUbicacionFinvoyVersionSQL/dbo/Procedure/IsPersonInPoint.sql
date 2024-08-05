/****** Object:  Procedure [dbo].[IsPersonInPoint]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 09/08/2016
-- Description:	SP para saber si una persona está o no dentro del punto de interés.
-- =============================================
CREATE PROCEDURE [dbo].[IsPersonInPoint] 
 	@IdPersonOfInterest [sys].[int],
	@IdPointOfInterest [sys].[int],
	@IsInPoint [sys].[int] OUT
AS
BEGIN
	DECLARE @PersonOfInterestLatLong [sys].[geography] 
	DECLARE @DateLastLocation [sys].[datetime]
	DECLARE @IsInPointAux [sys].[int] = 0

	DECLARE @TimeConfigInMinutes [sys].[int] = CAST((SELECT [Value] FROM [dbo].[ConfigurationTranslated] WITH (NOLOCK) WHERE [Id] = 2056) AS [sys].[int] )

	SET @PersonOfInterestLatLong = (SELECT TOP 1 [LatLong] FROM [dbo].[CurrentLocation] with(nolock) WHERE [IdPersonOfInterest] = @IdPersonOfInterest ORDER BY [Date] DESC)
	SET @DateLastLocation = (SELECT TOP 1 [Date] FROM [dbo].[CurrentLocation] with(nolock) WHERE [IdPersonOfInterest] = @IdPersonOfInterest ORDER BY [Date] DESC)

	--Solo busco si la ultima coordenada (fecha) es menor que la fecha actual - @TimeConfigInMinutes
	--De lo contrario asumo que ya no está en el punto.
	DECLARE @DateToCompare [sys].[datetime] = DATEADD(MINUTE, -@TimeConfigInMinutes, GETUTCDATE())
	IF @DateLastLocation >= @DateToCompare
	BEGIN
		DECLARE @Now [sys].[datetime]
		SET @Now = GETUTCDATE()

		SELECT	@IsInPointAux = (CASE WHEN P.[Id] IS NULL THEN 0 ELSE 1 END)
		
		FROM	[dbo].[PointOfInterest] P WITH (NOLOCK)
				INNER JOIN [dbo].[PointOfInterestVisited] PV WITH (NOLOCK) ON P.[Id] = PV.[IdPointOfInterest] 
							AND PV.[IdPersonOfInterest] = @IdPersonOfInterest AND PV.[IdLocationOut] IS NULL
							AND Tzdb.AreSameSystemDates(PV.[LocationInDate], @Now) = 1
		
		WHERE	P.[Deleted] = 0 AND P.[Id] = @IdPointOfInterest
		
		GROUP BY P.[Id]

		IF @IsInPointAux = 0
		BEGIN

			SELECT	@IsInPointAux = (CASE WHEN P.[Id] IS NULL THEN 0 ELSE 1 END)
		
			FROM	[dbo].[PointOfInterest] P WITH (NOLOCK)
					LEFT OUTER JOIN [dbo].[PointOfInterestVisited] PV WITH (NOLOCK) ON P.[Id] = PV.[IdPointOfInterest] 
						AND PV.[IdPersonOfInterest] = @IdPersonOfInterest AND PV.[IdLocationOut] IS NULL
						AND Tzdb.AreSameSystemDates(PV.[LocationInDate], @Now) = 1
					
			WHERE	(P.[LatLong].STDistance(@PersonOfInterestLatLong) - P.[Radius]) <= P.[Radius]
					AND PV.[Id] IS NULL AND P.[Deleted] = 0 AND P.[Id] = @IdPointOfInterest
		
			GROUP BY P.[Id]

		END
	END

	SET @IsInPoint = @IsInPointAux

END
