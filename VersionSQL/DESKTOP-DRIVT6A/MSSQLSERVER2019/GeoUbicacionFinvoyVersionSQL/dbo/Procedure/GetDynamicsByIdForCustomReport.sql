/****** Object:  Procedure [dbo].[GetDynamicsByIdForCustomReport]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================  
-- Author:  <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
-- =============================================  
CREATE PROCEDURE [dbo].[GetDynamicsByIdForCustomReport]  
 @IdDynamics varchar(max)  
AS  
BEGIN  
   
 SELECT D.[Id]  
 FROM dbo.[Dynamic] D with (NOLOCK)  
 WHERE  (@IdDynamics IS NULL OR dbo.CheckValueInList(D.[Id], @IdDynamics) = 1)   
END
