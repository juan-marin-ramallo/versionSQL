/****** Object:  Procedure [dbo].[DeleteCustomReportFields]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================  
-- Author:  <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
-- =============================================  
CREATE PROCEDURE [dbo].[DeleteCustomReportFields]  
 @IdCustomReport int  
AS  
BEGIN  
   
 DELETE FROM CustomReportField  
 WHERE [IdCustomReport] = @IdCustomReport  
  
 DELETE FROM CustomReportForm  
 WHERE [IdCustomReport] = @IdCustomReport  
  
  DELETE FROM CustomReportDynamic  
  WHERE [IdCustomReport] = @IdCustomReport
END
