/****** Object:  Procedure [dbo].[SaveCustomReport]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================        
-- Author:  <Author,,Name>        
-- Create date: <Create Date,,>        
-- Description: <Description,,>        
-- =============================================        
CREATE PROCEDURE [dbo].[SaveCustomReport]        
  @Name varchar(100)        
 ,@TypeIds [dbo].IdTableType readonly        
 ,@IdForms varchar(1000) = NULL        
 ,@TemplateFilename varchar(200)        
 ,@IdUser int = NULL        
 ,@IdDynamics varchar(1000) = NULL        
AS        
BEGIN        
         
 DECLARE @Id sys.int        
        
 INSERT INTO CustomReport ([Name], [IdType], [TemplateFilename], [IdUser], [CreateDate], [EditedDate])        
 VALUES (@Name, NULL, @TemplateFilename, @IdUser, GETUTCDATE(), GETUTCDATE())         
        
 SET @Id = SCOPE_IDENTITY()        
        
 INSERT INTO dbo.CustomReportcustomReportType(IdCustomReport, IdCustomReportType)        
 SELECT @Id, T.Id        
 FROM @TypeIds T        
        
 IF @IdForms like ',%'        
 BEGIN        
  INSERT INTO [dbo].[CustomReportForm]([IdForm], [IdCustomReport])        
  SELECT  F.[Id] ,@Id AS IdCustomReport        
  FROM dbo.Form F WITH (NOLOCK)        
  WHERE   (@IdForms IS NULL OR dbo.CheckValueInList(F.[Id], @IdForms) = 1) AND F.[Deleted] = 0        
  order by F.[Id] asc        
 END        
    
 IF @IdDynamics like ',%'        
 BEGIN        
  INSERT INTO [dbo].[CustomReportDynamic]([IdDynamic], [IdCustomReport])        
  SELECT  D.[Id] ,@Id AS IdCustomReport        
  FROM dbo.[Dynamic] D WITH (NOLOCK)        
  WHERE   (@IdDynamics IS NULL OR dbo.CheckValueInList(D.[Id], @IdDynamics) = 1) AND D.[Deleted] = 0        
  order by D.[Id] asc        
 END        
 SELECT @Id        
END
