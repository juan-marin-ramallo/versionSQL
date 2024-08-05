/****** Object:  Procedure [dbo].[BackupGetEvent]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 02/10/2019
-- Description:	SP 
-- =============================================
CREATE PROCEDURE [dbo].[BackupGetEvent]
(
  @LimitDate [sys].[DATETIME]
)
AS
BEGIN
  SELECT a.[Id],a.[Date],a.[IdPersonOfInterest],a.[Type]
  FROM [dbo].[Event] a WITH(NOLOCK)
  WHERE a.[Date] < @LimitDate
  GROUP BY a.[Id],a.[Date],a.[IdPersonOfInterest],a.[Type]
  ORDER BY a.[Id] ASC
END
