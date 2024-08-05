/****** Object:  Procedure [dbo].[BackupDeleteIncident]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 02/10/2019
-- Description:	SP 
-- =============================================
CREATE PROCEDURE [dbo].[BackupDeleteIncident]
(
	 @LimitDate [sys].[DATETIME]
)
AS
BEGIN
	DELETE a
	FROM [dbo].[Incident] a WITH(NOLOCK)
	WHERE a.[CreatedDate] < @LimitDate
END
