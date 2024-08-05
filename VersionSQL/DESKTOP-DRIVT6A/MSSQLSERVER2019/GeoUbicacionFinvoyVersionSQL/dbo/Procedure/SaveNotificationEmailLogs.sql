/****** Object:  Procedure [dbo].[SaveNotificationEmailLogs]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 27/03/2019
-- Description:	SP para guardar el reporte de Share of Shelf
-- =============================================
CREATE PROCEDURE [dbo].[SaveNotificationEmailLogs]
(
	@EmailLog [NotificationEmailLogTableType] READONLY
)
AS
BEGIN
	
	INSERT INTO [dbo].[NotificationEmailLog]
           ([CodeNotification]
           ,[Date]
           ,[Sent]
           ,[Email]
           ,[IdUser]
           ,[IdPersonOfInterest]
           ,[TriesCount])
     SELECT [CodeNotification]
           ,[Date]
           ,[Sent]
           ,[Email]
           ,[IdUser]
           ,[IdPersonOfInterest]
           ,[TriesCount]
	FROM @EmailLog

END
