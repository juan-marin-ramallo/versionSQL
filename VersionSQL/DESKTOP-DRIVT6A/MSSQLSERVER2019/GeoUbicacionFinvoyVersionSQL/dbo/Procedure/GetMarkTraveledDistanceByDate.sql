/****** Object:  Procedure [dbo].[GetMarkTraveledDistanceByDate]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 04/06/2021
-- Description:	SP para obtener la distancia recorrida
--				de la última marca de salida del día
--				de la fecha dada por parámetros
-- =============================================
CREATE PROCEDURE [dbo].[GetMarkTraveledDistanceByDate]
(
	 @IdPersonOfInterest [sys].[int]
	,@Date [sys].[datetime]
)
AS
BEGIN
	DECLARE @DateFrom [sys].[datetime]
	SET @DateFrom = Tzdb.ToUtc(DATEADD(DAY, 0, DATEDIFF(DAY, 0, Tzdb.FromUtc(@Date))))

	SELECT TOP(1)	[TraveledDistance]
	FROM			[dbo].[Mark] WITH (NOLOCK)
	WHERE			[IdPersonOfInterest] = @IdPersonOfInterest
					AND [Date] BETWEEN @DateFrom AND @Date
					AND [Type] = 'S'
	ORDER BY		[Date] DESC
END
