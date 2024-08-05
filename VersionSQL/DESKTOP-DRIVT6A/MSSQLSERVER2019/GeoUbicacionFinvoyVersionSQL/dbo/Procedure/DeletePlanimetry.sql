/****** Object:  Procedure [dbo].[DeletePlanimetry]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Gastón Legnani
-- Create date: 09/08/2016
-- Description:	SP para eliminar una planimetria
-- =============================================
CREATE PROCEDURE [dbo].[DeletePlanimetry] 
	@Id [sys].[int]
AS
BEGIN
	UPDATE	[dbo].[Planimetry]
	SET		[Deleted] = 1, [DeletedDate] = GETUTCDATE()
	WHERE	[Id] = @Id
END
