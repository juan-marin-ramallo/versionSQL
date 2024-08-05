/****** Object:  Procedure [dbo].[SyncCustomAttributeValue]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================  
-- Author:  <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
-- =============================================  
CREATE PROCEDURE [dbo].[SyncCustomAttributeValue]  
  @PointOfInterestIdentifier varchar(50)  
 ,@CustomAttributeName varchar(100)  
 ,@CustomAttributeValue varchar(MAX) = NULL  
 ,@CustomAttributeOptionText varchar(MAX) = NULL  
AS  
BEGIN  
  
 DECLARE @IdPointOfInterest int = (SELECT [Id] FROM PointOfInterest WHERE [Identifier] = @PointOfInterestIdentifier AND [Deleted] = 0)  
 DECLARE @IdCustomAttribute int = (SELECT [Id] FROM CustomAttribute WHERE [Name] = @CustomAttributeName AND [Deleted] = 0)  
  
 IF (@IdPointOfInterest IS NULL OR @IdCustomAttribute IS NULL) BEGIN   
  SELECT @PointOfInterestIdentifier, @CustomAttributeName, @CustomAttributeValue,   
  IIF(@IdPointOfInterest IS NULL, 1, 0), IIF(@IdCustomAttribute IS NULL, 1, 0)  
 END ELSE BEGIN  
  
  DECLARE @IdCustomAttributeOption INT;
  SELECT @IdCustomAttributeOption = MIN(Id) FROM CustomAttributeOption WHERE IdCustomAttribute = @IdCustomAttribute AND LOWER(Text) = LOWER(@CustomAttributeOptionText)
  EXEC dbo.UpdateCustomAttributeValue @IdCustomAttribute, @IdPointOfInterest, @CustomAttributeValue, @IdCustomAttributeOption  
   
 END  
END
