/****** Object:  Procedure [dbo].[DeleteNoVisitOption]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 05/08/2016
-- Description:	SP para eliminar un motivo de no visita
-- =============================================
CREATE PROCEDURE [dbo].[DeleteNoVisitOption]
(
	 @NvoNoDeletedCount [sys].[int] OUTPUT, 
	 @Id [sys].[int]
)
AS
BEGIN

	SELECT @NvoNoDeletedCount = COUNT(1)
	FROM RouteNoVisitOption
	WHERE Deleted = 0;

	IF(@NvoNoDeletedCount > 1)
	BEGIN
		UPDATE	[dbo].[RouteNoVisitOption]
		SET		[EditedDate] = GETUTCDATE(),
				[Deleted] = 1
		WHERE	 [Id] = @Id
	END

END
