/****** Object:  Procedure [dbo].[BackupGetSynchronizationLogError]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[BackupGetSynchronizationLogError]
(
  @LimitDate [sys].[DATETIME]
)
AS
BEGIN
  SELECT a.[Id],a.[IdSynchronizationLog],a.[Class],a.[Data],a.[ErrorType]
  FROM [dbo].SynchronizationLogError a WITH(NOLOCK)
	INNER JOIN dbo.[SynchronizationLog] b WITH(NOLOCK) ON a.IdSynchronizationLog = b.Id
  WHERE b.[Date] < @LimitDate
  GROUP BY a.[Id],a.[IdSynchronizationLog],a.[Class],a.[Data],a.[ErrorType]
  ORDER BY a.[Id] ASC
END
