/****** Object:  Procedure [dbo].[BackupGetDocumentReport]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 02/10/2019
-- Description:	SP 
-- =============================================
CREATE PROCEDURE [dbo].[BackupGetDocumentReport]
(
  @LimitDate [sys].[DATETIME]
)
AS
BEGIN
  SELECT a.[Id],a.[IdDocument],a.[DocumentType],a.[IdPointOfInterest],a.[IdPersonOfInterest],a.[Date],a.[ImageEncoded],a.[ImageEncoded2],a.[ImageEncoded3],a.[ReceivedDate],a.[IsFullfilled]
  FROM [dbo].DocumentReport a WITH(NOLOCK)
  WHERE a.[Date] < @LimitDate
  GROUP BY a.[Id],a.[IdDocument],a.[DocumentType],a.[IdPointOfInterest],a.[IdPersonOfInterest],a.[Date],a.[ImageEncoded],a.[ImageEncoded2],a.[ImageEncoded3],a.[ReceivedDate],a.[IsFullfilled]
  ORDER BY a.[Id] ASC
END
