/****** Object:  Procedure [dbo].[UpdatePersonOfInterestAbsence]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 03/04/2020
-- Description:	SP para guardar el fin de ausencia de una persona de interés
-- =============================================
CREATE PROCEDURE [dbo].[UpdatePersonOfInterestAbsence]
(
	 @IdPersonOfInterest [sys].[int]
	,@ToDate [sys].[datetime]
)
AS
BEGIN
	UPDATE	[dbo].[PersonOfInterestAbsence]
	SET		  [ToDate] = @ToDate
         ,[ToSavedDate] = GETUTCDATE()
	WHERE	  [IdPersonOfInterest] = @IdPersonOfInterest AND [ToDate] IS NULL

	SELECT @@ROWCOUNT
END
