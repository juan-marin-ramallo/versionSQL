﻿/****** Object:  Procedure [dbo].[BackupDeleteAssignedForm]    Committed by VersionSQL https://www.versionsql.com ******/

  
  -- =============================================
-- Author:		Federico Sobral
-- Create date: 02/10/2019
-- Description:	SP 
-- =============================================
CREATE PROCEDURE [dbo].[BackupDeleteAssignedForm]
(
  @LimitDate [sys].[DATETIME]
)
AS
BEGIN
  DELETE a
  FROM [dbo].AssignedForm a WITH(NOLOCK)
  WHERE a.[Date] < @LimitDate
END