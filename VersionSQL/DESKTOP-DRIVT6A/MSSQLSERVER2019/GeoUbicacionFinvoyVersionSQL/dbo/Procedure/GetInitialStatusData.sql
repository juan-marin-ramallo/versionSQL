/****** Object:  Procedure [dbo].[GetInitialStatusData]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================  
-- Author:  jgil  
-- Create date: 30/08/23  
-- Description:   
-- =============================================  
CREATE PROCEDURE [dbo].[GetInitialStatusData]   
 -- Add the parameters for the stored procedure here  
   
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
  
    -- Insert statements for procedure here  
 SELECT OS.[Id], OS.[Name], OS.[Description], OS.[Abbreviation], OS.[IsInitial], OS.[IsFinal], OS.[CanEdit], OS.[CanEditPrice]  
 FROM [OrderStatus] OS  
 WHERE OS.[IsInitial] = 1
END
