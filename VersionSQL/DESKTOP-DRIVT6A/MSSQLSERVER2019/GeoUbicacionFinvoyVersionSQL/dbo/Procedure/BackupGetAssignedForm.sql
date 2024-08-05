/****** Object:  Procedure [dbo].[BackupGetAssignedForm]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 02/10/2019
-- Description:	SP 
-- =============================================
CREATE PROCEDURE [dbo].[BackupGetAssignedForm]
(
  @LimitDate [sys].[DATETIME]
)
AS
BEGIN
  SELECT a.[Id],a.[IdForm],a.[IdPointOfInterest],a.[Date],a.[Deleted],a.[DeletedDate],a.[IdPersonOfInterest]
  FROM [dbo].AssignedForm a WITH(NOLOCK)
  WHERE a.[Date] < @LimitDate
  GROUP BY a.[Id],a.[IdForm],a.[IdPointOfInterest],a.[Date],a.[Deleted],a.[DeletedDate],a.[IdPersonOfInterest]
  ORDER BY a.[Id] ASC
END
