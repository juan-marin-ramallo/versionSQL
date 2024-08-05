/****** Object:  Procedure [dbo].[SaveSynchronizationLog]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 20/04/2015
-- Description:	SP para sincronizar los Productos
-- =============================================
CREATE PROCEDURE [dbo].[SaveSynchronizationLog]
(
	 @SyncType [int]
	 ,@SyncSaveType [smallint]
	 ,@TotalCount [int]
	 ,@ErrorCount [int]
	 ,@SuccessCount [int]
	 ,@Errors [bit]
	 ,@ExMessage [varchar](2048) = null
	 ,@RequestBody [varchar](max) = NULL
	 ,@Data [SynchronizationErrorTableType] READONLY
)
AS
BEGIN
	INSERT INTO [dbo].[SynchronizationLog] ([Date],[SyncType], [SyncSaveType],[Errors],[TotalCount],[SuccessCount],[ErrorCount],[Exception],[RequestBody])
	VALUES (GETUTCDATE(), @SyncType, @SyncSaveType, @Errors, @TotalCount, @SuccessCount, @ErrorCount, @ExMessage, IIF(@RequestBody IS NULL, NULL, COMPRESS(@RequestBody)))

	DECLARE @SyncId [int] = SCOPE_IDENTITY()

	INSERT INTO [dbo].[SynchronizationLogError]([IdSynchronizationLog],[Class],[Data],[ErrorType])
    SELECT	@SyncId, s.Class, s.Data, s.ErrorType 
	FROM	@Data AS S

END
