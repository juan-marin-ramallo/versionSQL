/****** Object:  Procedure [dbo].[DeleteScheduleReportUserEmail]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[DeleteScheduleReportUserEmail](
    @IdScheduleReport [sys].[int]
   ,@Email [sys].[varchar](100)
)
AS 
BEGIN

	DELETE FROM [dbo].[ScheduleReportUserEmail]
	WHERE [IdScheduleReport] = @IdScheduleReport AND [Email] = @Email

END
