/****** Object:  Procedure [dbo].[UpdateCustomReport]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================  
-- Author:  <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
-- =============================================  
CREATE PROCEDURE [dbo].[UpdateCustomReport]  
  @Id int  
 ,@Name varchar(100)  
 --,@TypeIds dbo.IdTableType readonly  
 --,@IdForm int = NULL  
 ,@TemplateFilename varchar(200)  
 ,@IdUser int = NULL -- dont update user  
AS  
BEGIN  
   
 UPDATE CustomReport  
 SET   [Name] = @Name  
   --,[IdType] = @IdType  
   --,[IdForm] = @IdForm  
   ,[TemplateFilename] = @TemplateFilename  
   ,[EditedDate] = GETUTCDATE()  
 WHERE [Id] = @Id  
  
 --DELETE CRT  
 --FROM CustomReportCustomReportType CRT   
 -- LEFT OUTER JOIN @TypeIds T ON CRT.IdCustomReport = @Id AND CRT.IdCustomReportType = T.Id  
 --WHERE CRT.IdCustomReport = @Id AND T.Id IS NULL  
    
 --INSERT INTO dbo.CustomReportcustomReportType(IdCustomReport, IdCustomReportType)  
 --SELECT @Id, T.Id  
 --FROM @TypeIds T  
 -- LEFT OUTER JOIN CustomReportCustomReportType CRT ON CRT.IdCustomReport = @Id AND CRT.IdCustomReportType = T.Id  
 --WHERE CRT.IdCustomReport IS NULL  
  
END
