/****** Object:  Procedure [dbo].[GetOrderTrazability]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================  
-- Author:  jgil  
-- Create date: 02/08/2023  
-- Description:   
-- =============================================  
CREATE PROCEDURE [dbo].[GetOrderTrazability]   
 -- Add the parameters for the stored procedure here  
 @OrderId [sys].[int]  
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
  
    -- Insert statements for procedure here  
 SELECT [IdOrderReport], [IdProduct], [ProductName], [Quantity], [IsModification], [ProductPrice], [Status] 
 FROM OrderReportTrazability  
 WHERE [IdOrderReport] = @OrderId  
END
