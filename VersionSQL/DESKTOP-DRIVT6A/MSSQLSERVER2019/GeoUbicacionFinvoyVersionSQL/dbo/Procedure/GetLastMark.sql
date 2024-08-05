/****** Object:  Procedure [dbo].[GetLastMark]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		FS
-- Create date: 20/03/20
-- Description:	SP para obtener la última marcas realizada
-- =============================================
-- =============================================
CREATE PROCEDURE [dbo].[GetLastMark]
	@IdPersonOfInterest [sys].[int]
AS
BEGIN

	SELECT TOP 1 M.Id, M.[Date], M.ReceivedDate, M.[Type], MT.[Description] AS MarkType, M.Latitude, M.Longitude
			, P.Id AS PointId, P.[Name] AS PointName
	FROM dbo.Mark M WITH(NOLOCK)
		INNER JOIN dbo.MarkTypeTranslated MT WITH(NOLOCK) ON M.[Type] = MT.Code
		LEFT JOIN dbo.PointOfInterest P WITH(NOLOCK) ON M.IdPointOfInterest = P.Id
	WHERE	M.IdPersonOfInterest = @IdPersonOfInterest
	ORDER BY M.[Date] DESC

END
