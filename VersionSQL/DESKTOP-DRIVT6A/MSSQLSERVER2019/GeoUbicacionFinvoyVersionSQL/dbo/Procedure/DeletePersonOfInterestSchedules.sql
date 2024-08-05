/****** Object:  Procedure [dbo].[DeletePersonOfInterestSchedules]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 27/02/2013
-- Description:	SP para eliminar los horarios de trabajo de una persona de interés
-- =============================================
CREATE PROCEDURE [dbo].[DeletePersonOfInterestSchedules]
(
	 @IdPersonOfInterest [sys].[int]
)
AS
BEGIN
	DELETE FROM	[dbo].[PersonOfInterestSchedule]
	WHERE		[IdPersonOfInterest] = @IdPersonOfInterest
END
