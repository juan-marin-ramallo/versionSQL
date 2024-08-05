/****** Object:  Procedure [dbo].[DeleteFormCategory]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Matias Corso
-- Create date: 11/10/2016
-- Description:	SP para eliminar una categoría de visita
-- =============================================
CREATE PROCEDURE [dbo].[DeleteFormCategory]
(
	 @Id [sys].[int]
	 , @DeleteAsignation [sys].[bit]
)
AS
BEGIN
		UPDATE	[dbo].[FormCategory]		
		SET		[EditedDate] = GETUTCDATE(),
				[Deleted] = 1 		
		WHERE	 [Id] = @Id
		
		IF @DeleteAsignation = 1
		BEGIN
			UPDATE [dbo].[Form]
			SET [IdFormCategory] = NULL
			WHERE [IdFormCategory] = @Id
		END
END
