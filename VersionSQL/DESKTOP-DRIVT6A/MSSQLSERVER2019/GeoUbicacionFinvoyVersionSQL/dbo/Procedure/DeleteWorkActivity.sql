/****** Object:  Procedure [dbo].[DeleteWorkActivity]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		NR
-- Create date: 10/03/2017
-- Description:	SP para guardar un plan
-- =============================================
CREATE PROCEDURE [dbo].[DeleteWorkActivity]
	 @Id [sys].[int]
AS
BEGIN

	BEGIN 
		UPDATE	[dbo].[WorkActivity]
		SET		[Deleted] = 1,
				[Synced] = 0,
				[SyncType] = 4 -- Outlook Delete
		WHERE	[Id] = @Id
	END

END
