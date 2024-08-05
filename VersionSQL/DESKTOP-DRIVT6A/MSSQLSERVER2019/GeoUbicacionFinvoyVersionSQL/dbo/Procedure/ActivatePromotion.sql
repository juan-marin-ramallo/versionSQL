/****** Object:  Procedure [dbo].[ActivatePromotion]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Gastón Legnani
-- Create date: 26/07/2016
-- Description:	SP para activar una promoción
-- =============================================
CREATE PROCEDURE [dbo].[ActivatePromotion] 
	@Id [sys].[int]
AS
BEGIN
	UPDATE	[dbo].[Promotion]
	SET		[Deleted] = 0, [DeletedDate] = NULL
	WHERE	[Id] = @Id
END
