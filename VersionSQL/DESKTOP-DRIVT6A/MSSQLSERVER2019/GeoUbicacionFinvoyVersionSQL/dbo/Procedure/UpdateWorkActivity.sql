/****** Object:  Procedure [dbo].[UpdateWorkActivity]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		NR
-- Create date: 10/03/2017
-- Description:	SP para guardar un plan
-- =============================================
CREATE PROCEDURE [dbo].[UpdateWorkActivity]
    @Id [sys].[INT] ,
    @ActivityDate [sys].[DATETIME] ,
    @ActivityEndDate [sys].[DATETIME] = NULL 

AS
    BEGIN

        BEGIN 
            Update [dbo].WorkActivity
            set ActivityDate = @ActivityDate,
			ActivityEndDate = @ActivityEndDate,
			Synced = 0,
			SyncType = 1 -- Outlook Event
            where Id = @Id
        END;

    END;
