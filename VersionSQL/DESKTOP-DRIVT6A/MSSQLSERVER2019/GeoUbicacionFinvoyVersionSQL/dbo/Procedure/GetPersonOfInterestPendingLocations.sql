/****** Object:  Procedure [dbo].[GetPersonOfInterestPendingLocations]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 28/05/2015
-- Description:	SP para obtener las locaciones pendientes de una Persona de Interes
-- =============================================
CREATE PROCEDURE [dbo].[GetPersonOfInterestPendingLocations]
(
	@IdPersonOfInterest [sys].[int]
)
AS
BEGIN
	;WITH LocationsToCheck([RowNumber], [Id], [Date], [Latitude], [Longitude], [Accuracy]) AS
	(
		SELECT		TOP(5000) ROW_NUMBER() OVER (PARTITION BY [Date] ORDER BY [Date], [IdPersonOfInterest]) AS RowNumber, [Id], [Date], [Latitude], [Longitude], [Accuracy]
		FROM		dbo.LocationToCheckPointOfInterest WITH (NOLOCK)
		WHERE		[IdPersonOfInterest] = @IdPersonOfInterest
	)

	SELECT		[Id], [Date], [Latitude], [Longitude], [Accuracy], (CASE WHEN [RowNumber] = 1 THEN 0 ELSE 1 END) AS [Duplicated]
	FROM		[LocationsToCheck]
	ORDER BY	[Date]

	-- OLD)
	--SELECT		TOP(5000) Id, [Date], Latitude, Longitude, Accuracy
	--FROM		dbo.LocationToCheckPointOfInterest WITH (NOLOCK)
	--WHERE		IdPersonOfInterest = @IdPersonOfInterest
	--ORDER BY	[Date]
END
