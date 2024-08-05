/****** Object:  Procedure [dbo].[GetMessagesDates]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 11/03/2013
-- Description:	SP para obtener las fechas de los mensajes
-- =============================================
CREATE PROCEDURE [dbo].[GetMessagesDates]
(
	 @DateFrom [sys].[datetime]
	,@DateTo [sys].[datetime]
)
AS
BEGIN
	SELECT		CAST([Date] AS [sys].[date]) AS [Date]
	FROM		[dbo].[Message]
	WHERE		[Date] BETWEEN @DateFrom AND @DateTo
	GROUP BY	CAST([Date] AS [sys].[date])
	ORDER BY	[Date] DESC
END
