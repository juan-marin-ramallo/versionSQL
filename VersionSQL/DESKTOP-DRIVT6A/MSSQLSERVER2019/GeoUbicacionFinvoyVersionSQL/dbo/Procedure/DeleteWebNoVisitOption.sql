/****** Object:  Procedure [dbo].[DeleteWebNoVisitOption]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 05/11/2018
-- Description:	SP para eliminar un motivo de no visita DE LA WEB
-- =============================================
CREATE PROCEDURE [dbo].[DeleteWebNoVisitOption]
(
	 @NvoNoDeletedCount [sys].[int] OUTPUT, 
	 @Id [sys].[int]
)
AS
BEGIN

	SELECT	@NvoNoDeletedCount = COUNT(1)
	FROM	[dbo].[RouteWebNoVisitOption]
	WHERE	[Deleted] = 0;

	IF(@NvoNoDeletedCount > 1)
	BEGIN
		UPDATE	[dbo].[RouteWebNoVisitOption]
		SET		[EditedDate] = GETUTCDATE(),
				[Deleted] = 1
		WHERE	[Id] = @Id
	END

END
