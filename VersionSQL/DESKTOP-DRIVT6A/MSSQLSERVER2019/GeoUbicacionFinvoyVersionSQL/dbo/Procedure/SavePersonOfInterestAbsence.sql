/****** Object:  Procedure [dbo].[SavePersonOfInterestAbsence]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 03/04/2020
-- Description:	SP para guardar el comienzo de ausencia de una persona de interés
-- =============================================
CREATE PROCEDURE [dbo].[SavePersonOfInterestAbsence]
(
	 @Id [sys].[int] OUTPUT
	,@IdPersonOfInterest [sys].[int]
	,@FromDate [sys].[datetime]
)
AS
BEGIN
	INSERT INTO [dbo].[PersonOfInterestAbsence]([IdPersonOfInterest], [FromDate], [FromSavedDate])
	VALUES (@IdPersonOfInterest, @FromDate, GETUTCDATE())
	
	SELECT @Id = SCOPE_IDENTITY()
END
