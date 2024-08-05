/****** Object:  Procedure [dbo].[UpdateWorkPlanMicrosoftEventId]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		FS
-- Create date: 15/09/2017
-- Description:	SP para actualizar los ids de outlook
-- =============================================
CREATE PROCEDURE [dbo].[UpdateWorkPlanMicrosoftEventId]
    (
      @WorkActivities [IdMicrosoftIdTableType] READONLY
    )
AS
    BEGIN
        UPDATE  wa
        SET     wa.MicrosoftEventId = a.MicrosoftId,
				wa.Synced = 1
        FROM    [dbo].WorkActivity wa
                INNER JOIN @WorkActivities a ON a.Id = wa.Id;

        UPDATE  m
        SET     m.MicrosoftEventId = a.MicrosoftId,
				m.Synced = 1
        FROM    [dbo].[Meeting] m
                INNER JOIN @WorkActivities a ON a.MeetingId = m.Id;
    END;
