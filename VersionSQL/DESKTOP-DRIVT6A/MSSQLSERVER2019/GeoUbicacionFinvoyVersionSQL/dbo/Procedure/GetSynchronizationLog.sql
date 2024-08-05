/****** Object:  Procedure [dbo].[GetSynchronizationLog]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 12/08/2016
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[GetSynchronizationLog]
(
	@DateFrom [DateTime] = null
	,@DateTo [DateTime] = null
	,@SyncTypes [varchar](1000) = null
)
AS
BEGIN

	SELECT s.[Id],s.[Date],s.[SyncType], s.[SyncSaveType],s.[Errors],s.[TotalCount],s.[SuccessCount],s.[ErrorCount],s.[Exception], IIF(s.RequestBody IS NULL, 0, 1) AS HasRequestBody
	FROM [dbo].[SynchronizationLog] s
	WHERE ((@DateFrom IS NULL AND @DateTo IS NULL AND NOT EXISTS (SELECT TOP 1 1 FROM SynchronizationLog s2 WHERE s2.SyncType = s.SyncType AND s2.Id > s.id))
			OR s.[Date] BETWEEN @DateFrom AND @DateTo)
			AND ((@SyncTypes IS NULL) OR (dbo.CheckValueInList(s.[SyncType], @SyncTypes) = 1))
	ORDER BY s.[Date] DESC, s.[SyncType] ASC
END
