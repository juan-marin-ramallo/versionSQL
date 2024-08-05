/****** Object:  Procedure [dbo].[ConfirmAllPointsOfInterest]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		FS
-- Create date: 29/08/19
-- Description:	SP para activar todos los puntos pendientes
-- =============================================
CREATE PROCEDURE [dbo].[ConfirmAllPointsOfInterest]
AS
BEGIN

	UPDATE	[dbo].[PointOfInterest]
	SET		[Deleted] = 0
			,[Pending] = 0
	WHERE	[Pending] = 1
			
END
