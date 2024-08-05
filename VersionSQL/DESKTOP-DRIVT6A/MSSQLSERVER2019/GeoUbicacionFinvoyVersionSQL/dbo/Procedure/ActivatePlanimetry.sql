/****** Object:  Procedure [dbo].[ActivatePlanimetry]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Gastón Legnani
-- Create date: 09/08/2016
-- Description:	SP para activar una planimetria
-- =============================================
CREATE PROCEDURE [dbo].[ActivatePlanimetry] 
	@Id [sys].[int]
AS
BEGIN
	UPDATE	[dbo].[Planimetry]
	SET		[Deleted] = 0, [DeletedDate] = NULL
	WHERE	[Id] = @Id
END
