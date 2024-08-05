/****** Object:  Procedure [dbo].[GetSchedules]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author: Cristian Barbarini
-- Create date: 02/08/2022
-- Description: SP para verificar si tiene condiciones
-- =============================================
CREATE PROCEDURE [dbo].[GetSchedules]
(
	@IdForm INT = NULL,
	@IdProduct INT = NULL,
	@IdPerson INT = NULL,
	@IdPoint INT = NULL,
	@CompletedDate DATETIME
)
AS
BEGIN
	SELECT sr.Id, sr.SubjectEmail, sr.BodyEmail
	FROM ScheduleReport sr (NOLOCK)
	INNER JOIN ScheduleReportFilterCondition srfc (NOLOCK) ON sr.Id = srfc.IdScheduleReport
	LEFT JOIN ScheduleReportPersonOfInterest srpeoi (NOLOCK) ON sr.Id = srpeoi.IdScheduleReport
	LEFT JOIN ScheduleReportPointOfInterest srpoi (NOLOCK) ON sr.Id = srpoi.IdScheduleReport
	WHERE UPPER(sr.RecurrenceCondition) = 'R'
		AND (@IdForm IS NULL OR sr.IdForm = @IdForm)
		--AND (@IdProduct IS NULL OR srfc.IdProduct = @IdProduct OR (srfc.IdProduct IS NULL AND srfc.IdProductReportAttribute IS NOT NULL))
		AND ((@IdProduct IS NULL OR @IdProduct = 0) OR srfc.IdProduct = @IdProduct OR (srfc.IdProduct IS NULL AND srfc.IdProductReportAttribute IS NOT NULL))
		AND (@IdPerson IS NULL OR srpeoi.IdPersonOfInterest IS NULL OR srpeoi.IdPersonOfInterest = @IdPerson)
		AND (@IdPoint IS NULL OR srpoi.IdPointOfInterest IS NULL OR srpoi.IdPointOfInterest = @IdPoint)
		AND sr.Deleted = 0
		AND @CompletedDate BETWEEN sr.DateFrom AND sr.DateTo
	GROUP BY sr.Id, sr.SubjectEmail, sr.BodyEmail
END
