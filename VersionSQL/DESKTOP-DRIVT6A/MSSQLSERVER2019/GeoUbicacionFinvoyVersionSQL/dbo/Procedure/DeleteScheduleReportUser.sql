/****** Object:  Procedure [dbo].[DeleteScheduleReportUser]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[DeleteScheduleReportUser](
    @IdScheduleReport [sys].[int]
   ,@IdUser [sys].[int]
)
AS 
BEGIN

	DELETE FROM [dbo].[ScheduleReportUser]
	WHERE [IdScheduleReport] = @IdScheduleReport AND [IdUser] = @IdUser

END
