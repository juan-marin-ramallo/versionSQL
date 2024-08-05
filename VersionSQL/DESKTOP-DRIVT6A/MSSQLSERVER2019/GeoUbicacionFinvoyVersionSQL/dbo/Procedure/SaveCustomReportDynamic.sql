/****** Object:  Procedure [dbo].[SaveCustomReportDynamic]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================  
-- Author:  <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
-- =============================================  
CREATE PROCEDURE [dbo].[SaveCustomReportDynamic]  
  @IdCustomReport int  
 ,@IdDynamic int  
AS  
BEGIN  
   
 INSERT INTO CustomReportDynamic([IdCustomReport], [IdDynamic])  
 VALUES (@IdCustomReport, @IdDynamic)  
  
END
