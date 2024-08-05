/****** Object:  Procedure [dbo].[DisablePersonOfInterest]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 13/07/2018
-- Description:	SP para desactivar una personas
-- =============================================
CREATE PROCEDURE [dbo].[DisablePersonOfInterest]
(
	 @Id [sys].[int]
)
AS
BEGIN

	UPDATE	[dbo].[PersonOfInterest]
	SET		[Pending] = 1, [Status] = 'D'
	WHERE	Id = @Id

END
