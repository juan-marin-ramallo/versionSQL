/****** Object:  Procedure [dbo].[GetPersonOfInterestLastLocationOfDay]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 28/09/2020
-- Description:	SP para obtener la última locación anterior a la fecha dada para una Persona de Interes
-- =============================================
CREATE PROCEDURE [dbo].[GetPersonOfInterestLastLocationOfDay]
(
	 @IdPersonOfInterest [sys].[int]
    ,@Date [sys].[datetime]
)
AS
BEGIN
	DECLARE @DateFrom [sys].[datetime], @DateTo [sys].[datetime]
	SET @DateFrom = Tzdb.ToUtc(DATEADD(DAY, DATEDIFF(DAY, 0, Tzdb.FromUtc(@Date)), 0))
	SET @DateTo = Tzdb.ToUtc(DATEADD(DAY, 1 + DATEDIFF(DAY, 0, Tzdb.FromUtc(@Date)), 0))

	SELECT		TOP(1)  [Id], [Date], [Latitude], [Longitude], [Accuracy]
	FROM		[dbo].[Location] WITH (NOLOCK)
	WHERE		[IdPersonOfInterest] = @IdPersonOfInterest AND
				[Date] >= @DateFrom AND [Date] < @DateTo
	ORDER BY	[Id] DESC
END
