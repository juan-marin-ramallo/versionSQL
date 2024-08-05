/****** Object:  Procedure [dbo].[BackupGetMessagePersonOfInterest]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 02/10/2019
-- Description:	SP 
-- =============================================
CREATE PROCEDURE [dbo].[BackupGetMessagePersonOfInterest]
(
  @LimitDate [sys].[DATETIME]
)
AS
BEGIN
  SELECT a.[Id],a.[IdMessage],a.[IdPersonOfInterest],a.[Received],a.[ReceivedDate],a.[Read],a.[ReadDate]
  FROM [dbo].MessagePersonOfInterest a WITH(NOLOCK)
	INNER JOIN [dbo].Message b WITH(NOLOCK) ON a.IdMessage = b.Id
  WHERE b.[Date] < @LimitDate
  GROUP BY a.[Id],a.[IdMessage],a.[IdPersonOfInterest],a.[Received],a.[ReceivedDate],a.[Read],a.[ReadDate]
  ORDER BY a.[Id] ASC
END
