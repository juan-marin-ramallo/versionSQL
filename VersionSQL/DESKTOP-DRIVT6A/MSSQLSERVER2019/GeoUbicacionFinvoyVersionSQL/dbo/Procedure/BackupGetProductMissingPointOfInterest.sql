/****** Object:  Procedure [dbo].[BackupGetProductMissingPointOfInterest]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 02/10/2019
-- Description:	SP 
-- =============================================
CREATE PROCEDURE [dbo].[BackupGetProductMissingPointOfInterest]
(
  @LimitDate [sys].[DATETIME]
)
AS
BEGIN
  SELECT a.[Id], a.[IdPointOfInterest], a.[IdPersonOfInterest], a.[Date], a.[ReceivedDate],a.[MissingConfirmation],a.[IdProductMissingType],a.[Deleted]
    FROM [dbo].ProductMissingPointOfInterest a WITH(NOLOCK)
  WHERE a.[Date] < @LimitDate
  GROUP BY a.[Id], a.[IdPointOfInterest], a.[IdPersonOfInterest], a.[Date], a.[ReceivedDate],a.[MissingConfirmation],a.[IdProductMissingType],a.[Deleted]
  ORDER BY a.[Id] ASC
END
